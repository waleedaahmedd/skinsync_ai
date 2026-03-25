import 'dart:convert';

import 'package:skinsync_ai/exceptions/app_exception.dart';
import 'package:skinsync_ai/models/responses/auth_response.dart';
import 'package:skinsync_ai/models/responses/get_appointment_response.dart';
import 'package:skinsync_ai/repositories/appointment_repository.dart';
import 'package:skinsync_ai/services/api_base_helper.dart';
import 'package:skinsync_ai/utills/enums.dart';

class AppointmentService implements AppointmentRepository {
   final ApiBaseHelper _apiClient;
   AppointmentService({required ApiBaseHelper apiClient}) : _apiClient = apiClient;
  @override
  Future<GetAppointmentResponse> getAppointmentsApi({
    required int page,
    required int limit,
  }) async {
     final response = await _apiClient.httpRequest(
      endPoint: EndPoints.appointments,
      requestType: 'GET',
      params: '?page=$page&limit=$limit',
    );
    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      GetAppointmentResponse appointmentResponse = GetAppointmentResponse.fromJson(parsed);
      return appointmentResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(GetAppointmentResponse.fromJson(parsed).message as String);
    }
  }
}
  

 