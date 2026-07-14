class InviteClinicRequest {
  final String name;
  final String email;
  final String phone;
  final String cc;
  final String country;
  final String address;
  final String logo;
  final String? ownerName;
  final String? ownerEmail;
  final double? latitude;
  final double? longitude;
  final String website;
  final String description;
  final num? consultationFee;
  final num? initialDeposit;
  final List<AvailabilityModel> availability;
  final String? banner;

  InviteClinicRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.cc,
    required this.country,
    required this.address,
    required this.logo,
    this.ownerName,
    this.ownerEmail,
    this.latitude,
    this.longitude,
    required this.website,
    required this.description,
    this.consultationFee,
    this.initialDeposit,
    this.availability = const [],
    this.banner,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['cc'] = cc;
    data['country'] = country;
    data['phone'] = phone;
    data['address'] = address;
    data['logo'] = logo;
    data['owner_name'] = ownerName;
    data['owner_email'] = ownerEmail;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['website'] = website;
    data['description'] = description;
    data['consultation_fee'] = consultationFee;
    data['initial_deposit'] = initialDeposit;
    data['banner'] = banner;
    data['availability'] = availability.map((v) => v.toJson()).toList();
    return data;
  }
}

class AvailabilityModel {
  String? openTime;
  String? closeTime;
  List<String>? days;

  AvailabilityModel({this.openTime, this.closeTime, this.days});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    data['days'] = days;
    return data;
  }
}
