import 'base_response_model.dart';

class GetAppointmentResponse extends BaseResponseModel {
  AppointmentListData? data;

  GetAppointmentResponse({this.data, super.isSuccess, super.message});

  GetAppointmentResponse.fromJson(Map<String, dynamic> json) {
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
  int? date;
  AppointmentSlot? slot;
  String? appointmentType;
  int? appointmentTypeId;
  String? status;
  List<AppointmentTreatment>? treatments;
  AppointmentDoctor? doctor;
  AppointmentClinic? clinic;

  AppointmentItem({
    this.date,
    this.slot,
    this.appointmentType,
    this.appointmentTypeId,
    this.status,
    this.treatments,
    this.doctor,
    this.clinic,
  });

  AppointmentItem.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    slot = json['slot'] != null ? AppointmentSlot.fromJson(json['slot']) : null;
    appointmentType = json['appointment_type'];
    appointmentTypeId = json['appointment_type_id'];
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
    data['date'] = date;
    if (slot != null) {
      data['slot'] = slot!.toJson();
    }
    data['appointment_type'] = appointmentType;
    data['appointment_type_id'] = appointmentTypeId;
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
  int? areaId;
  String? areaName;
  AppointmentMaterial? material;

  AppointmentTreatment({
    this.treatmentId,
    this.treatmentName,
    this.areaId,
    this.areaName,
    this.material,
  });

  AppointmentTreatment.fromJson(Map<String, dynamic> json) {
    treatmentId = json['treatment_id'];
    treatmentName = json['treatment_name'];
    areaId = json['area_id'];
    areaName = json['area_name'];
    material = json['material'] != null ? AppointmentMaterial.fromJson(json['material']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['treatment_id'] = treatmentId;
    data['treatment_name'] = treatmentName;
    data['area_id'] = areaId;
    data['area_name'] = areaName;
    if (material != null) {
      data['material'] = material!.toJson();
    }
    return data;
  }
}

class AppointmentMaterial {
  int? id;
  int? selectedQuantity;

  AppointmentMaterial({this.id, this.selectedQuantity});

  AppointmentMaterial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    selectedQuantity = json['selected_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['selected_quantity'] = selectedQuantity;
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

final GetAppointmentResponse dummyAppointmentResponse = GetAppointmentResponse(
  isSuccess: true,
  message: "Dummy appointments",
  data: AppointmentListData(
    page: 1,
    limit: 10,
    total: 1,
    totalPages: 1,
    items: [
      AppointmentItem(
        date: 1753142400,
        appointmentType: "Treatment session",
        appointmentTypeId: 12,
        status: "Confirmed",
        slot: AppointmentSlot(
          startTime: 1753142400 + 3600 * 9, // 9 AM
          endTime: 1753142400 + 3600 * 11, // 11 AM
        ),
        doctor: AppointmentDoctor(
          doctorId: 1,
          doctorName: "Dr. Sarah Smith",
          doctorImage: "https://t4.ftcdn.net/jpg/03/20/52/31/360_F_320523164_cc7at9W77BRD96qLYpSPlSdrofD8oM0S.jpg",
        ),
        clinic: AppointmentClinic(
          clinicId: 1,
          clinicName: "Glow Skin Clinic",
          clinicImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQl-cyJqFlcZav1TlRMEuajtrg2RJlWY3rTQA&s",
        ),
        treatments: [
          AppointmentTreatment(
            treatmentId: 1,
            treatmentName: "Botox",
            areaId: 5,
            areaName: "Pre Jaw",
            material: AppointmentMaterial(id: 101, selectedQuantity: 2),
          ),
          AppointmentTreatment(
            treatmentId: 2,
            treatmentName: "Dermal Filler",
            areaId: 8,
            areaName: "Cheeks",
            material: AppointmentMaterial(id: 102, selectedQuantity: 1),
          ),
        ],
      ),
    ],
  ),
);
