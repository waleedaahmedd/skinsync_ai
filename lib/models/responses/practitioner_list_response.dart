import 'base_response_model.dart';

class PractitionerListResponse extends BaseResponseModel {
  PractitionerListData? data;

  PractitionerListResponse({this.data, super.isSuccess, super.message});

  PractitionerListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
    data = json['data'] != null ? PractitionerListData.fromJson(json['data']) : null;
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

class PractitionerListData {
  List<PractitionerDoctor>? doctors;
  int? limit;
  int? page;
  int? total;
  int? totalPages;

  PractitionerListData({this.doctors, this.limit, this.page, this.total, this.totalPages});

  PractitionerListData.fromJson(Map<String, dynamic> json) {
    if (json['doctors'] != null) {
      doctors = <PractitionerDoctor>[];
      json['doctors'].forEach((v) {
        doctors!.add(PractitionerDoctor.fromJson(v));
      });
    }
    limit = json['limit'];
    page = json['page'];
    total = json['total'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (doctors != null) {
      data['doctors'] = doctors!.map((v) => v.toJson()).toList();
    }
    data['limit'] = limit;
    data['page'] = page;
    data['total'] = total;
    data['total_pages'] = totalPages;
    return data;
  }
}

class PractitionerDoctor {
  int? doctorId;
  String? doctorImage;
  num? doctorRating;
  String? doctorName;
  String? specialization;
  PractitionerClinic? clinic;

  PractitionerDoctor({
    this.doctorId,
    this.doctorImage,
    this.doctorRating,
    this.doctorName,
    this.specialization,
    this.clinic,
  });

  PractitionerDoctor.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctor_id'];
    doctorImage = json['doctor_image'];
    doctorRating = json['doctor_rating'];
    doctorName = json['doctor_name'];
    specialization = json['specialization'];
    clinic = json['clinic'] != null ? PractitionerClinic.fromJson(json['clinic']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctor_id'] = doctorId;
    data['doctor_image'] = doctorImage;
    data['doctor_rating'] = doctorRating;
    data['doctor_name'] = doctorName;
    data['specialization'] = specialization;
    if (clinic != null) {
      data['clinic'] = clinic!.toJson();
    }
    return data;
  }
}

class PractitionerClinic {
  int? clinicId;
  String? clinicName;

  PractitionerClinic({this.clinicId, this.clinicName});

  PractitionerClinic.fromJson(Map<String, dynamic> json) {
    clinicId = json['clinic_id'];
    clinicName = json['clinic_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clinic_id'] = clinicId;
    data['clinic_name'] = clinicName;
    return data;
  }
}
