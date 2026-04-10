import 'dart:async';
import 'dart:convert';

import 'package:skinsync_ai/models/requests/onboarding_profile_request.dart';
import 'package:skinsync_ai/models/requests/otp_request.dart';
import 'package:skinsync_ai/models/responses/base_response_model.dart';

import '../exceptions/app_exception.dart';
import '../models/requests/sign_in_request.dart';
import '../models/responses/auth_response.dart';
import '../repositories/auth_repository.dart';
import '../utills/biometric_helper.dart';
import '../utills/enums.dart';
import '../utills/secure_storage_service.dart';
import 'api_base_helper.dart';

class AuthService implements AuthRepository {
  final ApiBaseHelper _apiClient;
  final SecureStorage _secureStorage = SecureStorage();

  AuthService({required ApiBaseHelper apiClient}) : _apiClient = apiClient;

  @override
  Future<BaseResponseModel> signInApi({
    required BaseSignInRequest signInRequest,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.signIn,
      requestType: 'POST',
      requestBody: signInRequest,
      params: '',
    );

    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      AuthResponse authResponse = AuthResponse.fromJson(parsed);
      if (authResponse.isSuccess == true) {
        // _secureStorage.saveSecureString(
        //   key: SharedPreferencesKeys.accessTokenKey.name,
        //   value: authResponse.data!.accessToken ?? '',
        // );
        if (authResponse.data != null) {
          await _secureStorage.saveToken(authResponse.data!.accessToken!);
          await _secureStorage.saveRefreshToken(
            authResponse.data!.refreshToken!,
          );
          await _secureStorage.saveAccessTokenExpiry(
            DateTime.fromMillisecondsSinceEpoch(
              authResponse.data!.accessExpiresAt! * 1000,
            ),
          );
          await _secureStorage.saveRefreshTokenExpiry(
            DateTime.fromMillisecondsSinceEpoch(
              authResponse.data!.refreshExpiresAt! * 1000,
            ),
          );
        }
      }
      return authResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(BaseResponseModel.fromJson(parsed).message as String);
    }
  }

  @override
  Future<BaseResponseModel> biometricRegisterApi() async {
    final req = await BiometricHelper.getDeviceSignature();
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.biometricRegister,
      requestType: 'POST',
      requestBody: req.toJson(),
      params: '',
    );

    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      AuthResponse authResponse = AuthResponse.fromJson(parsed);
      if (authResponse.isSuccess == true) {}
      return authResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(BaseResponseModel.fromJson(parsed).message as String);
    }
  }

  @override
  Future<BaseResponseModel> biometricLoginApi() async {
    final key = await _secureStorage.getSecureString(
      key: SharedPreferencesKeys.biometricAuthKey.keyText,
    );
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.biometricLogin,
      requestType: 'POST',
      requestBody: {"biometric_key": key},
      params: '',
    );

    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      AuthResponse authResponse = AuthResponse.fromJson(parsed);
      if (authResponse.isSuccess == true) {
        // _secureStorage.saveSecureString(
        //   key: SharedPreferencesKeys.accessTokenKey.name,
        //   value: authResponse.data!.accessToken ?? '',
        // );
        if (authResponse.data != null) {
          await _secureStorage.saveToken(authResponse.data!.accessToken!);
          await _secureStorage.saveRefreshToken(
            authResponse.data!.refreshToken!,
          );
          await _secureStorage.saveAccessTokenExpiry(
            DateTime.fromMillisecondsSinceEpoch(
              authResponse.data!.accessExpiresAt! * 1000,
            ),
          );
          await _secureStorage.saveRefreshTokenExpiry(
            DateTime.fromMillisecondsSinceEpoch(
              authResponse.data!.refreshExpiresAt! * 1000,
            ),
          );
        }
      }
      return authResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(BaseResponseModel.fromJson(parsed).message as String);
    }
  }

  @override
  Future<AuthResponse> verifyOTP({required OtpRequest otpRequest}) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.verifyOtp,
      requestType: 'POST',
      requestBody: otpRequest,
      params: '',
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      AuthResponse authResponse = AuthResponse.fromJson(parsed);
      if (authResponse.isSuccess == true) {
        if (authResponse.data != null) {
          await _secureStorage.saveToken(authResponse.data!.accessToken!);
          await _secureStorage.saveRefreshToken(
            authResponse.data!.refreshToken!,
          );
          await _secureStorage.saveAccessTokenExpiry(
            DateTime.fromMillisecondsSinceEpoch(
              authResponse.data!.accessExpiresAt! * 1000,
            ),
          );
          await _secureStorage.saveRefreshTokenExpiry(
            DateTime.fromMillisecondsSinceEpoch(
              authResponse.data!.refreshExpiresAt! * 1000,
            ),
          );
        }
      }
      return authResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(AuthResponse.fromJson(parsed).message as String);
    }
  }

  @override
  Future<BaseResponseModel> onboardingProfile({
    required OnBoardingProfileRequest onBoardingProfileRequest,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.onBoardingProfile,
      requestType: 'POST',
      requestBody: onBoardingProfileRequest,
      params: '',
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      BaseResponseModel authResponse = BaseResponseModel.fromJson(parsed);

      return authResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(BaseResponseModel.fromJson(parsed).message as String);
    }
  }

  @override
  Future<AuthResponse> getMe() async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.getMe,
      requestType: 'GET',
      params: '',
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      AuthResponse authResponse = AuthResponse.fromJson(parsed);
      return authResponse;
    } else {
      final parsed = json.decode(response.body);
      throw AppException(BaseResponseModel.fromJson(parsed).message as String);
    }
  }

  @override
  Future<AuthResponse> googleSignInApi({
    required SignInWithGoogleRequest request,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.signIn,
      requestType: 'POST',
      requestBody: request,
      params: '',
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      AuthResponse authResponse = AuthResponse.fromJson(parsed);
      if (!(authResponse.isSuccess ?? false) ||
          authResponse.data?.accessToken == null) {
        throw AppException(authResponse.message ?? 'Something went wrong!');
      }
      await _secureStorage.saveToken(authResponse.data!.accessToken!);
      await _secureStorage.saveRefreshToken(authResponse.data!.refreshToken!);
      await _secureStorage.saveAccessTokenExpiry(
        DateTime.fromMillisecondsSinceEpoch(
          authResponse.data!.accessExpiresAt! * 1000,
        ),
      );
      await _secureStorage.saveRefreshTokenExpiry(
        DateTime.fromMillisecondsSinceEpoch(
          authResponse.data!.refreshExpiresAt! * 1000,
        ),
      );
      return authResponse;
    } else {
      final parsed = json.decode(response.body);
      throw AppException(BaseResponseModel.fromJson(parsed).message as String);
    }
  }
}
