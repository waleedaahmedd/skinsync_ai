import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;

  TextEditingController get passwordController => _passwordController;

  void setAuthResponse(AuthResponse response) {
    state = state.copyWith(authResponse: response);
  }

  void setloginWithEmail(bool value) {
    // _loginWithEmail = value;
    // _loginWithPhone = !value;
    // notifyListeners();
    state = state.copyWith(loginWithEmail: value, loginWithPhone: !value);
  }

  void setloginWithPhone(bool value) {
    // _loginWithPhone = value;
    // _loginWithEmail = !value;
    // notifyListeners();
    state = state.copyWith(loginWithPhone: value, loginWithEmail: !value);
  }

  void setLoading(bool value) {
    state = state.copyWith(loading: value);
  }

  Future<bool?> callSignInApi() async {
    return await runSafely(() async {
      setLoading(true);
      final SignInRequest signInRequest = SignInRequest(
        password: _passwordController.text,
        email: _emailController.text,
        deviceToken: 'wqwqw',
        deviceType: Platform.isAndroid ? 'android' : 'ios',
      );

      final AuthResponse response = await _authRepository.signInApi(
        signInRequest: signInRequest,
      );

      setAuthResponse(response);
      setLoading(false);

      return response.isSuccess == true;
    });
  }

  @override
  void onError(String message) {
    super.onError(message);
    setAuthResponse(
      AuthResponse(
        isSuccess: false,
        message: 'An unexpected error occurred. Please try again.',
      ),
    );
    setLoading(false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

class AuthState {
  final bool loading;
  final bool loginWithEmail;
  final bool loginWithPhone;
  final AuthResponse? authResponse;

  AuthState({
    this.loading = false,
    this.authResponse,
    this.loginWithEmail = false,
    this.loginWithPhone = false,
  });

  AuthState copyWith({
    bool? loading,
    bool? loginWithEmail,
    bool? loginWithPhone,
    AuthResponse? authResponse,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      loginWithEmail: loginWithEmail ?? this.loginWithEmail,
      loginWithPhone: loginWithPhone ?? this.loginWithPhone,
      authResponse: authResponse ?? this.authResponse,
    );
  }
}
