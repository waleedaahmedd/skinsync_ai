import 'dart:convert';

import '../exceptions/app_exception.dart';
import '../models/responses/appointment_type_list_response.dart';
import '../models/responses/get_appointment_response.dart';
import '../repositories/appointment_repository.dart';
import 'api_base_helper.dart';
import '../utills/enums.dart';

import '../models/responses/simulation_history_response.dart';

class AppointmentService implements AppointmentRepository {
  final ApiBaseHelper _apiClient;
  AppointmentService({required this._apiClient});

  @override
  Future<AppointmentTypeListResponse> getAppointmentTypes() async {
    // Returning dummy data as requested until backend API is available
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return AppointmentTypeListResponse(
      isSuccess: true,
      message: "Appointment types fetched successfully",
      data: [
        AppointmentTypeData(
          id: 1,
          name: "Consultation",
          description: "Discuss your beauty goals, ask questions, and get personalized recommendations from our world-class medical spa physicians.",
          imageUrl: "https://images.unsplash.com/photo-1579684389782-64d84b5e901a?auto=format&fit=crop&q=80&w=800",
          icon: "consultation_icon",
        ),
        AppointmentTypeData(
          id: 2,
          name: "Treatment session",
          description: "Book directly into your favorite injectables, skincare therapies, dermal fillers, and laser sessions for instant results.",
          imageUrl: "https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=800",
          icon: "treatment_icon",
        ),
      ],
    );
  }

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
