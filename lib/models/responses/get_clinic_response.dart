import 'package:skinsync_ai/models/responses/base_response_model.dart';

class GetClinicResponse extends BaseResponseModel {
  List<Clinic>? data;
 

  GetClinicResponse({this.data, super.isSuccess, super.message});

  GetClinicResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Clinic>[];
      json['data'].forEach((v) {
        data!.add(new Clinic.fromJson(v));
      });
    }
    isSuccess = json['is_success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['is_success'] = this.isSuccess;
    data['message'] = this.message;
    return data;
  }
}

class Clinic {
  int? clinicId;
  String? clinicName;
  String? email;
  String? phone;
  String? address;
  String? logo;
  int? price;
  int? syringeSize;
  String? status;

  Clinic(
      {this.clinicId,
      this.clinicName,
      this.email,
      this.phone,
      this.address,
      this.logo,
      this.price,
      this.syringeSize,
      this.status});

  Clinic.fromJson(Map<String, dynamic> json) {
    clinicId = json['clinic_id'];
    clinicName = json['clinic_name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    logo = json['logo'];
    price = json['price'];
    syringeSize = json['syringe_size'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinic_id'] = this.clinicId;
    data['clinic_name'] = this.clinicName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['logo'] = this.logo;
    data['price'] = this.price;
    data['syringe_size'] = this.syringeSize;
    data['status'] = this.status;
    return data;
  }
}
