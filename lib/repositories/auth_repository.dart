import 'package:skinsync_ai/models/requests/onboarding_profile_request.dart';
import 'package:skinsync_ai/models/requests/otp_request.dart';
import 'package:skinsync_ai/models/responses/base_response_model.dart';

import '../models/requests/sign_in_request.dart';
import '../models/responses/auth_response.dart';

abstract class AuthRepository {
  Future<BaseResponseModel> signInApi({
    required BaseSignInRequest signInRequest,
  });
  Future<BaseResponseModel> biometricRegisterApi();
  Future<BaseResponseModel> biometricLoginApi();
  Future<AuthResponse> verifyOTP({required OtpRequest otpRequest});
  Future<BaseResponseModel> onboardingProfile({
    required OnBoardingProfileRequest onBoardingProfileRequest,
  });
  Future<AuthResponse> getMe();

  Future<AuthResponse> googleSignInApi({
    required SignInWithGoogleRequest request,
  });

  Future<AuthResponse> appleSignInApi({
    required SignInWithAppleRequest request,
  });
}
