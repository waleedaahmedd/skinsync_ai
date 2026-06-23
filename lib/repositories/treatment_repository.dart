import '../models/requests/save_history_request.dart';
import '../models/responses/treatment_area_response.dart';
import '../models/responses/treatment_response_model.dart';
import '../models/responses/treatment_sub_area_response.dart';

abstract class TreatmentRepository {
  Future<TreatmentResponse> getTreatmentsApi();
  Future<TreatmentAreaResponse> getAreasByTreatmentId({
    required int treatmentId,
  });
  Future<TreatmentSubAreaResponse> getSubSectionApi({
    required int sectionId,
    required int subSectionId,
  });
  Future<void> saveAiHistory(SaveHistoryRequest request);
}
