import 'dart:async';
import 'dart:convert';

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
  Future<AuthResponse> signInApi({
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
        _secureStorage.saveSecureString(
          key: '',
          value: authResponse.data?.clientToken ?? '',
        );
      }
      return authResponse;
    } else {
      // Handle HTTP error status codes
      final parsed = json.decode(response.body);
      throw AppException(AuthResponse.fromJson(parsed).message as String);
    }
  }
}
