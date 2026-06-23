import '../../utills/enums.dart';

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
  final String userName;

  const SignInWithGoogleRequest({
    required this.email,
    required this.googleUid,
    required this.userName,
    required super.provider,
    required super.deviceInfo,
    required super.ipAddress,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'google_uid': googleUid,
      'user_name': userName,
      'provider': provider.name,
      'device_info': deviceInfo,
      'ip_address': ipAddress,
    };
  }
}

class SignInWithAppleRequest extends BaseSignInRequest {
  final String email;
  final String appleUid;
  final String userName;

  const SignInWithAppleRequest({
    required this.email,
    required this.appleUid,
    required this.userName,
    required super.provider,
    required super.deviceInfo,
    required super.ipAddress,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'apple_uid': appleUid,
      'user_name': userName,
      'provider': provider.name,
      'device_info': deviceInfo,
      'ip_address': ipAddress,
    };
  }
}

class SocialLoginRequest {
  final String deviceType;
  final String idToken;
  final String fcmToken;

  const SocialLoginRequest({
    required this.deviceType,
    required this.idToken,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'device_type': deviceType,
      'id_token': idToken,
      'fcm_token': fcmToken,
    };
  }
}
