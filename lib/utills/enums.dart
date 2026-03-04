enum SharedPreferencesKeys {
  themeModeKey("theme-mode"),
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
  getMe("v1/me"),;

  final String path;

  const EndPoints(this.path);
}

enum BaseUrls {
  api("https://api.skinsyncai.com/api/");

  final String url;

  const BaseUrls(this.url);
}

// class ApiEndpoints {
//   static String url(EndPoints endpoint, {BaseUrls base = BaseUrls.api}) {
//     return '${base.url}${endpoint.path}';
//   }
// }
