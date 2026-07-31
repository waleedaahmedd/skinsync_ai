import 'base_response_model.dart';

class AppointmentResponse extends BaseResponseModel {
  final AppointmentData? data;

  AppointmentResponse({this.data, super.isSuccess, super.message});

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) =>
      AppointmentResponse(
        data: json["data"] == null
            ? null
            : AppointmentData.fromJson(json["data"]),
        isSuccess: json["is_success"],
        message: json["message"],
      );
}

class AppointmentData {
  final int? appointmentId;
  final CreatedAppointmentEntity? clinic;
  final CreatedAppointmentEntity? doctor;
  final int? date;
  final int? startTime;
  final int? endTime;
  final CreatedAppointmentTreatment? treatment;
  final List<CreatedTreatmentSubsection>? treatmentSubsection;
  final int? treatmentTotal;
  final AppointmentPaymentType? paymentType;
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
            : CreatedAppointmentEntity.fromJson(json["clinic"]),
        doctor: json["doctor"] == null
            ? null
            : CreatedAppointmentEntity.fromJson(json["doctor"]),
        date: json["date"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        treatment: json["treatment"] == null
            ? null
            : CreatedAppointmentTreatment.fromJson(json["treatment"]),
        treatmentSubsection: json["treatment_subsection"] == null
            ? []
            : List<CreatedTreatmentSubsection>.from(
                json["treatment_subsection"]!.map(
                  (x) => CreatedTreatmentSubsection.fromJson(x),
                ),
              ),
        treatmentTotal: json["treatment_total"],
        paymentType: json["payment_type"] == null
            ? null
            : AppointmentPaymentType.fromJson(json["payment_type"]),
        discount: json["discount"],
        discountType: json["discount_type"],
        loyalityPoints: json["loyality_points"],
        actualAmount: json["actual_amount"],
        amountPaid: json["amount_paid"],
        amountPayable: json["amount_payable"],
        status: json["status"],
      );
}

class CreatedAppointmentEntity {
  final int? id;
  final String? name;
  final String? image;

  CreatedAppointmentEntity({this.id, this.name, this.image});

  factory CreatedAppointmentEntity.fromJson(Map<String, dynamic> json) =>
      CreatedAppointmentEntity(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );
}

class AppointmentPaymentType {
  final int? id;
  final String? title;
  final int? amount;

  AppointmentPaymentType({this.id, this.title, this.amount});

  factory AppointmentPaymentType.fromJson(Map<String, dynamic> json) =>
      AppointmentPaymentType(id: json["id"], title: json["title"], amount: json["amount"]);
}

class CreatedAppointmentTreatment {
  final int? treatmentId;
  final int? treatmentPrice;
  final int? treatmentQuantity;
  final String? beforeImage;
  final String? afterImage;

  CreatedAppointmentTreatment({
    this.treatmentId,
    this.treatmentPrice,
    this.treatmentQuantity,
    this.beforeImage,
    this.afterImage,
  });

  factory CreatedAppointmentTreatment.fromJson(Map<String, dynamic> json) =>
      CreatedAppointmentTreatment(
        treatmentId: json["treatment_id"],
        treatmentPrice: json["treatment_price"],
        treatmentQuantity: json["treatment_quantity"],
        beforeImage: json["before_image"],
        afterImage: json["after_image"],
      );
}

class CreatedTreatmentSubsection {
  final int? sectionId;
  final int? syringesQuantity;
  final int? perSyringePrice;

  CreatedTreatmentSubsection({
    this.sectionId,
    this.syringesQuantity,
    this.perSyringePrice,
  });

  factory CreatedTreatmentSubsection.fromJson(Map<String, dynamic> json) =>
      CreatedTreatmentSubsection(
        sectionId: json["section_id"],
        syringesQuantity: json["syringes_quantity"],
        perSyringePrice: json["per_syringe_price"],
      );
}
