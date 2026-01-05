import 'dart:convert';

import 'package:skinsync_ai/models/responses/select_section_response.dart';
import 'package:skinsync_ai/models/responses/sub_section_response.dart';
import 'package:skinsync_ai/repositories/treatment_repository.dart';

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
  Future<SelectSelectionResponse> getSelectSectionApi({required int sectionId}) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.treatments,
      requestType: 'GET',
      params: '/$sectionId/areas',
    );
    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      SelectSelectionResponse selectSelectionResponse = SelectSelectionResponse.fromJson(parsed);
      return selectSelectionResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(AuthResponse.fromJson(parsed).message as String);
    }
  }
  
  @override
  Future<SubSelectionResponse> getSubSectionApi({required int sectionId,required int subSectionId}) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.treatments,
      requestType: 'GET',
      params: '/$sectionId/areas/$subSectionId/sideareas',
    );
    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      SubSelectionResponse subSelectionResponse = SubSelectionResponse.fromJson(parsed);
      return subSelectionResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(AuthResponse.fromJson(parsed).message as String);
    }
  }
}
