import 'package:flutter/cupertino.dart';
import 'package:skinsync_ai/utills/enums.dart';

abstract class BaseSignInRequest {
  final LoginProviders provider;
  final String deviceInfo;
  final String ipAddress;

  const BaseSignInRequest({
    required this.provider,
    required this.deviceInfo,
    required this.ipAddress,
  });

  Map<String, dynamic> toJson();
}

class SignInWithPhoneRequest extends BaseSignInRequest {
  final String phone;

  const SignInWithPhoneRequest({
    required this.phone,
    required super.provider,
    required super.deviceInfo,
    required super.ipAddress,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'provider': provider.name,
      'device_info': deviceInfo,
      'ip_address': ipAddress,
    };
  }
}

class SignInWithEmailRequest extends BaseSignInRequest {
  final String email;

  const SignInWithEmailRequest({
    required this.email,
    required super.provider,
    required super.deviceInfo,
    required super.ipAddress,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'provider': provider.name,
      'device_info': deviceInfo,
      'ip_address': ipAddress,
    };
  }
}

class SignInWithGoogleRequest extends BaseSignInRequest {
  final String email;
  final String googleUid;

  const SignInWithGoogleRequest({
    required this.email,
    required this.googleUid,
    required super.provider,
    required super.deviceInfo,
    required super.ipAddress,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'google_uid': googleUid,
      'provider': provider.name,
      'device_info': deviceInfo,
      'ip_address': ipAddress,
    };
  }
}

class SignInWithAppleRequest extends BaseSignInRequest {
  final String email;
  final String appleUid;

  const SignInWithAppleRequest({
    required this.email,
    required this.appleUid,
    required super.provider,
    required super.deviceInfo,
    required super.ipAddress,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'apple_uid': appleUid,
      'provider': provider.name,
      'device_info': deviceInfo,
      'ip_address': ipAddress,
    };
  }
}
