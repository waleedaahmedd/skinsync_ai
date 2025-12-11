import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../models/requests/sign_in_request.dart';
import '../models/responses/auth_response.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;
  bool _isLoading = false;
  bool _loginWithEmail = false;
   bool _loginWithPhone = false;

  final AuthRepository _authRepository;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  AuthResponse _authResponse = AuthResponse();

  TextEditingController get emailController => _emailController;
   TextEditingController get phoneController => _phoneController;

  TextEditingController get passwordController => _passwordController;

  AuthResponse get authResponse => _authResponse;
  bool get loginWithEmail => _loginWithEmail;
  bool get loginWithPhone => _loginWithEmail;

  void setAuthResponse(AuthResponse response) {
    _authResponse = response;
    notifyListeners();
  }


  bool get isLoading => _isLoading;
  void setloginWithEmail(bool value) {
    _loginWithEmail = value;
    _loginWithPhone = !value;
    notifyListeners();
  }
  void setloginWithPhone(bool value) {
    _loginWithPhone = value;
    _loginWithEmail = !value;
    notifyListeners();
  }
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> callSignInApi() async {
    setLoading(true);
    try {
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
    } catch (e) {
      // Set error response
      setAuthResponse(
        AuthResponse(
          isSuccess: false,
          message: 'An unexpected error occurred. Please try again.',
        ),
      );
      setLoading(false);
      return false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
