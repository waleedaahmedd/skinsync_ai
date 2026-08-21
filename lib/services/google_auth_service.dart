import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../app_init.dart';
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

  void _showErrorSnackBar(String message) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await GoogleSignIn.instance.signOut();
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      _showErrorSnackBar("Logout failed: ${e.toString()}");
    }
  }

  @override
  Future<User> signIn() async {
    try {
      if (!_initialized) {
        await GoogleSignIn.instance.initialize(
          serverClientId:
              '55541632083-rmv67oi9q88454a3v18sn1e9a3sfopgh.apps.googleusercontent.com',
        );
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
    } catch (e) {
      if (e is GoogleSignInException &&
          e.code == GoogleSignInExceptionCode.canceled) {
        rethrow;
      }
      _showErrorSnackBar(e.toString().replaceAll('Exception:', ''));
      rethrow;
    }
  }
}
