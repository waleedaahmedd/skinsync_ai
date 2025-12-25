import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;

  TextEditingController get passwordController => _passwordController;

  void setAuthResponse(AuthResponse response) {
    state = state.copyWith(authResponse: response);
  }

  Future<bool?> callSignInApi(BaseSignInRequest request) async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final AuthResponse response = await _authRepository.signInApi(
        signInRequest: request,
      );
      state = state.copyWith(loading: false);
      return response.isSuccess == true;
    });
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
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

@immutable
class AuthState extends BaseStateModel {
  final AuthResponse? authResponse;

  const AuthState({
    super.loading = false,
    super.errorMessage,
    this.authResponse,
  });

  AuthState copyWith({
    bool? loading,
    String? errorMessage,
    bool? loginWithEmail,
    bool? loginWithPhone,
    AuthResponse? authResponse,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      authResponse: authResponse ?? this.authResponse,
    );
  }
}
