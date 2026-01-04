import 'package:skinsync_ai/models/responses/treatment_response_model.dart';

abstract class TreatmentRepository {
  Future<TreatmentResponse> getTreatmentsApi();
}
