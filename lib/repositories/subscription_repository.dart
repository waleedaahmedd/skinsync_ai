import '../models/responses/base_response_model.dart';
import '../models/responses/patient_plans_response.dart';

abstract class SubscriptionRepository {
  Future<PatientPlansResponse> getPatientCurrentPlan();
  Future<BaseResponseModel> upgradePlan({required int planId, int? durationId});
}
