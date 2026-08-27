import '../models/responses/notification_response.dart';

abstract class NotificationRepository {

   Future<NotificationResponse> fetchNotification({
    int page = 1,
    int limit = 20,
  });
 
}