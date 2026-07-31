import 'base_response_model.dart';

class AppointmentsListResponse extends BaseResponseModel {
  AppointmentListData? data;

  AppointmentsListResponse({this.data, super.isSuccess, super.message});

  AppointmentsListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
    data = json['data'] != null ? AppointmentListData.fromJson(json['data']) : null;
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

class AppointmentListData {
  List<AppointmentItem>? items;
  int? limit;
  int? page;
  int? total;
  int? totalPages;

  AppointmentListData({this.items, this.limit, this.page, this.total, this.totalPages});

  AppointmentListData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <AppointmentItem>[];
      json['items'].forEach((v) {
        items!.add(AppointmentItem.fromJson(v));
      });
    }
    limit = json['limit'];
    page = json['page'];
    total = json['total'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['limit'] = limit;
    data['page'] = page;
    data['total'] = total;
    data['total_pages'] = totalPages;
    return data;
  }
}

class AppointmentItem {
  int? appointmentId;
  int? date;
  AppointmentSlot? slot;
  String? appointmentType;
  int? appointmentTypeId;
  String? appointmentKey;
  String? status;
  List<AppointmentTreatment>? treatments;
  AppointmentDoctor? doctor;
  AppointmentClinic? clinic;

  AppointmentItem({
    this.appointmentId,
    this.date,
    this.slot,
    this.appointmentType,
    this.appointmentTypeId,
    this.appointmentKey,
    this.status,
    this.treatments,
    this.doctor,
    this.clinic,
  });

  AppointmentItem.fromJson(Map<String, dynamic> json) {
    appointmentId = json['id'];
    date = json['date'];
    slot = json['slot'] != null ? AppointmentSlot.fromJson(json['slot']) : null;
    appointmentType = json['appointment_type'];
    appointmentTypeId = json['appointment_type_id'];
    appointmentKey = json['appointment_key'];
    status = json['status'];
    if (json['treatments'] != null) {
      treatments = <AppointmentTreatment>[];
      json['treatments'].forEach((v) {
        treatments!.add(AppointmentTreatment.fromJson(v));
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
    data['appointment_key'] = appointmentKey;
    data['status'] = status;
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

class AppointmentSlot {
  int? startTime;
  int? endTime;

  AppointmentSlot({this.startTime, this.endTime});

  AppointmentSlot.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}

class AppointmentTreatment {
  int? treatmentId;
  String? treatmentName;
  String? treatmentImage;
  int? areaId;
  String? areaName;
  AppointmentMaterial? material;
  String? status;
  int? startTime;
  int? endTime;

  AppointmentTreatment({
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

  AppointmentTreatment.fromJson(Map<String, dynamic> json) {
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

class AppointmentMaterial {
  int? id;
  int? selectedQuantity;
  String? name;

  AppointmentMaterial({this.id, this.selectedQuantity, this.name});

  AppointmentMaterial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    selectedQuantity = json['selected_quantity'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['selected_quantity'] = selectedQuantity;
    data['name'] = name;
    return data;
  }
}

class AppointmentDoctor {
  int? doctorId;
  String? doctorName;
  String? doctorImage;

  AppointmentDoctor({this.doctorId, this.doctorName, this.doctorImage});

  AppointmentDoctor.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctor_id'];
    doctorName = json['doctor_name'];
    doctorImage = json['doctor_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctor_id'] = doctorId;
    data['doctor_name'] = doctorName;
    data['doctor_image'] = doctorImage;
    return data;
  }
}

class AppointmentClinic {
  int? clinicId;
  String? clinicName;
  String? clinicImage;

  AppointmentClinic({this.clinicId, this.clinicName, this.clinicImage});

  AppointmentClinic.fromJson(Map<String, dynamic> json) {
    clinicId = json['clinic_id'];
    clinicName = json['clinic_name'];
    clinicImage = json['clinic_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clinic_id'] = clinicId;
    data['clinic_name'] = clinicName;
    data['clinic_image'] = clinicImage;
    return data;
  }
}
