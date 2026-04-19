import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'enums.dart';

class SecureStorage {
  static SecureStorage? _instance;
  static FlutterSecureStorage? _storage;

  String? _cachedToken; // <--- in-memory cache

  static const String _accessTokenKey = 'auth-token';
  static const String _refreshTokenKey = 'refresh-token';
  static const String _accessTokenExpiryKey = 'access-token-expiry';
  static const String _refreshTokenExpiryKey = 'refresh-token-expiry';
  static const String _medicalDisclaimerKey = 'medical-disclaimer';
  static const String _userEmailKey = 'user-data';

  SecureStorage._();

  factory SecureStorage() {
    return _instance ??= SecureStorage._();
  }

  /// Load token once at app startup
  Future<void> init() async {
    _storage = FlutterSecureStorage(
      aOptions: AndroidOptions(),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
    _cachedToken = await _storage!.read(key: _accessTokenKey);
  }

  /// Get token from cache (fast, no decryption)
  String? get cachedAuthToken => _cachedToken;

  /// Save token to storage + update cache
  Future<void> saveSecureString({
    required String key,
    required String value,
  }) async {
    await _storage!.write(key: key, value: value);
    if (key == _accessTokenKey) {
      _cachedToken = value;
    }
  }

  Future<String?> getSecureString({required String key}) async {
    return await _storage!.read(key: key);
  }

  /// Remove token from storage + cache
  Future<void> deleteSecureString({required String key}) async {
    await _storage!.delete(key: key);
    if (key == _accessTokenKey) {
      _cachedToken = null;
    }
  }

  Future<void> clearAllSecureStrings() async {
    final value = await getSecureString(
      key: SharedPreferencesKeys.biometricAuthKey.keyText,
    );
    final email = await getUserEmail();
    log('BIOMETRIC KEY: $value $email');
    await _storage!.deleteAll();
    await _storage!.write(
      key: SharedPreferencesKeys.biometricAuthKey.keyText,
      value: value,
    );
    await saveUserEmail(email);
    _cachedToken = null;
  }

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _storage?.write(key: _accessTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _cachedToken ?? await _storage?.read(key: _accessTokenKey);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage?.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage?.read(key: _refreshTokenKey);
  }

  Future<void> saveAccessTokenExpiry(DateTime expiryDate) async {
    await _storage?.write(
      key: _accessTokenExpiryKey,
      value: expiryDate.subtract(Duration(minutes: 1)).toIso8601String(),
    );
  }

  Future<DateTime?> getAccessTokenExpiry() async {
    final expiryDate = await _storage?.read(key: _accessTokenExpiryKey);
    if (expiryDate == null) {
      return null;
    }
    return DateTime.tryParse(expiryDate);
  }

  Future<void> saveRefreshTokenExpiry(DateTime date) async {
    await _storage?.write(
      key: _refreshTokenExpiryKey,
      value: date.subtract(Duration(minutes: 1)).toIso8601String(),
    );
  }

  Future<DateTime?> getRefreshTokenExpiry() async {
    final expiryDate = await _storage?.read(key: _refreshTokenExpiryKey);
    if (expiryDate == null) {
      return null;
    }
    return DateTime.tryParse(expiryDate);
  }

  Future<void> saveMedicalDisclaimer() async {
    await _storage?.write(key: _medicalDisclaimerKey, value: 'true');
  }

  Future<bool> getMedicalDisclaimer() async {
    final disclaimer = await _storage?.read(key: _medicalDisclaimerKey);
    return disclaimer == null;
  }

  Future<void> saveUserEmail(String? email) async {
    await _storage?.write(key: _userEmailKey, value: email);
  }

  Future<String?> getUserEmail() async {
    return await _storage?.read(key: _userEmailKey);
  }
}
