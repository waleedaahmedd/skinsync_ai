import 'base_response_model.dart';

class GetDoctorResponse extends BaseResponseModel {
  List<Doctor>? data;

  GetDoctorResponse({this.data, super.status, super.message});

  GetDoctorResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Doctor>[];
      json['data'].forEach((v) {
        data!.add(Doctor.fromJson(v));
      });
    }
    status = json['is_success'];
    message = json['message'];
  }
}

class Doctor {
  int? id;
  String? name;
  String? email;
  String? role;
  String? status;
  String? image;
  String? specialization;
  String? phone;
  String? cc;
  String? country;

  Doctor({
    this.id,
    this.name,
    this.email,
    this.role,
    this.status,
    this.image,
    this.specialization,
    this.phone,
    this.cc,
    this.country,
  });

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    status = json['status'];
    image = json['image'];
    specialization = json['specialization'];
    phone = json['phone'];
    cc = json['cc'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'status': status,
      'image': image,
      'specialization': specialization,
      'phone': phone,
      'cc': cc,
      'country': country,
    };
  }
}
