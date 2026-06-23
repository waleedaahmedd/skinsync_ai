import 'base_response_model.dart';
import 'treatment_response_model.dart';

class AuthResponse extends BaseResponseModel {
  final Data? data;

  AuthResponse({super.status, super.message, this.data});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  final bool? isFirstLogin;
  final bool? isActive;
  final String? accessToken;
  final String? refreshToken;
  final int? isActiveExpiry;
  final int? refreshTokenExpiry;
  final List<TreatmentsModel>? treatment;
  final User? user;
  final String? dashboard;

  Data({
    this.isFirstLogin,
    this.isActive,
    this.accessToken,
    this.refreshToken,
    this.isActiveExpiry,
    this.refreshTokenExpiry,
    this.user,
    this.dashboard,
    this.treatment,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    isFirstLogin: json["is_first_login"],
    isActive: json["is_active"],
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
    isActiveExpiry: json["is_active_expiry"],
    refreshTokenExpiry: json["refresh_token_expiry"],
    treatment: json["treatment"] == null
        ? []
        : List<TreatmentsModel>.from(
            json["treatment"]!.map((x) => TreatmentsModel.fromJson(x)),
          ),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    dashboard: json["dashboard"],
  );
}

class User {
  final int? id;
  final int? userProfileId;
  final String? primaryEmail;
  final String? primaryPhone;
  final String? fcmToken;
  final String? status;
  final String? name;
  final String? phoneNumber;
  final String? emailAddress;
  final String? location;
  final String? bio;
  final String? profileImageUrl;
  final String? cc;
  final String? country;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.userProfileId,
    this.primaryEmail,
    this.primaryPhone,
    this.fcmToken,
    this.status,
    this.name,
    this.phoneNumber,
    this.emailAddress,
    this.location,
    this.bio,
    this.profileImageUrl,
    this.cc,
    this.country,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    userProfileId: json["user_profile_id"],
    primaryEmail: json["primary_email"],
    primaryPhone: json["primary_phone"],
    fcmToken: json["fcm_token"],
    status: json["status"],
    name: json["name"],
    phoneNumber: json["phone_number"],
    emailAddress: json["email_address"],
    location: json["location"],
    bio: json["bio"],
    profileImageUrl: json["profile_image_url"],
    cc: json["cc"],
    country: json["country"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );
}
