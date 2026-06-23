import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../exceptions/app_exception.dart';

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
      await _auth.signOut(); // ✅ removed recursive call
    } catch (e, s) {
      print(e.toString());
      print(s);
    }
  }

  @override
  Future<User> signIn() async {
    if (!Platform.isIOS) {
      throw const AppException('Apple Sign In is only supported on iOS');
    }

    final rawNonce = generateNonce(); // ✅ now truly random
    final nonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // ✅ Check identity token before proceeding
    if (appleCredential.identityToken == null) {
      throw const AppException('Apple identity token is null');
    }

    final OAuthCredential credential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
      accessToken: appleCredential.authorizationCode,

    );

    final userCredential = await _auth.signInWithCredential(credential);
    final firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw const AppException('Could not login to Apple');
    }

    return firebaseUser;
  }

  // ✅ Secure nonce generation using Random.secure()
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
          (_) => charset[random.nextInt(charset.length)],
    ).join();
  }
}