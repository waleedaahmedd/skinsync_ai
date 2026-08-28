import 'preferred_slot.dart';

class ShareTreatmentRequest {
  final int clinicId;
  final int optionId;
  final List<PreferredSlot> preferredSlots;

  ShareTreatmentRequest({
    required this.clinicId,
    required this.optionId,
    required this.preferredSlots,
  });

  Map<String, dynamic> toJson() {
    return {
      'clinic_id': clinicId,
      'option_id': optionId,
      'preferred_slots': preferredSlots.map((e) => e.toJson()).toList(),
    };
  }
}
