import 'dart:convert';

import '../exceptions/app_exception.dart';
import '../models/responses/treatment_category_list_response.dart';
import '../repositories/treatment_category_repository.dart';
import '../utills/enums.dart';
import 'api_base_helper.dart';

class TreatmentCategoryService implements TreatmentCategoryRepository {
  final ApiBaseHelper _apiClient;
  TreatmentCategoryService({required this._apiClient});

  @override
  Future<TreatmentCategoryListResponse> getCategoriesApi() async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.categories,
      requestType: .get,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      return TreatmentCategoryListResponse.fromJson(parsed);
    } else {
      final parsed = json.decode(response.body);
      throw AppException(
        TreatmentCategoryListResponse.fromJson(parsed).message ??
            "Failed to fetch categories",
      );
    }
  }
}
