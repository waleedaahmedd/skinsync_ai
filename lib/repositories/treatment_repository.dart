import 'package:skinsync_ai/models/responses/select_section_response.dart';
import 'package:skinsync_ai/models/responses/sub_section_response.dart';
import 'package:skinsync_ai/models/responses/treatment_response_model.dart';

abstract class TreatmentRepository {
  Future<TreatmentResponse> getTreatmentsApi();
  Future<SelectSelectionResponse> getSelectSectionApi({required int sectionId});
  Future<SubSelectionResponse> getSubSectionApi({required int sectionId,required int subSectionId});

}
