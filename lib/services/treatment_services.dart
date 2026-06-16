import 'dart:convert';

import '../models/requests/save_history_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/treatment_area_response.dart';
import '../models/responses/treatment_sub_area_response.dart';
import '../repositories/treatment_repository.dart';

import '../exceptions/app_exception.dart';
import '../models/responses/auth_response.dart';
import '../models/responses/treatment_response_model.dart';
import '../utills/enums.dart';
import 'api_base_helper.dart';

class TreatmentService implements TreatmentRepository {
  final ApiBaseHelper _apiClient;
  TreatmentService({required ApiBaseHelper apiClient}) : _apiClient = apiClient;

  @override
  Future<TreatmentResponse> getTreatmentsApi() async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.getTreatments,
      requestType: 'GET',
      params: '',
    );
    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      TreatmentResponse treatmentResponse = TreatmentResponse.fromJson(parsed);
      return treatmentResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(AuthResponse.fromJson(parsed).message as String);
    }
  }

  @override
  Future<TreatmentAreaResponse> getAreasByTreatmentId({
    required int treatmentId,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.treatments,
      requestType: 'GET',
      params: '/$treatmentId/areas',
    );
    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      TreatmentAreaResponse selectSelectionResponse =
          TreatmentAreaResponse.fromJson(parsed);
      return selectSelectionResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(AuthResponse.fromJson(parsed).message as String);
    }
  }

  @override
  Future<TreatmentSubAreaResponse> getSubSectionApi({
    required int sectionId,
    required int subSectionId,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.treatments,
      requestType: 'GET',
      params: '/$sectionId/areas/$subSectionId/sideareas',
    );
    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      TreatmentSubAreaResponse subSelectionResponse =
          TreatmentSubAreaResponse.fromJson(parsed);
      return subSelectionResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(AuthResponse.fromJson(parsed).message as String);
    }
  }

  @override
  Future<void> saveAiHistory(SaveHistoryRequest request) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.simulationHistory,
      requestType: 'POST',
      requestBody: request.toJson(),
    );
    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      final _ = BaseResponseModel.fromJson(parsed);
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(AuthResponse.fromJson(parsed).message as String);
    }
  }
}
