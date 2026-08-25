import 'dart:convert';
import '../models/responses/base_response_model.dart';
import '../models/responses/patient_plans_response.dart';
import '../repositories/subscription_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';

class SubscriptionService implements SubscriptionRepository {
  final ApiBaseHelper apiClient;

  SubscriptionService({required this.apiClient});

  @override
  Future<PatientPlansResponse> getPatientCurrentPlan() async {
    final response = await apiClient.httpRequest(
      endPoint: EndPoints.patientCurrentPlan,
      requestType: RequestType.get,
    );
    return PatientPlansResponse.fromJson(jsonDecode(response.body));
  }

  @override
  Future<BaseResponseModel> upgradePlan(int planId) async {
    final response = await apiClient.httpRequest(
      endPoint: EndPoints.subscribe,
      requestType: RequestType.get,
      params: '$planId',
    );
    return BaseResponseModel.fromJson(jsonDecode(response.body));
  }
}
