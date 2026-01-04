import 'dart:convert';

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
}
