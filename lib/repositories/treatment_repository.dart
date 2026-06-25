import '../models/requests/save_history_request.dart';
import '../models/responses/treatment_area_response.dart';
import '../models/responses/treatment_list_response.dart';
import '../models/responses/treatment_sub_area_response.dart';

abstract class TreatmentRepository {
  Future<TreatmentListResponse> getTreatments({
    String? search,
    int? categoryId,
    int? areaId,
    int page = 1,
    int limit = 10,
    bool? isSimulator,
  });
  Future<TreatmentAreaResponse> getAreasByTreatmentId({
    required int treatmentId,
  });
  Future<TreatmentSubAreaResponse> getSubSectionApi({
    required int sectionId,
    required int subSectionId,
  });
  Future<void> saveAiHistory(SaveHistoryRequest request);
}
