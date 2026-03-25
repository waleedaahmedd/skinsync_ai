class AppointmentRequest {
  final int clinicId;
  final int doctorId;
  final int date;
  final int startTime;
  final int endTime;
  final AppointmentTreatmentRequest treatment;
  final List<TreatmentSubsectionRequest> treatmentSubsection;
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
    required this.treatment,
    required this.treatmentSubsection,
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
    "treatment": treatment.toJson(),
    "treatment_subsection": List<dynamic>.from(
      treatmentSubsection.map((x) => x.toJson()),
    ),
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

class PaymentTypeRequest {
  final int id;
  final int amount;

  PaymentTypeRequest({required this.id, required this.amount});

  Map<String, dynamic> toJson() => {"id": id, "amount": amount};
}

class AppointmentTreatmentRequest {
  final int treatmentId;
  final int treatmentPrice;
  final int treatmentQuantity;
  final String beforeImage;
  final String afterImage;

  AppointmentTreatmentRequest({
    required this.treatmentId,
    required this.treatmentPrice,
    required this.treatmentQuantity,
    required this.beforeImage,
    required this.afterImage,
  });

  Map<String, dynamic> toJson() => {
    "treatment_id": treatmentId,
    "treatment_price": treatmentPrice,
    "treatment_quantity": treatmentQuantity,
    "before_image": beforeImage,
    "after_image": afterImage,
  };
}

class TreatmentSubsectionRequest {
  final int sectionId;
  final int syringesQuantity;
  final int perSyringePrice;

  TreatmentSubsectionRequest({
    required this.sectionId,
    required this.syringesQuantity,
    required this.perSyringePrice,
  });

  Map<String, dynamic> toJson() => {
    "section_id": sectionId,
    "syringes_quantity": syringesQuantity,
    "per_syringe_price": perSyringePrice,
  };
}
