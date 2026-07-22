class AppointmentRequest {
  final int clinicId;
  final int doctorId;
  final int date;
  final int startTime;
  final int endTime;
  final int appointmentTypeId;
  final bool isInviteClinic;
  final SimulationsRequest simulations;
  final List<TreatmentRequest> treatment;
  final int treatmentTotal;
  final PaymentTypeRequest paymentType;
  final String discountType;
  final int loyalityPoints;
  final int discount;
  final int actualAmount;
  final int amountPaid;
  final int amountPayable;

  AppointmentRequest({
    required this.clinicId,
    required this.doctorId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.appointmentTypeId,
    required this.isInviteClinic,
    required this.simulations,
    required this.treatment,
    required this.treatmentTotal,
    required this.paymentType,
    required this.discountType,
    required this.loyalityPoints,
    required this.discount,
    required this.actualAmount,
    required this.amountPaid,
    required this.amountPayable,
  });

  Map<String, dynamic> toJson() => {
        "clinic_id": clinicId,
        "doctor_id": doctorId,
        "date": date,
        "start_time": startTime,
        "end_time": endTime,
        "appointment_type_id": appointmentTypeId,
        "is_invite_clinic": isInviteClinic,
        "simulations": simulations.toJson(),
        "treatment": treatment.map((x) => x.toJson()).toList(),
        "treatment_total": treatmentTotal,
        "payment_type": paymentType.toJson(),
        "discount_type": discountType,
        "loyality_points": loyalityPoints,
        "discount": discount,
        "actual_amount": actualAmount,
        "amount_paid": amountPaid,
        "amount_payable": amountPayable,
      };
}

class SimulationsRequest {
  final String beforeImage;
  final String afterImage;

  SimulationsRequest({
    required this.beforeImage,
    required this.afterImage,
  });

  Map<String, dynamic> toJson() => {
        "before_image": beforeImage,
        "after_image": afterImage,
      };
}

class TreatmentRequest {
  final int treatmentId;
  final int areaId;
  final int treatmentCost;
  final MaterialRequest? material;

  TreatmentRequest({
    required this.treatmentId,
    required this.areaId,
    required this.treatmentCost,
    this.material,
  });

  Map<String, dynamic> toJson() => {
        "treatment_id": treatmentId,
        "area_id": areaId,
        "treatment_cost": treatmentCost,
        if (material != null) "material": material!.toJson(),
      };
}

class MaterialRequest {
  final int id;
  final int selectedQuantity;

  MaterialRequest({
    required this.id,
    required this.selectedQuantity,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "selected_quantity": selectedQuantity,
      };
}

class PaymentTypeRequest {
  final String type;
  final String status;

  PaymentTypeRequest({
    required this.type,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        "type": type,
        "status": status,
      };
}
