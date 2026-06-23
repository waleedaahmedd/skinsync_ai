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
  socialLogin("social-login"),
  biometricRegister('v1/biometric/register'),
  biometricLogin('biometric/login'),
  biometricUnregister('biometric/unregister'),
  onBoardingQues("onboarding/masters"),
  saveAnswer("v1/onboarding/answer"),

  verifyOtp("verify-otp"),
  onBoardingProfile("v1/onboarding/profile"),
  getClinic("clinics/by-side-area?"),
  getDoctor("doctors/by-side-area?"),
  getMe("v1/me"),
  appVersion("admin/app-version/customer"),
  refreshToken('v1/auth/refresh'),
  getAvailability('v1/appointments/availability'),
  paymentOptions('v1/appointments/payment-options'),
  treatmentPricing('v1/treatments/pricing'),
  appointments('v1/appointments'),
  simulationHistory('v1/simulation-history');

  final String path;

  const EndPoints(this.path);
}

enum BaseUrls {
  api("https://api.skinsyncai.com/api/"),
  apiQa('https://api-qa.skinsyncai.com/api/');

  final String url;
  const BaseUrls(this.url);
}

enum ViewType { grid, map }
