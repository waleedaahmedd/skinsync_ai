import 'dart:convert';

import '../exceptions/app_exception.dart';
import '../models/responses/get_appointment_response.dart';
import '../repositories/appointment_repository.dart';
import 'api_base_helper.dart';
import '../utills/enums.dart';

import '../models/responses/simulation_history_response.dart';

class AppointmentService implements AppointmentRepository {
  final ApiBaseHelper _apiClient;
  AppointmentService({required ApiBaseHelper apiClient})
    : _apiClient = apiClient;
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
      GetAppointmentResponse appointmentResponse =
          GetAppointmentResponse.fromJson(parsed);
      return appointmentResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(
        GetAppointmentResponse.fromJson(parsed).message as String,
      );
    }
  }

  @override
  Future<List<SimulationData>> getSimulationHistory() async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.simulationHistory,
      requestType: 'GET',
    );
    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      final appointmentResponse = SimulationHistoryResponse.fromJson(parsed);
      return appointmentResponse.data ?? [];
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(
        GetAppointmentResponse.fromJson(parsed).message as String,
      );
    }
  }
}
