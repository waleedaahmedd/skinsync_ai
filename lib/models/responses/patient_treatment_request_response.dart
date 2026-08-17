import 'base_response_model.dart';
import 'simulation_history_response.dart';

class PatientTreatmentRequestResponse extends BaseResponseModel {
  final List<PatientTreatmentRequest>? data;

  PatientTreatmentRequestResponse({super.isSuccess, super.message, this.data});

  factory PatientTreatmentRequestResponse.fromJson(Map<String, dynamic> json) =>
      PatientTreatmentRequestResponse(
        isSuccess: json["is_success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<PatientTreatmentRequest>.from(
                json["data"]!.map((x) => PatientTreatmentRequest.fromJson(x)),
              ),
      );
}

class PatientTreatmentRequest {
  final int? id;
  final String? patientName;
  final String? patientEmail;
  final String? image;
  final int? totalTreatmentCount;
  final SimulationData? simulation;

  PatientTreatmentRequest({
    this.id,
    this.patientName,
    this.patientEmail,
    this.image,
    this.totalTreatmentCount,
    this.simulation,
  });

  factory PatientTreatmentRequest.fromJson(Map<String, dynamic> json) =>
      PatientTreatmentRequest(
        id: json["id"],
        patientName: json["patient_name"],
        patientEmail: json["patient_email"],
        image: json["image"],
        totalTreatmentCount: json["total_treatment_count"],
        simulation: json["simulation"] != null 
            ? SimulationData.fromJson(json["simulation"]) 
            : SimulationData.fromJson(json), // Fallback if simulation data is at root
      );
}
