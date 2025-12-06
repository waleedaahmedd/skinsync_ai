
import '../models/requests/sign_in_request.dart';
import '../models/responses/auth_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> signInApi({required SignInRequest signInRequest});
}