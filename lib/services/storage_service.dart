import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  SharedPreferences? _prefs;
  static StorageService? _instance;

  static const String _themeModeKey = 'theme-mode';
  static const String _accessTokenKey = 'access-token';

  StorageService._();

  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isInitialized => _prefs != null;

  ThemeMode getThemeMode() {
    if (_prefs == null) {
      return ThemeMode.system;
    }
    final int? index = _prefs!.getInt(_themeModeKey);
    if (index == null) {
      return ThemeMode.system;
    }
    return ThemeMode.values[index];
  }

  Future<void> saveThemeMode(ThemeMode? mode) async {
    if (mode == null || _prefs == null) {
      return;
    }
    await _prefs!.setInt(_themeModeKey, mode.index);
  }

  Future<void> saveAccessToken(String? token) async {
    if (token != null && _prefs != null) {
      await _prefs!.setString(_accessTokenKey, token);
    }
  }

  String? getAccessToken() {
    if (_prefs == null) {
      return null;
    }
    return _prefs!.getString(_accessTokenKey);
  }
}
