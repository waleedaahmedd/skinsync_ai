import 'package:skinsync_ai/models/responses/base_response_model.dart';
import 'package:skinsync_ai/models/responses/treatment_response_model.dart';

class AuthResponse extends BaseResponseModel {
  
  Data? data;

  AuthResponse({super.isSuccess, super.message, this.data});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

 
}

class Data {
  String? accessToken;
  String? refreshToken;
  int? accessExpiresAt;
  int? refreshExpiresAt;
  bool? isFirstLogin;
  User? user;
  UserDetails? userDetails;
  List<TreatmentsModel>? treatment;

  Data(
      {this.accessToken,
      this.refreshToken,
      this.accessExpiresAt,
      this.refreshExpiresAt,
      this.isFirstLogin,
      this.user,
      this.userDetails,
      this.treatment});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    accessExpiresAt = json['access_expires_at'];
    refreshExpiresAt = json['refresh_expires_at'];
    isFirstLogin = json['is_first_login'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
    if (json['treatment'] != null) {
      treatment = <TreatmentsModel>[];
      json['treatment'].forEach((v) {
        treatment!.add(new TreatmentsModel.fromJson(v));
      });
    }
  }

 
}

class User {
  int? id;
  String? primaryEmail;
  String? primaryPhone;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? authProviders;
  String? authTokens;
  String? roles;

  User(
      {this.id,
      this.primaryEmail,
      this.primaryPhone,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.authProviders,
      this.authTokens,
      this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    primaryEmail = json['primary_email'];
    primaryPhone = json['primary_phone'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    authProviders = json['AuthProviders'];
    authTokens = json['AuthTokens'];
    roles = json['Roles'];
  }

}

class UserDetails {
  int? userProfileId;
  int? userId;
  String? name;
  String? phoneNumber;
  String? emailAddress;
  String? location;
  String? bio;
  String? createdAt;
  String? updatedAt;

  UserDetails(
      {this.userProfileId,
      this.userId,
      this.name,
      this.phoneNumber,
      this.emailAddress,
      this.location,
      this.bio,
      this.createdAt,
      this.updatedAt});

  UserDetails.fromJson(Map<String, dynamic> json) {
    userProfileId = json['user_profile_id'];
    userId = json['user_id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    emailAddress = json['email_address'];
    location = json['location'];
    bio = json['bio'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}

