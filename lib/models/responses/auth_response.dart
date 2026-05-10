import 'package:skinsync_ai/models/responses/treatment_response_model.dart';

import 'base_response_model.dart';

class AuthResponse extends BaseResponseModel {
  final Data? data;

  AuthResponse({super.isSuccess, super.message, this.data});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    isSuccess: json["is_success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  final String? accessToken;
  final String? refreshToken;
  final int? isActiveExpiry;
  final int? refreshTokenExpiry;
  final bool? isFirstLogin;
  final bool? isActive;
  final User? user;
  final UserDetails? userDetails;
  final List<TreatmentsModel>? treatment;

  const Data({
    this.accessToken,
    this.refreshToken,
    this.isActiveExpiry,
    this.refreshTokenExpiry,
    this.isFirstLogin,
    this.isActive,
    this.user,
    this.userDetails,
    this.treatment,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
    isActiveExpiry: json["is_active_expiry"],
    refreshTokenExpiry: json["refresh_token_expiry"],
    isFirstLogin: json["is_first_login"],
    isActive: json["is_active"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    userDetails: json["userDetails"] == null
        ? null
        : UserDetails.fromJson(json["userDetails"]),
    treatment: json["treatment"] == null
        ? []
        : List<TreatmentsModel>.from(
            json["treatment"]!.map((x) => TreatmentsModel.fromJson(x)),
          ),
  );
}

class User {
  final int? id;
  final String? primaryEmail;
  final String? primaryPhone;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> authProviders;
  final List<String> authTokens;
  final List<String> roles;

  const User({
    this.id,
    this.primaryEmail,
    this.primaryPhone,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.authProviders = const [],
    this.authTokens = const [],
    this.roles = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    primaryEmail: json["primary_email"],
    primaryPhone: json["primary_phone"],
    status: json["status"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    authProviders: json["AuthProviders"] ?? <String>[],
    authTokens: json["AuthTokens"] ?? <String>[],
    roles: json["Roles"] ?? <String>[],
  );
}

class UserDetails {
  final int? userProfileId;
  final int? userId;
  final String? name;
  final String? phoneNumber;
  final String? emailAddress;
  final String? location;
  final String? bio;
  final String? profileImageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserDetails({
    this.userProfileId,
    this.userId,
    this.name,
    this.phoneNumber,
    this.emailAddress,
    this.location,
    this.bio,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    userProfileId: json["user_profile_id"],
    userId: json["user_id"],
    name: json["name"],
    phoneNumber: json["phone_number"],
    emailAddress: json["email_address"],
    location: json["location"],
    bio: json["bio"],
    profileImageUrl: json["profile_image_url"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );
}
