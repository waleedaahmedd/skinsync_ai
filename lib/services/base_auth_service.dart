import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthService {
  Future<User> signIn();

  Future<void> logout();
}
