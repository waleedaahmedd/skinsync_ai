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
  signIn('login'),
  onBoardingQues("onboarding/masters"),
  saveAnswer("v1/onboarding/answer");

  final String path;

  const EndPoints(this.path);
}

enum BaseUrls {
  // api('https://api.brunos.kitchen/bruno/api/v1/');
  api("http://3.128.27.193/api/");

  final String url;

  const BaseUrls(this.url);
}

// class ApiEndpoints {
//   static String url(EndPoints endpoint, {BaseUrls base = BaseUrls.api}) {
//     return '${base.url}${endpoint.path}';
//   }
// }
