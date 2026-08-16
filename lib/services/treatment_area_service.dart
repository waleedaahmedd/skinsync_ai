import 'dart:convert';

import '../exceptions/app_exception.dart';
import '../models/responses/treatment_area_list_response.dart';
import '../repositories/treatment_area_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';

class TreatmentAreaService implements TreatmentAreaRepository {
  final ApiBaseHelper _apiClient;
  TreatmentAreaService({required this._apiClient});

  @override
  Future<TreatmentAreaListResponse> getAreasApi({int? treatmentId}) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.areas,
      requestType: .get,
      params: treatmentId != null ? '?treatment_id=$treatmentId' : null,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      return TreatmentAreaListResponse.fromJson(parsed);
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        TreatmentAreaListResponse.fromJson(parsed).message ??
            "Failed to fetch target areas",
      );
    }
  }
}
