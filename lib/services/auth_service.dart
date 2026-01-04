import 'dart:async';
import 'dart:convert';

import 'package:skinsync_ai/models/requests/onboarding_profile_request.dart';
import 'package:skinsync_ai/models/requests/otp_request.dart';
import 'package:skinsync_ai/models/responses/base_response_model.dart';
import 'package:skinsync_ai/models/responses/on_boarding_question_response.dart';

import '../exceptions/app_exception.dart';
import '../models/requests/sign_in_request.dart';
import '../models/responses/auth_response.dart';
import '../repositories/auth_repository.dart';
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
      BaseResponseModel authResponse = BaseResponseModel.fromJson(parsed);
      // if (authResponse.isSuccess == true) {
      //   _secureStorage.saveSecureString(
      //     key: '',
      //     value: authResponse.data?.clientToken ?? '',
      //   );
      // }
      return authResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(BaseResponseModel.fromJson(parsed).message as String);
    }
  }
  @override
  Future <AuthResponse> verifyOTP({required OtpRequest otpRequest}) async{
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
        _secureStorage.saveSecureString(
          key: 'auth_token',
          value: authResponse.data?.accessToken ?? '',
        );
      }
      return authResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(AuthResponse.fromJson(parsed).message as String);
    }
  }
  @override
  Future <BaseResponseModel> onboardingProfile({required OnBoardingProfileRequest onBoardingProfileRequest } ) async{
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
}
