class SignInRequest {
  String email;
  String password;
  String deviceToken;
  String deviceType;
  String role = 'user';

  SignInRequest(
      {required this.email,
        required this.password,
        required this.deviceToken,
        required this.deviceType,
        /*this.role*/});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['deviceToken'] = deviceToken;
    data['deviceType'] = deviceType;
    data['role'] = role;
    return data;
  }
}


