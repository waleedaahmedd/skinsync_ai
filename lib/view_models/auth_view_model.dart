import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:skinsync_ai/models/requests/app_version_request.dart';
import 'package:skinsync_ai/models/requests/onboarding_profile_request.dart';
import 'package:skinsync_ai/models/requests/otp_request.dart';
import 'package:skinsync_ai/models/responses/address_data.dart';
import 'package:skinsync_ai/models/responses/base_response_model.dart';
import 'package:skinsync_ai/services/apple_auth_service.dart';
import 'package:skinsync_ai/services/google_auth_service.dart';
import 'package:skinsync_ai/services/location_service.dart';
import 'package:skinsync_ai/services/media_service.dart';

import '../models/base_state_model.dart';
import '../models/requests/sign_in_request.dart';
import '../models/responses/auth_response.dart';
import '../repositories/auth_repository.dart';
import '../services/api_base_helper.dart';
import '../services/auth_service.dart';
import '../utills/enums.dart';
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

  @override
  void init() {
    getDeviceInfo();
    super.init();
  }

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
        state = state.copyWith(profileImage: image);
      }
    } catch (e) {
      onError('Error picking image: $e');
    }
  }

  Future<void> getDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    String type = Platform.isIOS ? 'ios' : 'android';
    log('hello from Get Device info');

    state = state.copyWith(
      device: type,
      version: packageInfo.version,
      build: packageInfo.buildNumber,
    );
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
      state = state.copyWith(otpError: errorMessage);
      return false;
    }

    state = state.copyWith(clearOtpError: true);
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

  Future<bool?> callBiometricRegisterApi() async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final BaseResponseModel response = await _authRepository
          .biometricRegisterApi();
      state = state.copyWith(loading: false);
      return response.isSuccess == true;
    });
  }

  Future<bool?> callBiometricLoginApi(String key) async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final BaseResponseModel response = await _authRepository
          .biometricLoginApi();
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

      if (response.isSuccess == true) {
        otpController.clear();
        _fetchLocationInBackground();
      }
      return response.isSuccess == true;
    });
  }


  Future<bool?> callOnboardingProfileApi({
    required String name,
    required String phoneNumber,
    required String emailAddress,
    required String location,
    required String bio,
  }) async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);

      String? imageUrl;
      if (state.profileImage != null) {
        imageUrl = await MediaService().uploadImage(
          state.authResponse?.data?.user?.primaryEmail ?? '',
          state.profileImage!,
        );
      }

      final request = OnBoardingProfileRequest(
        name: name,
        phoneNumber: phoneNumber,
        emailAddress: emailAddress,
        location: location,
        bio: bio,
        profileImageUrl:
            imageUrl ??
            state.authResponse?.data?.userDetails?.profileImage ??
            "",
      );

      final BaseResponseModel response = await _authRepository
          .onboardingProfile(onBoardingProfileRequest: request);

      state = state.copyWith(loading: false);
      if (response.isSuccess == true) {
        await callGetMe();
        clearProfileImage();
      }
      return response.isSuccess == true;
    });
  }

  Future<bool?> callGetMe() async {
    return await runSafely(() async {
      final AuthResponse response = await _authRepository.getMe(
        type: state.device!,
      );
      if (response.isSuccess == true) {
        state = state.copyWith(authResponse: response);
        log('get me call successful,');
        // Location is fetched in background to avoid blocking the UI thread during splash/init
        _fetchLocationInBackground();
      }
      return response.isSuccess == true;
    });
  }

  void _fetchLocationInBackground() {
    // Slight delay to ensure it doesn't collide with navigation animations
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        final addressData = await LocationService().fetchAddress();
        state = state.copyWith(addressData: addressData);
      } catch (e) {
        log('Background location fetch skipped or failed: $e');
      }
    });
  }

  Future<bool?> callGoogleSignInApi() async {
    return await runSafely<bool>(() async {
      state = state.copyWith(loading: true);
      final user = await GoogleAuthService().signIn();
      final response = await _authRepository.googleSignInApi(
        request: SignInWithGoogleRequest(
          email: user.email!,
          googleUid: user.uid,
          provider: LoginProviders.google,
          deviceInfo: '',
          ipAddress: '',
        ),
      );
      if (response.isSuccess ?? false) {
        await callGetMe();
      }
      state = state.copyWith(loading: false);
      return response.isSuccess ?? false;
    });
  }

  Future<bool?> callAppleSignInApi() async {
    return await runSafely<bool>(() async {
      state = state.copyWith(loading: true);
      final user = await AppleAuthService().signIn();
      final response = await _authRepository.appleSignInApi(
        request: SignInWithAppleRequest(
          email: user.email ?? '',
          appleUid: user.uid,
          provider: LoginProviders.apple,
          deviceInfo: '',
          ipAddress: '',
        ),
      );
      if (response.isSuccess ?? false) {
        await callGetMe();
      }
      state = state.copyWith(loading: false);
      return response.isSuccess ?? false;
    });
  }

  void clearData() {
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
  final String? build;
  final String? device;
  final String? version;
  final XFile? profileImage;
  final AddressData? addressData;

  const AuthState({
    super.loading = false,
    super.errorMessage,
    this.authResponse,
    this.otpError,
    this.profileImage,
    this.addressData,
    this.build,
    this.device,
    this.version,
  });

  @override
  AuthState copyWith({
    bool? loading,
    String? errorMessage,
    bool? loginWithEmail,
    bool? loginWithPhone,
    String? build,
    String? device,
    String? version,
    AuthResponse? authResponse,
    String? otpError,
    bool clearOtpError = false,
    XFile? profileImage,
    bool clearProfileImage = false,
    AddressData? addressData,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      authResponse: authResponse ?? this.authResponse,
      otpError: clearOtpError ? null : (otpError ?? this.otpError),
      profileImage: clearProfileImage
          ? null
          : (profileImage ?? this.profileImage),
      addressData: addressData ?? this.addressData,
      build: build ?? this.build,
      device: device ?? this.device,
      version: version ?? this.version,
    );
  }
}
