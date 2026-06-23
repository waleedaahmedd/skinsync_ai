import '../models/requests/onboarding_profile_request.dart';
import '../models/requests/otp_request.dart';
import '../models/responses/base_response_model.dart';

import '../models/requests/sign_in_request.dart';
import '../models/responses/auth_response.dart';

abstract class AuthRepository {
  Future<BaseResponseModel> signInApi({
    required BaseSignInRequest signInRequest,
  });
  Future<BaseResponseModel> biometricRegisterApi();
  Future<AuthResponse> biometricLoginApi();
  Future<BaseResponseModel> biometricUnregister();
  Future<AuthResponse> verifyOTP({required OtpRequest otpRequest});

  Future<BaseResponseModel> onboardingProfile({
    required OnBoardingProfileRequest onBoardingProfileRequest,
  });
  Future<AuthResponse> getMe();

  Future<AuthResponse> googleSignInApi({
    required SocialLoginRequest request,
  });

  Future<AuthResponse> appleSignInApi({
    required SocialLoginRequest request,
  });
}
