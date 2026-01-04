import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_ai/models/requests/onboarding_profile_request.dart';
import 'package:skinsync_ai/models/requests/otp_request.dart';
import 'package:skinsync_ai/models/responses/base_response_model.dart';
import 'package:skinsync_ai/utills/shared_pref.dart';
import 'package:skinsync_ai/view_models/sign_up_onboarding_view_model.dart';
import '../models/base_state_model.dart';
import '../models/requests/sign_in_request.dart';
import '../models/responses/auth_response.dart';
import '../repositories/auth_repository.dart';
import '../services/api_base_helper.dart';
import '../services/auth_service.dart';
import 'base_view_model.dart';

final authViewModel = NotifierProvider(() {
  final apiBaseHelper = ApiBaseHelper();
  final authService = AuthService(apiClient: apiBaseHelper);
  return AuthViewModel(authRepository: authService);
});

class AuthViewModel extends BaseViewModel<AuthState> {
  AuthViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(initialState: AuthState());

  final AuthRepository _authRepository;
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  TextEditingController get phoneController => _phoneController;

  TextEditingController get passwordController => _passwordController;

  void setAuthResponse(AuthResponse response) {
    state = state.copyWith(authResponse: response);
  }

  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 512,
        maxHeight: 512,
      );
      if (image != null) {
        state = state.copyWith(profileImage: File(image.path));
      }
    } catch (e) {
      onError('Error picking image: $e');
    }
  }

  void clearProfileImage() {
    state = state.copyWith(clearProfileImage: true);
  }

  // Validate OTP
  bool validateOtp() {
    String otp = otpController.text.trim();
    String? errorMessage;

    if (otp.isEmpty) {
      errorMessage = "Please enter the OTP";
    } else if (otp.length != 6) {
      errorMessage = "OTP must be 6 digits long";
    }

    if (errorMessage != null) {
      state = state.copyWith(
        otpError: errorMessage,
      ); // Update the error in the state
      return false;
    }

    state = state.copyWith(clearOtpError: true); // Clear any existing errors
    return true;
  }

  Future<bool?> callSignInApi(BaseSignInRequest request) async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final BaseResponseModel response = await _authRepository.signInApi(
        signInRequest: request,
      );
      state = state.copyWith(loading: false);
      return response.isSuccess == true;
    });
  }

  Future<bool?> callVerifyOtpApi() async {
    final request = OtpRequest(
      email: emailController.text,
      otp: otpController.text,
    );
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final AuthResponse response = await _authRepository.verifyOTP(
        otpRequest: request,
      );
      state = state.copyWith(loading: false, authResponse: response);
  if(response.isSuccess == true){
    otpController.clear();
  }
      return response.isSuccess == true;
    });
  }

  Future<bool?> callOnboardingProfileApi({
    required OnBoardingProfileRequest request,
  }) async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final BaseResponseModel response = await _authRepository
          .onboardingProfile(onBoardingProfileRequest: request);
      state = state.copyWith(loading: false);
      if (response.isSuccess == true) {
        SharedPref().saveBool('isLogin', true);
      }
      return response.isSuccess == true;
    });
  }

void clearData(){
  emailController.clear();
  otpController.clear();
  clearProfileImage();

}

  @override
  void onError(String message) {
    super.onError(message);
    state = state.copyWith(
      loading: false,
      errorMessage: message,
      authResponse: AuthResponse(isSuccess: false, message: message),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

@immutable
class AuthState extends BaseStateModel {
  final AuthResponse? authResponse;
  final String? otpError;
  final File? profileImage;

  const AuthState({
    super.loading = false,
    super.errorMessage,
    this.authResponse,
    this.otpError,
    this.profileImage,
  });

  AuthState copyWith({
    bool? loading,
    String? errorMessage,
    bool? loginWithEmail,
    bool? loginWithPhone,
    AuthResponse? authResponse,
    String? otpError,
    bool clearOtpError = false,
    File? profileImage,
    bool clearProfileImage = false,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      authResponse: authResponse ?? this.authResponse,
      otpError: clearOtpError ? null : (otpError ?? this.otpError),
      profileImage: clearProfileImage
          ? null
          : (profileImage ?? this.profileImage),
    );
  }
}
