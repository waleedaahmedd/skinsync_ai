import '../responses/get_clinic_response.dart';

class ShareMapTreatmentRequest {
  final int optionId;
  final Clinic clinic;

  ShareMapTreatmentRequest({required this.optionId, required this.clinic});

  Map<String, dynamic> toJson() {
    return {
      'option_id': optionId,
      'clinic': clinic.toJson(),
    };
  }
}