import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '../models/requests/onboarding_profile_request.dart';
import '../models/requests/otp_request.dart';
import '../models/responses/base_response_model.dart';

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
      if (authResponse.status == true) {
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
              authResponse.data!.isActiveExpiry! * 1000,
            ),
          );
          await _secureStorage.saveRefreshTokenExpiry(
            DateTime.fromMillisecondsSinceEpoch(
              authResponse.data!.refreshTokenExpiry! * 1000,
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
      requestBody: {"biometric_key": req.deviceHash},
      params: '',
    );

    // Check HTTP status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      AuthResponse authResponse = AuthResponse.fromJson(parsed);
      if (authResponse.status == true) {}
      return authResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(BaseResponseModel.fromJson(parsed).message as String);
    }
  }

  @override
  Future<AuthResponse> biometricLoginApi() async {
    final key = await _secureStorage.getSecureString(
      key: SharedPreferencesKeys.biometricAuthKey.keyText,
    );
    if (key == null) {
      throw const AppException('Biometrics not registered');
    }
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.biometricLogin,
      requestType: 'POST',
      requestBody: {"biometric_token": key},
      params: '',
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      AuthResponse authResponse = AuthResponse.fromJson(parsed);
      if (authResponse.status == true) {
        if (authResponse.data != null) {
          await _secureStorage.saveToken(authResponse.data!.accessToken!);
          await _secureStorage.saveRefreshToken(
            authResponse.data!.refreshToken!,
          );
          await _secureStorage.saveAccessTokenExpiry(
            DateTime.fromMillisecondsSinceEpoch(
              authResponse.data!.isActiveExpiry! * 1000,
            ),
          );
          await _secureStorage.saveRefreshTokenExpiry(
            DateTime.fromMillisecondsSinceEpoch(
              authResponse.data!.refreshTokenExpiry! * 1000,
            ),
          );
        }
      }
      return authResponse;
    } else {
      final parsed = json.decode(response.body);
      throw AppException(BaseResponseModel.fromJson(parsed).message as String);
    }
  }

  @override
  Future<BaseResponseModel> biometricUnregister() async {
    final key = await BiometricHelper.getDeviceSignature();
    await BiometricHelper.clearSignature();

    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.biometricUnregister,
      requestBody: {'biometric_key': key.deviceHash},
      requestType: 'DELETE',
    );
    final parsed = json.decode(response.body);
    final model = BaseResponseModel.fromJson(parsed);
    if (model.status ?? false) {
      return model;
    } else {
      throw Exception(model.message ?? 'Something went wrong!');
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
      if (authResponse.status == true) {
        final savedEmail = await _secureStorage.getUserEmail();
        if (savedEmail != authResponse.data?.user?.primaryEmail) {
          try {
            await biometricUnregister();
          } catch (e) {
            log('$e Failed to unregister biometric, Not important');
          }
        }
        if (authResponse.data != null) {
          await _secureStorage.saveUserEmail(
            authResponse.data!.user?.primaryEmail,
          );
          await _secureStorage.saveToken(authResponse.data!.accessToken!);
          await _secureStorage.saveRefreshToken(
            authResponse.data!.refreshToken!,
          );
          await _secureStorage.saveAccessTokenExpiry(
            DateTime.fromMillisecondsSinceEpoch(
              authResponse.data!.isActiveExpiry! * 1000,
            ),
          );
          await _secureStorage.saveRefreshTokenExpiry(
            DateTime.fromMillisecondsSinceEpoch(
              authResponse.data!.refreshTokenExpiry! * 1000,
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
      requestType: 'PATCH',
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
    String type = Platform.isIOS ? 'ios' : 'android';
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.getMe,
      requestType: 'GET',
      params: '?type=$type',
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
    required SocialLoginRequest request,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.socialLogin,
      requestType: 'POST',
      requestBody: request,
      params: '',
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      AuthResponse authResponse = AuthResponse.fromJson(parsed);
      if (!(authResponse.status ?? false) ||
          authResponse.data?.accessToken == null) {
        throw AppException(authResponse.message ?? 'Something went wrong!');
      }
      final savedEmail = await _secureStorage.getUserEmail();
      if (savedEmail != authResponse.data?.user?.primaryEmail) {
        try {
          await biometricUnregister();
        } catch (e) {
          log('$e Failed to unregister biometric, Not important');
        }
      }
      await _secureStorage.saveUserEmail(authResponse.data!.user?.primaryEmail);
      await _secureStorage.saveToken(authResponse.data!.accessToken!);
      await _secureStorage.saveRefreshToken(authResponse.data!.refreshToken!);
      await _secureStorage.saveAccessTokenExpiry(
        DateTime.fromMillisecondsSinceEpoch(
          authResponse.data!.isActiveExpiry! * 1000,
        ),
      );
      await _secureStorage.saveRefreshTokenExpiry(
        DateTime.fromMillisecondsSinceEpoch(
          authResponse.data!.refreshTokenExpiry! * 1000,
        ),
      );
      return authResponse;
    } else {
      final parsed = json.decode(response.body);
      throw AppException(BaseResponseModel.fromJson(parsed).message as String);
    }
  }

  @override
  Future<AuthResponse> appleSignInApi({
    required SocialLoginRequest request,
  }) async {
    final response = await _apiClient.httpRequest(
      endPoint: EndPoints.socialLogin,
      requestType: 'POST',
      requestBody: request,
      params: '',
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final parsed = json.decode(response.body);
      AuthResponse authResponse = AuthResponse.fromJson(parsed);
      if (!(authResponse.status ?? false) ||
          authResponse.data?.accessToken == null) {
        throw AppException(authResponse.message ?? 'Something went wrong!');
      }
      final savedEmail = await _secureStorage.getUserEmail();
      if (savedEmail != authResponse.data?.user?.primaryEmail) {
        try {
          await biometricUnregister();
        } catch (e) {
          log('$e Failed to unregister biometric, Not important');
        }
      }
      await _secureStorage.saveUserEmail(authResponse.data!.user?.primaryEmail);
      await _secureStorage.saveToken(authResponse.data!.accessToken!);
      await _secureStorage.saveRefreshToken(authResponse.data!.refreshToken!);
      await _secureStorage.saveAccessTokenExpiry(
        DateTime.fromMillisecondsSinceEpoch(
          authResponse.data!.isActiveExpiry! * 1000,
        ),
      );
      await _secureStorage.saveRefreshTokenExpiry(
        DateTime.fromMillisecondsSinceEpoch(
          authResponse.data!.refreshTokenExpiry! * 1000,
        ),
      );
      return authResponse;
    } else {
      final parsed = json.decode(response.body);
      throw AppException(BaseResponseModel.fromJson(parsed).message as String);
    }
  }
}
