import '../models/requests/save_history_request.dart';
import '../models/responses/treatment_list_response.dart';
import '../models/responses/treatment_detail_response.dart';

abstract class TreatmentRepository {
  Future<TreatmentListResponse> getTreatments({
    String? search,
    int? categoryId,
    int? areaId,
    int page = 1,
    int limit = 10,
    bool? isSimulator,
  });
  Future<void> saveAiHistory(SaveHistoryRequest request);
  Future<TreatmentDetailResponse> getTreatmentDetail({required int treatmentId});
}
