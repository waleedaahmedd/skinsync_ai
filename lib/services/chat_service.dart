import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../exceptions/app_exception.dart';
import '../models/responses/chats_response.dart';
import '../models/responses/messages_response.dart';
import '../repositories/chat_repository.dart';
import '../utils/enums.dart';
import '../utils/secure_storage_service.dart';
import 'api_base_helper.dart';
import 'auth_service.dart';

class ChatService extends ChatRepository {
  final ApiBaseHelper _apiService;
  final Map<int, WebSocket> _chatSockets = {};
  final Map<int, StreamSubscription<dynamic>> _chatSubscriptions = {};
  final Map<int, StreamSubscription<dynamic>> _connections = {};

  ChatService({required this._apiService});

  @override
  Future<ChatsData> getChats({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    String params = '?page=$page&limit=$limit';
    if (search != null && search.isNotEmpty) {
      params += '&search=$search';
    }
    final response = await _apiService.httpRequest(
      endPoint: EndPoints.chats,
      requestType: RequestType.get,
      params: params,
    );
    final parsed = json.decode(response.body);
    final model = ChatsResponse.fromJson(parsed);
    if (model.isSuccess != true) {
      throw AppException(model.message ?? 'Something went wrong!');
    }
    return model.data!;
  }

  @override
  Future<MessagesData> getMessages({
    required int chatId,
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    String params = '?id=$chatId&page=$page&limit=$limit';
    if (search != null) {
      params += '&search=$search';
    }
    final response = await _apiService.httpRequest(
      endPoint: EndPoints.messages,
      requestType: RequestType.get,
      params: params,
    );
    final parsed = json.decode(response.body);
    final model = MessagesResponse.fromJson(parsed);
    if (model.isSuccess != true) {
      throw AppException(model.message ?? 'Something went wrong!');
    }
    final userData = await AuthService(apiClient: _apiService).getMe();
    final user = userData.user;
    if (user == null) {
      throw const AppException('User not found');
    }
    return model.data!.copyWith(
      messages: model.data!.messages!
          .map((message) => message.copyWith(userId: user.id))
          .toList(),
    );
  }

  @override
  Future<void> connectChatSocket({
    required int chatId,
    required void Function(Message message) onMessage,
  }) async {
    if (_chatSockets.containsKey(chatId)) {
      return;
    }
    final userData = await AuthService(apiClient: _apiService).getMe();
    final user = userData.user;
    if (user == null) {
      throw const AppException('User not found');
    }
    final token = await SecureStorage().getToken();
    final socketUri = Uri.parse(
      '${_apiService.baseUrl}chat/$chatId/ws',
    ).replace(scheme: _apiService.baseUrl.startsWith('https') ? 'wss' : 'ws');
    log('TOKEN: $token');

    final socket = WebSocket(
      socketUri,
      headers: {'Authorization': 'Bearer $token'},
    );

    _chatSockets[chatId] = socket;

    final subscription = socket.messages.listen(
      (event) {
        try {
          final payload = jsonDecode(event as String) as Map<String, dynamic>;
          final message = Message.fromJson(payload).copyWith(userId: user.id);
          onMessage(message);
        } catch (_) {
          if (event is String) {
            final error = jsonDecode(event)['error'];
            EasyLoading.showError(error);
          } else {
            log('ERROR: $event');
          }
        }
      },
      onDone: () {
        _chatSubscriptions.remove(chatId);
        _chatSockets.remove(chatId);
      },
      onError: (error) {
        EasyLoading.showError(error.toString());
        _chatSubscriptions.remove(chatId);
        _chatSockets.remove(chatId);
      },
    );

    final connection = socket.connection.listen((connection) {
      log('CONNECTION: ${connection.runtimeType}');
      if (connection is Disconnecting) {
        closeChatSocket(chatId: chatId);
      }
    });

    _connections[chatId] = connection;
    _chatSubscriptions[chatId] = subscription;
  }

  @override
  Future<void> closeChatSocket({required int chatId}) async {
    final socket = _chatSockets[chatId];
    socket?.close();
    final subscription = _chatSubscriptions[chatId];
    final connection = _connections[chatId];
    await subscription?.cancel();
    await connection?.cancel();

    _chatSubscriptions.remove(chatId);
    _connections.remove(chatId);
    _chatSockets.remove(chatId);
  }

  @override
  Future<void> sendChatMessage({
    required int chatId,
    required MessageType type,
    required String content,
    String? mediaUrl,
    String? documentUrl,
  }) async {
    final socket = _chatSockets[chatId];
    if (socket == null) {
      throw const AppException('Websocket not connected');
    }

    final payload = <String, dynamic>{
      'type': type.value,
      'content': content,
      if (type == MessageType.media) 'media_url': mediaUrl,
      if (type == MessageType.document) 'document_url': documentUrl,
    };

    socket.send(jsonEncode(payload));
  }
}
