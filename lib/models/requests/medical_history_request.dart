class MedicalHistoryRequest {
  final List<String>? allergies;
  final List<String>? medicalConditions;
  final List<String>? currentMedications;

  MedicalHistoryRequest({
    this.allergies,
    this.medicalConditions,
    this.currentMedications,
  });

  Map<String, dynamic> toJson() => {
    "allergies": allergies == null
        ? []
        : List<dynamic>.from(allergies!.map((x) => x)),
    "medical_conditions": medicalConditions == null
        ? []
        : List<dynamic>.from(medicalConditions!.map((x) => x)),
    "current_medications": currentMedications == null
        ? []
        : List<dynamic>.from(currentMedications!.map((x) => x)),
  };
}
