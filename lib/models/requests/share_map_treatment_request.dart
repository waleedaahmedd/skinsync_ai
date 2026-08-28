import '../responses/get_clinic_response.dart';
import 'preferred_slot.dart';

class ShareMapTreatmentRequest {
  final int optionId;
  final Clinic clinic;
  final List<PreferredSlot> preferredSlots;

  ShareMapTreatmentRequest({
    required this.optionId,
    required this.clinic,
    required this.preferredSlots,
  });

  Map<String, dynamic> toJson() {
    return {
      'option_id': optionId,
      'preferred_slots': preferredSlots.map((e) => e.toJson()).toList(),
      'clinic': {
        'name': clinic.name ?? clinic.place?.displayName?.text ?? '',
        'email': clinic.email ?? '',
        'phone': clinic.phone ??
            clinic.place?.internationalPhoneNumber ??
            clinic.place?.nationalPhoneNumber ??
            '',
        'description': clinic.description ?? clinic.place?.formattedAddress ?? '',
        'address': clinic.address ?? clinic.place?.formattedAddress ?? '',
        'owner_name': clinic.ownerName ?? clinic.name ?? clinic.place?.displayName?.text ?? '',
        'owner_email': clinic.ownerEmail ?? clinic.email ?? '',
        'location': {
          'lat': clinic.location?.latitude ?? clinic.place?.location?.latitude,
          'lng': clinic.location?.longitude ?? clinic.place?.location?.longitude,
        },
      },
    };
  }
}