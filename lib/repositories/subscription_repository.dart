import '../models/responses/base_response_model.dart';
import '../models/responses/patient_plans_response.dart';
import '../utils/enums.dart';

abstract class SubscriptionRepository {
  Future<PatientPlansResponse> getPatientCurrentPlan();
  Future<BaseResponseModel> upgradePlan({required int planId, int? durationId});
  Future<BaseResponseModel> recordUsage({
    required UsageType usageType,
    required int subscriptionId,
  });
}
