import 'auth_response.dart';
import 'base_response_model.dart';

class RefreshTokenResponse extends BaseResponseModel {
  final RefreshTokenData? data;

  RefreshTokenResponse({super.status, super.message, this.data});

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        status: json["is_success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : RefreshTokenData.fromJson(json["data"]),
      );
}

class RefreshTokenData {
  final String? accessToken;
  final String? refreshToken;
  final int? accessExpiresAt;
  final int? refreshExpiresAt;
  final User? user;

  RefreshTokenData({
    this.accessToken,
    this.refreshToken,
    this.accessExpiresAt,
    this.refreshExpiresAt,
    this.user,
  });

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) =>
      RefreshTokenData(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        accessExpiresAt: json["access_expires_at"],
        refreshExpiresAt: json["refresh_expires_at"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );
}
