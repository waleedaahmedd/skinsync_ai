import 'dart:convert';

import '../exceptions/app_exception.dart';

import '../models/responses/base_response_model.dart';
import '../models/responses/notification_response.dart';
import '../repositories/notification_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';

class NotificationService implements NotificationRepository {
  final ApiBaseHelper _apiClient;
  NotificationService({required this._apiClient});
  @override
  Future<NotificationResponse> fetchNotification({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.notification,
      requestType: .get,
      params: '?page=$page&limit=$limit',
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      NotificationResponse questionResponse =
          NotificationResponse.fromJson(parsed);
      return questionResponse;
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        NotificationResponse.fromJson(parsed).message as String,
      );
    }
  }
  @override
  Future<BaseResponseModel> callNotificationStatus({
   required Status status
  }) async {
     final response = await _apiClient.httpRequest(
      endPoint: EndPoints.notificationstatus,
      requestType: .post,
      requestBody: {
        'status':status.name
      }
     
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      BaseResponseModel questionResponse =
          BaseResponseModel.fromJson(parsed);
      return questionResponse;
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        BaseResponseModel.fromJson(parsed).message as String,
      );
    }
  }

}
