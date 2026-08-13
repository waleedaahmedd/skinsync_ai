class ShareTreatmentRequest {
  final int clinicId;
  final int optionId;

  ShareTreatmentRequest({
    required this.clinicId,
    required this.optionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'clinic_id': clinicId,
      'option_id': optionId,
    };
  }
}