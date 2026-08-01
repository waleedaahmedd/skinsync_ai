import 'base_response_model.dart';
import 'appointments_list_response.dart';

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
  int? date;
  AppointmentSlot? slot;
  String? appointmentType;
  int? appointmentTypeId;
  String? status;
  double? paidAmount;
  double? payableAmount;
  double? discountAmount;
  List<DetailedAppointmentTreatment>? treatments;
  AppointmentDoctor? doctor;
  AppointmentClinic? clinic;

  AppointmentDetailData({
    this.appointmentId,
    this.date,
    this.slot,
    this.appointmentType,
    this.appointmentTypeId,
    this.status,
    this.paidAmount,
    this.payableAmount,
    this.discountAmount,
    this.treatments,
    this.doctor,
    this.clinic,
  });

  AppointmentDetailData.fromJson(Map<String, dynamic> json) {
    appointmentId = json['id'];
    date = json['date'];
    slot = json['slot'] != null ? AppointmentSlot.fromJson(json['slot']) : null;
    appointmentType = json['appointment_type'];
    appointmentTypeId = json['appointment_type_id'];
    status = json['status'];
    paidAmount = (json['paid_amount'] as num?)?.toDouble();
    payableAmount = (json['payable_amount'] as num?)?.toDouble();
    discountAmount = (json['discount_amount'] as num?)?.toDouble();
    if (json['treatments'] != null) {
      treatments = <DetailedAppointmentTreatment>[];
      json['treatments'].forEach((v) {
        treatments!.add(DetailedAppointmentTreatment.fromJson(v));
      });
    }
    doctor = json['doctor'] != null ? AppointmentDoctor.fromJson(json['doctor']) : null;
    clinic = json['clinic'] != null ? AppointmentClinic.fromJson(json['clinic']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = appointmentId;
    data['date'] = date;
    if (slot != null) {
      data['slot'] = slot!.toJson();
    }
    data['appointment_type'] = appointmentType;
    data['appointment_type_id'] = appointmentTypeId;
    data['status'] = status;
    data['paid_amount'] = paidAmount;
    data['payable_amount'] = payableAmount;
    data['discount_amount'] = discountAmount;
    if (treatments != null) {
      data['treatments'] = treatments!.map((v) => v.toJson()).toList();
    }
    if (doctor != null) {
      data['doctor'] = doctor!.toJson();
    }
    if (clinic != null) {
      data['clinic'] = clinic!.toJson();
    }
    return data;
  }
}

class DetailedAppointmentTreatment {
  int? treatmentId;
  String? treatmentName;
  String? treatmentImage;
  int? areaId;
  String? areaName;
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
    if (material != null) {
      data['material'] = material!.toJson();
    }
    data['status'] = status;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}
