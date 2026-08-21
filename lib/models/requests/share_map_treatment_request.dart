import '../responses/get_clinic_response.dart';

class ShareMapTreatmentRequest {
  final int optionId;
  final Clinic clinic;

  ShareMapTreatmentRequest({required this.optionId, required this.clinic});

  Map<String, dynamic> toJson() {
    return {
      'option_id': optionId,
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