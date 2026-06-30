import 'base_response_model.dart';
import 'treatment_list_response.dart';

class AuthResponse extends BaseResponseModel {
  final AuthData? data;

  AuthResponse({super.isSuccess, super.message, this.data});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    isSuccess: json["is_success"],
    message: json["message"],
    data: json["data"] == null ? null : AuthData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "message": message,
    "data": data?.toJson(),
  };
}

class AuthData {
  final bool? isFirstLogin;
  final bool? isActive;
  final String? accessToken;
  final String? refreshToken;
  final int? isActiveExpiry;
  final int? refreshTokenExpiry;
  final List<TreatmentData>? treatment;
  final User? user;
  final String? dashboard;

  AuthData({
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

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
    isFirstLogin: json["is_first_login"],
    isActive: json["is_active"],
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
    isActiveExpiry: json["is_active_expiry"],
    refreshTokenExpiry: json["refresh_token_expiry"],
    treatment: json["treatment"] == null
        ? []
        : List<TreatmentData>.from(
            json["treatment"]!.map((x) => TreatmentData.fromJson(x)),
          ),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    dashboard: json["dashboard"],
  );

  Map<String, dynamic> toJson() => {
    "is_first_login": isFirstLogin,
    "is_active": isActive,
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "is_active_expiry": isActiveExpiry,
    "refresh_token_expiry": refreshTokenExpiry,
    "treatment": treatment == null
        ? []
        : List<dynamic>.from(treatment!.map((x) => x.toJson())),
    "user": user?.toJson(),
    "dashboard": dashboard,
  };
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? role;
  final String? profileImageUrl;
  final String? primaryEmail;
  final String? phoneNumber;
  final String? location;
  final String? bio;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.profileImageUrl,
    this.primaryEmail,
    this.phoneNumber,
    this.location,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    profileImageUrl: json["profile_image_url"],
    primaryEmail: json["primary_email"] ?? json["email"],
    phoneNumber: json["phone_number"],
    location: json["location"],
    bio: json["bio"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
    "profile_image_url": profileImageUrl,
    "primary_email": primaryEmail,
    "phone_number": phoneNumber,
    "location": location,
    "bio": bio,
  };
}
