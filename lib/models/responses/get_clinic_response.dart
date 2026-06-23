import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'base_response_model.dart';
import 'map_clinics_response.dart';

class GetClinicResponse extends BaseResponseModel {
  List<Clinic>? data;

  GetClinicResponse({this.data, super.status, super.message});

  GetClinicResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Clinic>[];
      json['data'].forEach((v) {
        data!.add(Clinic.fromJson(v));
      });
    }
    status = json['is_success'];
    message = json['message'];
  }
}

class Clinic {
  final int? clinicId;
  final String? clinicName;
  final String? email;
  final String? phone;
  final String? description;
  final String? address;
  final String? logo;
  final int? price;
  final int? syringeSize;
  final String? status;
  final LatLng? location;
  final Place? place;

  Clinic({
    this.clinicId,
    this.clinicName,
    this.email,
    this.phone,
    this.description,
    this.address,
    this.logo,
    this.price,
    this.syringeSize,
    this.status,
    this.location,
    this.place,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      clinicId: json['clinic_id'],
      clinicName: json['clinic_name'],
      email: json['email'],
      phone: json['phone'],
      description: json['description'],
      address: json['address'],
      logo: json['logo'],
      price: json['price'],
      syringeSize: json['syringe_size'],
      status: json['status'],
      location: json['location'] != null
          ? LatLng(json['location']['lat'], json['location']['lng'])
          : null,
      place: json['place'] != null ? Place.fromJson(json['place']) : null,
    );
  }
}
