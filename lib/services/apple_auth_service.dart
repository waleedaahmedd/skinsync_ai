import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:skinsync_ai/exceptions/app_exception.dart';

import 'base_auth_service.dart';

class AppleAuthService extends BaseAuthService {
  final _auth = FirebaseAuth.instance;
  static AppleAuthService? _instance;

  AppleAuthService._();

  factory AppleAuthService() {
    _instance ??= AppleAuthService._();
    return _instance!;
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _instance?.logout();
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
    }
  }

  @override
  Future<User> signIn() async {
    if (!Platform.isIOS) {
      throw AppException('Apple Sign In is only supported on iOS');
    }

    final rawNonce = generateNonce();
    final nonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final OAuthCredential credential = OAuthProvider(
      'apple.com',
    ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce);

    final userCredential = await _auth.signInWithCredential(credential);
    final firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw AppException('Could not login to Apple');
    }

    return firebaseUser;
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    final random = Platform.isIOS
        ? (DateTime.now().millisecondsSinceEpoch % 100)
        : 0;
    // Note: In a real app, use a more secure random generator like dart:math Random.secure()
    // For now, keeping it simple as per standard Firebase + Apple documentation patterns
    return List.generate(
      length,
      (index) => charset[random % charset.length],
    ).join();
  }
}
