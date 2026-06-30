import 'dart:convert';

import '../models/requests/save_history_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/treatment_list_response.dart';
import '../models/responses/treatment_area_list_response.dart';
import '../models/responses/treatment_detail_response.dart';
import '../repositories/treatment_repository.dart';

import '../exceptions/app_exception.dart';
import '../models/responses/auth_response.dart';
import '../utills/enums.dart';
import 'api_base_helper.dart';

class TreatmentService implements TreatmentRepository {
  final ApiBaseHelper _apiClient;
  TreatmentService({required ApiBaseHelper apiClient}) : _apiClient = apiClient;

  @override
  Future<TreatmentListResponse> getTreatments({
    String? search,
    int? categoryId,
    int? areaId,
    int page = 1,
    int limit = 10,
    bool? isSimulator,
  }) async {
    final Map<String, String> queryParams = {};
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (categoryId != null) {
      queryParams['category_id'] = categoryId.toString();
    }
    if (areaId != null) {
      queryParams['area_id'] = areaId.toString();
    }
    queryParams['page'] = page.toString();
    queryParams['limit'] = limit.toString();
    if (isSimulator != null) {
      queryParams['is_simulator'] = isSimulator.toString();
    }

    final queryString = Uri(queryParameters: queryParams).query;
    final params = queryString.isNotEmpty ? '?$queryString' : '';

    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.treatmentList,
      requestType: 'GET',
      params: params,
    );
    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      TreatmentListResponse treatmentListResponse = TreatmentListResponse.fromJson(parsed);
      return treatmentListResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(AuthResponse.fromJson(parsed).message as String);
    }
  }

  @override
  Future<TreatmentAreaListResponse> getAreasByTreatmentId({
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
      TreatmentAreaListResponse selectSelectionResponse =
          TreatmentAreaListResponse.fromJson(parsed);
      return selectSelectionResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(AuthResponse.fromJson(parsed).message as String);
    }
  }

  @override
  Future<TreatmentAreaListResponse> getSubSectionApi({
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
      TreatmentAreaListResponse subSelectionResponse =
          TreatmentAreaListResponse.fromJson(parsed);
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

  @override
  Future<TreatmentDetailResponse> getTreatmentDetail({
    required int treatmentId,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.treatments,
      requestType: 'GET',
      params: '/$treatmentId',
    );
    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      TreatmentDetailResponse detailResponse = TreatmentDetailResponse.fromJson(parsed);
      return detailResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(AuthResponse.fromJson(parsed).message as String);
    }
  }
}
