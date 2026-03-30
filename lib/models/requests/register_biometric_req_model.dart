class RegisterBiometricReqModel {
  final String deviceId;
  final String deviceHash;

  RegisterBiometricReqModel({required this.deviceId, required this.deviceHash});

  Map<String, dynamic> toJson() {
    return {'device_id': deviceId, 'biometric_key': deviceHash};
  }
}
