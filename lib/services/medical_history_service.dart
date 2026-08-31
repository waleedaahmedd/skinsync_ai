import 'dart:convert';

import '../exceptions/app_exception.dart';
import '../models/requests/medical_history_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/medical_history_response.dart';
import '../repositories/medical_history_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';

class MedicalHistoryService implements MedicalHistoryRepository {
  final ApiBaseHelper _apiClient;
  MedicalHistoryService({required this._apiClient});

  @override
  Future<MedicalHistoryResponse> getPatientMedicalHistory() async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.medicalHistory,
      requestType: .get,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      return MedicalHistoryResponse.fromJson(parsed);
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        MedicalHistoryResponse.fromJson(parsed).message ??
            "Failed to fetch target areas",
      );
    }
  }

  @override
  Future<BaseResponseModel> updateAlleryAndMedical(
      int? patientId,
      MedicalHistoryRequest request,
  ) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.medicalHistory,
      requestType: .patch,
      params: '/$patientId',
      requestBody: request,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      return BaseResponseModel.fromJson(parsed);
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        BaseResponseModel.fromJson(parsed).message ??
            "Failed to fetch target areas",
      );
    }
  }
}
