import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricHelper {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Checks if device supports biometrics
  Future<bool> isBiometricAvailable() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  Future<IconData> getBiometricIcon() async {
    final types = await getAvailableBiometrics();
    final type = types.firstWhere((type) => type == BiometricType.face, orElse: () => BiometricType.fingerprint);

  switch (type) {
    case  BiometricType.face:
      return Icons.face;
    case BiometricType.fingerprint:
      return Icons.fingerprint;
    default:
      return Icons.lock;
  }
}

  /// Authenticate user
  Future<bool> authenticate({String reason = 'Authenticate'}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        
        biometricOnly: true,
      );
    } catch (_) {
      return false;
    }
  }
}
