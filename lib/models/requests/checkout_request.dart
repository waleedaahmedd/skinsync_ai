class CheckoutRequest {
  int? clinicId;
  int? doctorId;
  int? date;
  int? startTime;
  int? endTime;
  Treatment? treatment;
  List<TreatmentSubsection>? treatmentSubsection;
  int? treatmentTotal;
  PaymentType? paymentType;
  String? discountType;
  int? loyalityPoints;
  int? discount;
  int? actualAmount;
  int? amountPaid;
  int? amountPayable;

  CheckoutRequest(
      {this.clinicId,
        this.doctorId,
        this.date,
        this.startTime,
        this.endTime,
        this.treatment,
        this.treatmentSubsection,
        this.treatmentTotal,
        this.paymentType,
        this.discountType,
        this.loyalityPoints,
        this.discount,
        this.actualAmount,
        this.amountPaid,
        this.amountPayable});

  CheckoutRequest.fromJson(Map<String, dynamic> json) {
    clinicId = json['clinic_id'];
    doctorId = json['doctor_id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    treatment = json['treatment'] != null
        ? new Treatment.fromJson(json['treatment'])
        : null;
    if (json['treatment_subsection'] != null) {
      treatmentSubsection = <TreatmentSubsection>[];
      json['treatment_subsection'].forEach((v) {
        treatmentSubsection!.add(new TreatmentSubsection.fromJson(v));
      });
    }
    treatmentTotal = json['treatment_total'];
    paymentType = json['payment_type'] != null
        ? new PaymentType.fromJson(json['payment_type'])
        : null;
    discountType = json['discount_type'];
    loyalityPoints = json['loyality_points'];
    discount = json['discount'];
    actualAmount = json['actual_amount'];
    amountPaid = json['amount_paid'];
    amountPayable = json['amount_payable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinic_id'] = this.clinicId;
    data['doctor_id'] = this.doctorId;
    data['date'] = this.date;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    if (this.treatment != null) {
      data['treatment'] = this.treatment!.toJson();
    }
    if (this.treatmentSubsection != null) {
      data['treatment_subsection'] =
          this.treatmentSubsection!.map((v) => v.toJson()).toList();
    }
    data['treatment_total'] = this.treatmentTotal;
    if (this.paymentType != null) {
      data['payment_type'] = this.paymentType!.toJson();
    }
    data['discount_type'] = this.discountType;
    data['loyality_points'] = this.loyalityPoints;
    data['discount'] = this.discount;
    data['actual_amount'] = this.actualAmount;
    data['amount_paid'] = this.amountPaid;
    data['amount_payable'] = this.amountPayable;
    return data;
  }
}

class Treatment {
  int? treatmentId;
  int? treatmentPrice;
  int? treatmentQuantity;
  String? beforeImage;
  String? afterImage;

  Treatment(
      {this.treatmentId,
        this.treatmentPrice,
        this.treatmentQuantity,
        this.beforeImage,
        this.afterImage});

  Treatment.fromJson(Map<String, dynamic> json) {
    treatmentId = json['treatment_id'];
    treatmentPrice = json['treatment_price'];
    treatmentQuantity = json['treatment_quantity'];
    beforeImage = json['before_image'];
    afterImage = json['after_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['treatment_id'] = this.treatmentId;
    data['treatment_price'] = this.treatmentPrice;
    data['treatment_quantity'] = this.treatmentQuantity;
    data['before_image'] = this.beforeImage;
    data['after_image'] = this.afterImage;
    return data;
  }
}

class TreatmentSubsection {
  int? sectionId;
  int? syringesQuantity;
  int? perSyringePrice;

  TreatmentSubsection(
      {this.sectionId, this.syringesQuantity, this.perSyringePrice});

  TreatmentSubsection.fromJson(Map<String, dynamic> json) {
    sectionId = json['section_id'];
    syringesQuantity = json['syringes_quantity'];
    perSyringePrice = json['per_syringe_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['section_id'] = this.sectionId;
    data['syringes_quantity'] = this.syringesQuantity;
    data['per_syringe_price'] = this.perSyringePrice;
    return data;
  }
}

class PaymentType {
  int? id;
  int? amount;

  PaymentType({this.id, this.amount});

  PaymentType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    return data;
  }
}
