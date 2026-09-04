class ScanQrRequest {
  final int clinicId;
  final int appointmentId;

  ScanQrRequest({
    required this.clinicId,
    required this.appointmentId,
  });

  Map<String, dynamic> toJson() => {
        "clinic_id": clinicId,
        "appointment_id": appointmentId,
      };
}