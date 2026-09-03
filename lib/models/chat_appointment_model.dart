class ChatAppointmentModel {
  final int appointmentId;
  final String patientName;
  final String serviceName;
  final String date;
  final String time;
  final String practitionerName;
  final String status;
  final String? clinicLocation;
  final String? appointmentKey;

  ChatAppointmentModel({
    required this.appointmentId,
    required this.patientName,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.practitionerName,
    required this.status,
    this.clinicLocation,
    this.appointmentKey,
  });

  factory ChatAppointmentModel.fromJson(Map<String, dynamic> json) {
    return ChatAppointmentModel(
      appointmentId: json['appointment_id'] ?? json['id'] ?? 0,
      patientName: json['patient_name'] ?? '',
      serviceName: json['service_name'] ?? json['treatment_name'] ?? '',
      date: json['date'] ?? json['appointment_date'] ?? '',
      time: json['time'] ?? json['appointment_time'] ?? '',
      practitionerName: json['practitioner_name'] ?? json['doctor_name'] ?? '',
      status: json['status'] ?? '',
      clinicLocation: json['clinic_location'],
      appointmentKey: json['appointment_key'],
    );
  }

  Map<String, dynamic> toJson() => {
        'appointment_id': appointmentId,
        'patient_name': patientName,
        'service_name': serviceName,
        'date': date,
        'time': time,
        'practitioner_name': practitionerName,
        'status': status,
        if (clinicLocation != null) 'clinic_location': clinicLocation,
        if (appointmentKey != null) 'appointment_key': appointmentKey,
      };
}

typedef ChatAppointmentData = ChatAppointmentModel;
