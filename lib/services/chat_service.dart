import 'dart:async';
import 'dart:convert';

import '../exceptions/app_exception.dart';
import '../models/responses/chats_response.dart';
import '../models/responses/messages_response.dart';
import '../repositories/chat_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';
import 'auth_service.dart';
import 'websocket_service.dart';

class ChatService extends ChatRepository {
  final ApiBaseHelper _apiService;

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
  Future<void> sendChatMessage({
    required int chatId,
    required MessageType type,
    required String content,
    String? mediaUrl,
    String? documentUrl,
  }) async {
    await WebSocketService().sendMessage(
      chatId: chatId,
      type: type,
      content: content,
      mediaUrl: mediaUrl,
      documentUrl: documentUrl,
    );
  }
}
