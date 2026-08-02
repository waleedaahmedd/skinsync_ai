import 'base_response_model.dart';
import 'appointments_list_response.dart';
import 'appointment_type_list_response.dart';

class AppointmentDetailResponse extends BaseResponseModel {
  AppointmentDetailData? data;

  AppointmentDetailResponse({this.data, super.isSuccess, super.message});

  AppointmentDetailResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
    data = json['data'] != null ? AppointmentDetailData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_success'] = isSuccess;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AppointmentDetailData {
  int? appointmentId;
  String? appointmentKey;
  int? date;
  int? startTime;
  int? endTime;
  AppointmentTypeData? appointmentType;
  String? status;
  double? treatmentTotal;
  double? discount;
  String? discountType;
  List<DetailedAppointmentTreatment>? treatments;
  AppointmentDoctor? doctor;
  AppointmentClinic? clinic;
  PaymentType? paymentType;
  Simulations? simulations;
  String? createdAt;

  AppointmentDetailData({
    this.appointmentId,
    this.appointmentKey,
    this.date,
    this.startTime,
    this.endTime,
    this.appointmentType,
    this.status,
    this.treatmentTotal,
    this.discount,
    this.discountType,
    this.treatments,
    this.doctor,
    this.clinic,
    this.paymentType,
    this.simulations,
    this.createdAt,
  });

  AppointmentDetailData.fromJson(Map<String, dynamic> json) {
    appointmentId = json['id'];
    appointmentKey = json['appointment_key'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    appointmentType = json['appointment_type'] != null
        ? AppointmentTypeData.fromJson(json['appointment_type'])
        : null;
    status = json['status'];
    treatmentTotal = (json['treatment_total'] as num?)?.toDouble();
    discount = (json['discount'] as num?)?.toDouble();
    discountType = json['discount_type'];
    if (json['treatments'] != null) {
      treatments = <DetailedAppointmentTreatment>[];
      json['treatments'].forEach((v) {
        treatments!.add(DetailedAppointmentTreatment.fromJson(v));
      });
    }
    doctor = json['doctor'] != null ? AppointmentDoctor.fromJson(json['doctor']) : null;
    clinic = json['clinic'] != null ? AppointmentClinic.fromJson(json['clinic']) : null;
    paymentType = json['payment_type'] != null ? PaymentType.fromJson(json['payment_type']) : null;
    simulations = json['simulations'] != null ? Simulations.fromJson(json['simulations']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = appointmentId;
    data['appointment_key'] = appointmentKey;
    data['date'] = date;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    if (appointmentType != null) {
      data['appointment_type'] = appointmentType!.toJson();
    }
    data['status'] = status;
    data['treatment_total'] = treatmentTotal;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    if (treatments != null) {
      data['treatments'] = treatments!.map((v) => v.toJson()).toList();
    }
    if (doctor != null) {
      data['doctor'] = doctor!.toJson();
    }
    if (clinic != null) {
      data['clinic'] = clinic!.toJson();
    }
    if (paymentType != null) {
      data['payment_type'] = paymentType!.toJson();
    }
    if (simulations != null) {
      data['simulations'] = simulations!.toJson();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

class PaymentType {
  String? type;
  String? status;

  PaymentType({this.type, this.status});

  PaymentType.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['status'] = status;
    return data;
  }
}

class Simulations {
  String? frontImageBefore;
  String? frontImageAfter;
  String? rightImageBefore;
  String? rightImageAfter;
  String? leftImageBefore;
  String? leftImageAfter;

  Simulations({
    this.frontImageBefore,
    this.frontImageAfter,
    this.rightImageBefore,
    this.rightImageAfter,
    this.leftImageBefore,
    this.leftImageAfter,
  });

  Simulations.fromJson(Map<String, dynamic> json) {
    frontImageBefore = json['front_image_before'];
    frontImageAfter = json['front_image_after'];
    rightImageBefore = json['right_image_before'];
    rightImageAfter = json['right_image_after'];
    leftImageBefore = json['left_image_before'];
    leftImageAfter = json['left_image_after'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['front_image_before'] = frontImageBefore;
    data['front_image_after'] = frontImageAfter;
    data['right_image_before'] = rightImageBefore;
    data['right_image_after'] = rightImageAfter;
    data['left_image_before'] = leftImageBefore;
    data['left_image_after'] = leftImageAfter;
    return data;
  }
}

class DetailedAppointmentTreatment {
  int? treatmentId;
  String? treatmentName;
  String? treatmentImage;
  int? areaId;
  String? areaName;
  double? treatmentCost;
  AppointmentMaterial? material;
  String? status; // pending, start, end
  int? startTime;
  int? endTime;

  DetailedAppointmentTreatment({
    this.treatmentId,
    this.treatmentName,
    this.treatmentImage,
    this.areaId,
    this.areaName,
    this.treatmentCost,
    this.material,
    this.status,
    this.startTime,
    this.endTime,
  });

  DetailedAppointmentTreatment.fromJson(Map<String, dynamic> json) {
    treatmentId = json['treatment_id'];
    treatmentName = json['treatment_name'];
    treatmentImage = json['treatment_image'];
    areaId = json['area_id'];
    areaName = json['area_name'];
    treatmentCost = (json['treatment_cost'] as num?)?.toDouble();
    material = json['material'] != null ? AppointmentMaterial.fromJson(json['material']) : null;
    status = json['status'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['treatment_id'] = treatmentId;
    data['treatment_name'] = treatmentName;
    data['treatment_image'] = treatmentImage;
    data['area_id'] = areaId;
    data['area_name'] = areaName;
    data['treatment_cost'] = treatmentCost;
    if (material != null) {
      data['material'] = material!.toJson();
    }
    data['status'] = status;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}
