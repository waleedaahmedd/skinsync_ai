import 'dart:async';

class AuthService {
  // Simulate API delay
  static const Duration _apiDelay = Duration(seconds: 2);

  /// Sends OTP to the provided phone number
  /// In a real app, this would make an API call to your backend
  Future<void> sendOtpPhone(String phoneNumber) async {
    await Future.delayed(_apiDelay);
    if (phoneNumber.isEmpty) {
      throw Exception('Phone number cannot be empty');
    }
  }

  Future<void> sendOtpEmail(String email) async {
    await Future.delayed(_apiDelay);
    if (email.isEmpty) {
      throw Exception('Phone number cannot be empty');
    }
  }

  /// Verifies the OTP for the given phone number
  /// In a real app, this would make an API call to your backend
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    await Future.delayed(_apiDelay);
    
    // Simulate potential errors
    if (phoneNumber.isEmpty || otp.isEmpty) {
      throw Exception('Phone number and OTP cannot be empty');
    }
    
    // In a real app, you would:
    // 1. Make an API call to your backend
    // 2. Backend would verify the OTP against the stored value
    // 3. Return verification result
    
    // For demo purposes, accept any 6-digit OTP
    if (otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp)) {
      // OTP verified successfully
      return true;
    }
    
    return false;
  }

  /// Resends OTP to the provided phone number
  Future<void> resendOtp(String phoneNumber) async {
    await sendOtpPhone(phoneNumber);
  }
}
