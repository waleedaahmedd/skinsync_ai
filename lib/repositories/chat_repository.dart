import '../models/responses/chats_response.dart';
import '../models/responses/messages_response.dart';
import '../utils/enums.dart';

abstract class ChatRepository {
  Future<ChatsData> getChats({int page = 1, int limit = 10, String? search});

  Future<MessagesData> getMessages({
    required int chatId,
    int page = 1,
    int limit = 1,
    String? search,
  });

  Future<void> connectChatSocket({
    required int chatId,
    required void Function(Message message) onMessage,
  });

  Future<void> closeChatSocket({required int chatId});

  Future<void> sendChatMessage({
    required int chatId,
    required MessageType type,
    required String content,
    String? mediaUrl,
    String? documentUrl,
  });
}
