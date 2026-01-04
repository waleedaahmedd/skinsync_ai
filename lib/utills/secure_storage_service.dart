import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static SecureStorage? _instance;
  static FlutterSecureStorage? _storage;

  String? _cachedToken; // <--- in-memory cache

  SecureStorage._();

  factory SecureStorage() {
    return _instance ??= SecureStorage._();
  }

  /// Load token once at app startup
  Future<void> init() async {
    _storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
  }

  /// Get token from cache (fast, no decryption)
  String? get cachedAuthToken => _cachedToken;

  /// Save token to storage + update cache
  Future<void> saveSecureString({
    required String key,
    required String value,
  }) async {
    await _storage!.write(key: key, value: value);
    _cachedToken = value;
  }

  /// Remove token from storage + cache
  Future<void> deleteSecureString({required String value}) async {
    await _storage!.delete(key: value);
    _cachedToken = null;
  }
  

  Future<void> clearAllSecureStrings() async {
    await _storage!.deleteAll();
    _cachedToken = null;
  }
}
