import 'base_response_model.dart';
import '../subscription_plan_model.dart';

class PatientPlansResponse extends BaseResponseModel {
  PatientPlansData? data;

  PatientPlansResponse({super.isSuccess, super.message, this.data});

  PatientPlansResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['data'] != null ? PatientPlansData.fromJson(json['data']) : null;
  }
}

class PatientPlansData {
  PatientSubscriptionPlanModel? currentPlan;
  List<PatientSubscriptionPlanModel>? plans;

  PatientPlansData({this.currentPlan, this.plans});

  PatientPlansData.fromJson(Map<String, dynamic> json) {
    currentPlan = json['current_plan'] != null
        ? PatientSubscriptionPlanModel.fromJson(json['current_plan'])
        : null;
    if (json['plans'] != null) {
      plans = <PatientSubscriptionPlanModel>[];
      json['plans'].forEach((v) {
        plans!.add(PatientSubscriptionPlanModel.fromJson(v));
      });
    }
  }
}
