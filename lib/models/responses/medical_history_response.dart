import 'base_response_model.dart';

class MedicalHistoryResponse extends BaseResponseModel {
  final MedicalHistory? data;

  MedicalHistoryResponse({super.isSuccess, super.message, this.data});

  factory MedicalHistoryResponse.fromJson(Map<String, dynamic> json) =>
      MedicalHistoryResponse(
        isSuccess: json["is_success"],
        message: json["message"],
        data: json["data"] == null ? null : MedicalHistory.fromJson(json["data"]),
      );
}

class MedicalHistory {
  final int? id;
  final int? patientId;
  final List<String>? allergies;
  final List<String>? medicalConditions;
  final List<String>? currentMedications;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MedicalHistory({
    this.id,
    this.patientId,
    this.allergies,
    this.medicalConditions,
    this.currentMedications,
    this.createdAt,
    this.updatedAt,
  });

  factory MedicalHistory.fromJson(Map<String, dynamic> json) => MedicalHistory(
    id: json["id"],
    patientId: json["patient_id"],
    allergies: json["allergies"] == null
        ? []
        : List<String>.from(json["allergies"]!.map((x) => x)),
    medicalConditions: json["medical_conditions"] == null
        ? []
        : List<String>.from(json["medical_conditions"]!.map((x) => x)),
    currentMedications: json["current_medications"] == null
        ? []
        : List<String>.from(json["current_medications"]!.map((x) => x)),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );
}
