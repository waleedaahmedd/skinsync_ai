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
  List<PractitionerDoctor>? practitioners;
  int? limit;
  int? page;
  int? total;
  int? totalPages;

  PractitionerListData({this.practitioners, this.limit, this.page, this.total, this.totalPages});

  PractitionerListData.fromJson(Map<String, dynamic> json) {
    if (json['practitioners'] != null) {
      practitioners = <PractitionerDoctor>[];
      json['practitioners'].forEach((v) {
        practitioners!.add(PractitionerDoctor.fromJson(v));
      });
    } else if (json['doctors'] != null) {
       // fallback for older versions if any
      practitioners = <PractitionerDoctor>[];
      json['doctors'].forEach((v) {
        practitioners!.add(PractitionerDoctor.fromJson(v));
      });
    }
    limit = json['limit'];
    page = json['page'];
    total = json['total'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (practitioners != null) {
      data['practitioners'] = practitioners!.map((v) => v.toJson()).toList();
    }
    data['limit'] = limit;
    data['page'] = page;
    data['total'] = total;
    data['total_pages'] = totalPages;
    return data;
  }

  // Backward compatibility getter
  List<PractitionerDoctor>? get doctors => practitioners;
}

class PractitionerDoctor {
  int? id;
  String? image;
  num? rating;
  String? name;
  String? practitionerType;
  String? specialization;
  PractitionerClinic? clinic;

  PractitionerDoctor({
    this.id,
    this.image,
    this.rating,
    this.name,
    this.practitionerType,
    this.specialization,
    this.clinic,
  });

  PractitionerDoctor.fromJson(Map<String, dynamic> json) {
    id = json['practitioner_id'] ?? json['doctor_id'];
    image = json['practitioner_image'] ?? json['doctor_image'];
    rating = json['practitioner_rating'] ?? json['doctor_rating'];
    name = json['practitioner_name'] ?? json['doctor_name'];
    practitionerType = json['practitioner_type'];
    specialization = json['specialization'];
    clinic = json['clinic'] != null ? PractitionerClinic.fromJson(json['clinic']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['practitioner_id'] = id;
    data['practitioner_image'] = image;
    data['practitioner_rating'] = rating;
    data['practitioner_name'] = name;
    data['practitioner_type'] = practitionerType;
    data['specialization'] = specialization;
    if (clinic != null) {
      data['clinic'] = clinic!.toJson();
    }
    return data;
  }

  // Backward compatibility getters
  int? get doctorId => id;
  String? get doctorImage => image;
  num? get doctorRating => rating;
  String? get doctorName => name;
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
