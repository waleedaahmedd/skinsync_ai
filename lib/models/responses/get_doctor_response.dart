import 'package:skinsync_ai/models/responses/base_response_model.dart';

class GetDoctorResponse extends BaseResponseModel {
  List<Doctor>? data;
 

  GetDoctorResponse({this.data, super.isSuccess, super.message});

  GetDoctorResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Doctor>[];
      json['data'].forEach((v) {
        data!.add(new Doctor.fromJson(v));
      });
    }
    isSuccess = json['is_success'];
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

  Doctor(
      {this.id,
      this.name,
      this.email,
      this.role,
      this.status,
      this.image,
      this.specialization,
      this.phone});

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    status = json['status'];
    image = json['image'];
    specialization = json['specialization'];
    phone = json['phone'];
  }


}
