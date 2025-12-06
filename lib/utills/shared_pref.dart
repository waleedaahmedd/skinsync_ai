import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPref? _instance;
  static SharedPreferences? _prefs;

  SharedPref._();

  factory SharedPref() {
    return _instance ??= SharedPref._();
  }

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isInitialized => _prefs != null;

  dynamic readObject(String key) {
    _checkInitialization();
    return json.decode(_prefs!.getString(key)!);
  }

  void saveObject(String key, value) {
    _checkInitialization();
    _prefs!.setString(key, json.encode(value));
  }

  String? readString(String key) {
    _checkInitialization();
    return _prefs!.getString(key);
  }

  void saveString(String key, value) {
    _checkInitialization();
    _prefs!.setString(key, value);
  }

  void removeFromSharedPref(String key) {
    _checkInitialization();
    _prefs!.remove(key);
  }

  void clearSharedPref() {
    _checkInitialization();
    _prefs!.clear();
  }

  void _checkInitialization() {
    if (_prefs == null) {
      throw Exception(
        'SharedPreferences not initialized. Call SharedPref.init() first.',
      );
    }
  }
}

