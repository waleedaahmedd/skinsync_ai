import '../models/responses/treatment_area_list_response.dart';

abstract class TreatmentAreaRepository {
  Future<TreatmentAreaListResponse> getAreasApi();
  Future<AreaListResponse> getAreasByTreatment(int treatmentId);
}
