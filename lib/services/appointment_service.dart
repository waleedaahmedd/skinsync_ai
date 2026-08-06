import 'dart:convert';

import '../exceptions/app_exception.dart';
import '../models/requests/appointment_request.dart';
import '../models/responses/appointment_detail_response.dart';
import '../models/responses/appointment_response.dart';
import '../models/responses/appointment_type_list_response.dart';
import '../models/responses/appointments_list_response.dart';
import '../repositories/appointment_repository.dart';
import 'api_base_helper.dart';
import '../utills/enums.dart';

import '../models/responses/simulation_history_response.dart';

class AppointmentService implements AppointmentRepository {
  final ApiBaseHelper _apiClient;
  AppointmentService({required this._apiClient});

  @override
  Future<AppointmentTypeListResponse> getAppointmentTypes() async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.appointmentTypes,
      requestType: 'GET',
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      return AppointmentTypeListResponse.fromJson(parsed);
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        AppointmentTypeListResponse.fromJson(parsed).message ??
            "Failed to fetch appointment types",
      );
    }
  }

  @override
  Future<AppointmentsListResponse> getAppointmentsApi({
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
      AppointmentsListResponse appointmentResponse =
          AppointmentsListResponse.fromJson(parsed);
      return appointmentResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(
        AppointmentsListResponse.fromJson(parsed).message ?? "Something went wrong",
      );
    }
  }

  @override
  Future<AppointmentDetailResponse> getAppointmentDetail({
    required int appointmentId,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.appointments,
      requestType: 'GET',
      params: '/$appointmentId',
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      return AppointmentDetailResponse.fromJson(parsed);
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        AppointmentDetailResponse.fromJson(parsed).message ?? "Failed to fetch appointment detail",
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
        parsed['message'] ?? "Something went wrong",
      );
    }
  }

  @override
  Future<AppointmentData> createAppointment({
    required AppointmentRequest request,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.appointments,
      requestType: 'POST',
      requestBody: request.toJson(),
      params: '',
    );
    final data = AppointmentResponse.fromJson(jsonDecode(response.body));
    if (!(data.status ?? false)) {
      throw AppException(data.message ?? 'Something went wrong!');
    }
    return data.data!;
  }
}
