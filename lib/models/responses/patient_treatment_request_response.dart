import 'base_response_model.dart';
import 'simulation_history_response.dart';

class PatientTreatmentRequestResponse extends BaseResponseModel {
  final List<SimulationData>? data;

  PatientTreatmentRequestResponse({super.isSuccess, super.message, this.data});

  factory PatientTreatmentRequestResponse.fromJson(Map<String, dynamic> json) =>
      PatientTreatmentRequestResponse(
        isSuccess: json["is_success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<SimulationData>.from(
                json["data"]!.map((x) => SimulationData.fromJson(x)),
              ),
      );
}

typedef PatientTreatmentRequest = SimulationData;
