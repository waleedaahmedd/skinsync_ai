import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'enums.dart';
import 'secure_storage_service.dart';

import '../models/requests/register_biometric_req_model.dart';

class BiometricHelper {
  final LocalAuthentication _auth = LocalAuthentication();

  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Generates a unique device signature (hashed)
  static Future<RegisterBiometricReqModel> getDeviceSignature() async {
    String rawData = '';
    String deviceId = '';

    try {
      if (Platform.isAndroid) {
        final android = await _deviceInfo.androidInfo;

        deviceId = android.id; // semi-unique ID

        rawData =
            '${android.id}_${android.model}_${android.brand}_${android.device}_${android.version.sdkInt}';
      } else if (Platform.isIOS) {
        final ios = await _deviceInfo.iosInfo;

        deviceId = ios.identifierForVendor ?? '';

        rawData =
            '${ios.identifierForVendor}_${ios.model}_${ios.systemVersion}';
      } else {
        rawData = 'unknown_device';
        deviceId = 'unknown';
      }

      // Hash it for fingerprint
      final bytes = utf8.encode(rawData);
      final hash = sha256.convert(bytes).toString();

      final req = RegisterBiometricReqModel(
        deviceId: deviceId,
        deviceHash: hash,
      );

      await SecureStorage().saveSecureString(
        key: SharedPreferencesKeys.biometricAuthKey.keyText,
        value: hash,
      );

      return req;
    } catch (e) {
      return RegisterBiometricReqModel(
        deviceId: "unknown",
        deviceHash: "unknown_signature",
      );
    }
  }

  static Future<bool> clearSignature() async {
    await SecureStorage().deleteSecureString(
      key: SharedPreferencesKeys.biometricAuthKey.keyText,
    );
    await SecureStorage().saveUserEmail(null);
    return true;
  }

  /// Checks if device supports biometrics
  Future<bool> isBiometricAvailable() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
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
    final type = types.firstWhere(
      (type) => type == BiometricType.face,
      orElse: () => BiometricType.fingerprint,
    );

    switch (type) {
      case BiometricType.face:
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
    } catch (e) {
      return false;
    }
  }
}
