class OtpRequest {
  final String email;
  final String otp;
  final String fcmToken;

  OtpRequest({
    required this.email,
    required this.otp,
    required this.fcmToken
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'fcm_token': fcmToken
    };
  }
}