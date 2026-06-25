import '../models/responses/treatment_category_list_response.dart';

abstract class TreatmentCategoryRepository {
  Future<TreatmentCategoryListResponse> getCategoriesApi();
}
