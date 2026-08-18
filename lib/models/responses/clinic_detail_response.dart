import 'base_response_model.dart';

class ClinicDetailResponse extends BaseResponseModel {
  final ClinicDetailData? data;

  ClinicDetailResponse({super.isSuccess, super.message, this.data});

  factory ClinicDetailResponse.fromJson(Map<String, dynamic> json) =>
      ClinicDetailResponse(
        isSuccess: json["is_success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : ClinicDetailData.fromJson(json["data"]),
      );
}

class ClinicDetailData {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int? consultationFee;
  final int? initialDeposit;
  final String? description;
  final String? website;
  final String? cc;
  final String? country;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? logo; // Added based on journey_clinic_detail_screen.dart usage
  final String? bannerImage;

  ClinicDetailData({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.consultationFee,
    this.initialDeposit,
    this.description,
    this.website,
    this.cc,
    this.country,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.logo,
    this.bannerImage,
  });

  factory ClinicDetailData.fromJson(Map<String, dynamic> json) =>
      ClinicDetailData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        consultationFee: json["consultation_fee"],
        initialDeposit: json["initial_deposit"],
        description: json["description"],
        website: json["website"],
        cc: json["cc"],
        country: json["country"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]).toLocal(),
        logo: json["logo"],
        bannerImage: json["banner_image"],
      );
}
