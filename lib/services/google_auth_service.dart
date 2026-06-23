import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../exceptions/app_exception.dart';

import 'base_auth_service.dart';

class GoogleAuthService extends BaseAuthService {
  final _auth = FirebaseAuth.instance;
  static GoogleAuthService? _instance;
  bool _initialized = false;

  GoogleAuthService._();

  factory GoogleAuthService() {
    _instance ??= GoogleAuthService._();
    return _instance ?? GoogleAuthService();
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await GoogleSignIn.instance.signOut();
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
    }
  }

  @override
  Future<User> signIn() async {
    if (!_initialized) {
      await GoogleSignIn.instance.initialize();
      _initialized = true;
    }
    final user = await GoogleSignIn.instance.authenticate();
    final GoogleSignInAuthentication googleAuth = user.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final credentials = await _auth.signInWithCredential(credential);
    final firebaseUser = credentials.user;
    log('EMAIL FROM GOOGLE: ${firebaseUser?.email}');
    if (firebaseUser == null) {
      throw const AppException('Could not login to Google');
    }
    return firebaseUser;
  }
}
