import 'base_response_model.dart';

class AppointmentResponse extends BaseResponseModel {
  final AppointmentData? data;

  AppointmentResponse({this.data, super.status, super.message});

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) =>
      AppointmentResponse(
        data: json["data"] == null
            ? null
            : AppointmentData.fromJson(json["data"]),
        status: json["is_success"],
        message: json["message"],
      );
}

class AppointmentData {
  final int? appointmentId;
  final AppointmentEntity? clinic;
  final AppointmentEntity? doctor;
  final int? date;
  final int? startTime;
  final int? endTime;
  final AppointmentTreatment? treatment;
  final List<TreatmentSubsection>? treatmentSubsection;
  final int? treatmentTotal;
  final PaymentType? paymentType;
  final int? discount;
  final String? discountType;
  final int? loyalityPoints;
  final int? actualAmount;
  final int? amountPaid;
  final int? amountPayable;
  final String? status;

  AppointmentData({
    this.appointmentId,
    this.clinic,
    this.doctor,
    this.date,
    this.startTime,
    this.endTime,
    this.treatment,
    this.treatmentSubsection,
    this.treatmentTotal,
    this.paymentType,
    this.discount,
    this.discountType,
    this.loyalityPoints,
    this.actualAmount,
    this.amountPaid,
    this.amountPayable,
    this.status,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) =>
      AppointmentData(
        appointmentId: json["appointment_id"],
        clinic: json["clinic"] == null
            ? null
            : AppointmentEntity.fromJson(json["clinic"]),
        doctor: json["doctor"] == null
            ? null
            : AppointmentEntity.fromJson(json["doctor"]),
        date: json["date"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        treatment: json["treatment"] == null
            ? null
            : AppointmentTreatment.fromJson(json["treatment"]),
        treatmentSubsection: json["treatment_subsection"] == null
            ? []
            : List<TreatmentSubsection>.from(
                json["treatment_subsection"]!.map(
                  (x) => TreatmentSubsection.fromJson(x),
                ),
              ),
        treatmentTotal: json["treatment_total"],
        paymentType: json["payment_type"] == null
            ? null
            : PaymentType.fromJson(json["payment_type"]),
        discount: json["discount"],
        discountType: json["discount_type"],
        loyalityPoints: json["loyality_points"],
        actualAmount: json["actual_amount"],
        amountPaid: json["amount_paid"],
        amountPayable: json["amount_payable"],
        status: json["status"],
      );
}

class AppointmentEntity {
  final int? id;
  final String? name;
  final String? image;

  AppointmentEntity({this.id, this.name, this.image});

  factory AppointmentEntity.fromJson(Map<String, dynamic> json) =>
      AppointmentEntity(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );
}

class PaymentType {
  final int? id;
  final String? title;
  final int? amount;

  PaymentType({this.id, this.title, this.amount});

  factory PaymentType.fromJson(Map<String, dynamic> json) =>
      PaymentType(id: json["id"], title: json["title"], amount: json["amount"]);
}

class AppointmentTreatment {
  final int? treatmentId;
  final int? treatmentPrice;
  final int? treatmentQuantity;
  final String? beforeImage;
  final String? afterImage;

  AppointmentTreatment({
    this.treatmentId,
    this.treatmentPrice,
    this.treatmentQuantity,
    this.beforeImage,
    this.afterImage,
  });

  factory AppointmentTreatment.fromJson(Map<String, dynamic> json) =>
      AppointmentTreatment(
        treatmentId: json["treatment_id"],
        treatmentPrice: json["treatment_price"],
        treatmentQuantity: json["treatment_quantity"],
        beforeImage: json["before_image"],
        afterImage: json["after_image"],
      );
}

class TreatmentSubsection {
  final int? sectionId;
  final int? syringesQuantity;
  final int? perSyringePrice;

  TreatmentSubsection({
    this.sectionId,
    this.syringesQuantity,
    this.perSyringePrice,
  });

  factory TreatmentSubsection.fromJson(Map<String, dynamic> json) =>
      TreatmentSubsection(
        sectionId: json["section_id"],
        syringesQuantity: json["syringes_quantity"],
        perSyringePrice: json["per_syringe_price"],
      );
}
