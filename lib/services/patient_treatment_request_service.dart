import 'dart:convert';
import '../exceptions/app_exception.dart';
import '../models/responses/auth_response.dart';
import '../models/responses/patient_treatment_request_response.dart';
import '../repositories/patient_treatment_request_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';

class PatientTreatmentRequestService implements PatientTreatmentRequestRepository {
  final ApiBaseHelper _apiClient;
  PatientTreatmentRequestService({required ApiBaseHelper apiClient}) : _apiClient = apiClient;

  @override
  Future<PatientTreatmentRequestResponse> getPatientTreatmentRequests({
    required int clinicId,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.patientTreatmentRequest,
      requestType: RequestType.get,
      params: "?page=$page&limit=$limit&clinic_id=$clinicId",
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      return PatientTreatmentRequestResponse.fromJson(parsed);
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        AuthResponse.fromJson(parsed).message ?? "Failed to fetch treatment requests",
      );
    }
  }
}
