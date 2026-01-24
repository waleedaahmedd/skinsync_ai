import 'package:skinsync_ai/models/responses/treatment_area_response.dart';
import 'package:skinsync_ai/models/responses/treatment_sub_area_response.dart';
import 'package:skinsync_ai/models/responses/treatment_response_model.dart';

abstract class TreatmentRepository {
  Future<TreatmentResponse> getTreatmentsApi();
  Future<TreatmentAreaResponse> getSelectSectionApi({required int sectionId});
  Future<TreatmentSubAreaResponse> getSubSectionApi({required int sectionId,required int subSectionId});

}
