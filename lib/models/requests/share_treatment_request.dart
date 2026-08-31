import 'preferred_slot.dart';

class ShareTreatmentRequest {
  final int clinicId;
  final int optionId;
  final List<PreferredSlot> preferredSlots;
  final bool shareMedicalHistory;

  ShareTreatmentRequest({
    required this.clinicId,
    required this.optionId,
    required this.preferredSlots,
    this.shareMedicalHistory = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'clinic_id': clinicId,
      'option_id': optionId,
      'preferred_slots': preferredSlots.map((e) => e.toJson()).toList(),
      'share_medical_history': shareMedicalHistory,
    };
  }
}
