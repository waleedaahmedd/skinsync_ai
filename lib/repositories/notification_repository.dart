import '../models/responses/base_response_model.dart';
import '../models/responses/notification_response.dart';
import '../utils/enums.dart';

abstract class NotificationRepository {

   Future<NotificationResponse> fetchNotification({
    int page = 1,
    int limit = 20,
  });
 
 Future<BaseResponseModel> callNotificationStatus({
   required Status status
  });


}