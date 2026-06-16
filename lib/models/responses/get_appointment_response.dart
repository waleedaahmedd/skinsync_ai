import 'base_response_model.dart';
import '../../utills/date_time_utills.dart';

class GetAppointmentResponse extends BaseResponseModel {
  List<Appointment>? data;

  int? limit;

  int? page;
  int? totalPages;

  GetAppointmentResponse({
    this.data,
    super.status,
    this.limit,
    super.message,
    this.page,
    this.totalPages,
  });

  GetAppointmentResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Appointment>[];
      json['data'].forEach((v) {
        data!.add(Appointment.fromJson(v));
      });
    }
    status = json['is_success'];
    limit = json['limit'];
    message = json['message'];
    page = json['page'];
    totalPages = json['total_pages'];
  }
}

class Appointment {
  int? appointmentId;
  AppointmentClinic? clinic;
  AppointmentClinic? doctor;
  int? date;
  DateTime? startTime;
  DateTime? endTime;
  Treatment? treatment;
  List<TreatmentSubsection>? treatmentSubsection;
  int? treatmentTotal;
  PaymentType? paymentType;
  int? discount;
  String? discountType;
  int? loyalityPoints;
  int? actualAmount;
  int? amountPaid;
  int? amountPayable;
  String? status;

  Appointment({
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

  Appointment.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    clinic = json['clinic'] != null
        ? AppointmentClinic.fromJson(json['clinic'])
        : null;
    doctor = json['doctor'] != null
        ? AppointmentClinic.fromJson(json['doctor'])
        : null;
    date = json['date'];
    startTime = DateTime.fromMillisecondsSinceEpoch(json["start_time"] * 1000);
    endTime = DateTime.fromMillisecondsSinceEpoch(json["end_time"] * 1000);
    treatment = json['treatment'] != null
        ? Treatment.fromJson(json['treatment'])
        : null;
    if (json['treatment_subsection'] != null) {
      treatmentSubsection = <TreatmentSubsection>[];
      json['treatment_subsection'].forEach((v) {
        treatmentSubsection!.add(TreatmentSubsection.fromJson(v));
      });
    }
    treatmentTotal = json['treatment_total'];
    paymentType = json['payment_type'] != null
        ? PaymentType.fromJson(json['payment_type'])
        : null;
    discount = json['discount'];
    discountType = json['discount_type'];
    loyalityPoints = json['loyality_points'];
    actualAmount = json['actual_amount'];
    amountPaid = json['amount_paid'];
    amountPayable = json['amount_payable'];
    status = json['status'];
  }
  String get startTimeFormattedTime {
    return '${startTime?.formattedTime}';
  }

  String get endTimeFormattedTime {
    return '${endTime?.formattedTime}';
  }
}

class AppointmentClinic {
  int? id;
  String? name;
  String? image;

  AppointmentClinic({this.id, this.name, this.image});

  AppointmentClinic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}

class Treatment {
  int? treatmentId;
  int? treatmentPrice;
  int? treatmentQuantity;
  String? beforeImage;
  String? afterImage;

  Treatment({
    this.treatmentId,
    this.treatmentPrice,
    this.treatmentQuantity,
    this.beforeImage,
    this.afterImage,
  });

  Treatment.fromJson(Map<String, dynamic> json) {
    treatmentId = json['treatment_id'];
    treatmentPrice = json['treatment_price'];
    treatmentQuantity = json['treatment_quantity'];
    beforeImage = json['before_image'];
    afterImage = json['after_image'];
  }
}

class TreatmentSubsection {
  int? sectionId;
  int? syringesQuantity;
  int? perSyringePrice;

  TreatmentSubsection({
    this.sectionId,
    this.syringesQuantity,
    this.perSyringePrice,
  });

  TreatmentSubsection.fromJson(Map<String, dynamic> json) {
    sectionId = json['section_id'];
    syringesQuantity = json['syringes_quantity'];
    perSyringePrice = json['per_syringe_price'];
  }
}

class PaymentType {
  int? id;
  String? title;
  int? amount;

  PaymentType({this.id, this.title, this.amount});

  PaymentType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    amount = json['amount'];
  }
}
