enum SharedPreferencesKeys {
  themeModeKey("theme-mode"),
  biometricAuthKey("biometric-auth"),
  accessTokenKey("access-token");

  const SharedPreferencesKeys(this.keyText);

  final String keyText;
}

enum LoginProviders {
  phone('phone'),
  email('email'),
  google('google'),
  apple('apple');

  final String name;

  const LoginProviders(this.name);
}

enum EndPoints {
  getTreatments('treatments/masters'),
  treatments("treatments"),

  signIn('login'),
  onBoardingQues("onboarding/masters"),
  saveAnswer("v1/onboarding/answer"),

  verifyOtp("verify-otp"),
  onBoardingProfile("v1/onboarding/profile"),
  getClinic("clinics/by-side-area?"),
  getDoctor("doctors/by-side-area?"),
  getMe("v1/me"),
  refreshToken('v1/auth/refresh'),
  getAvailability('v1/appointments/availability'),
  paymentOptions('v1/appointments/payment-options'),
  treatmentPricing('v1/treatments/pricing');

  final String path;

  const EndPoints(this.path);
}

enum BaseUrls {
  api("https://api.skinsyncai.com/api/");

  final String url;

  const BaseUrls(this.url);
}

enum ViewType { grid, map }
