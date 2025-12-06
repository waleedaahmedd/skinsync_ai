enum SharedPreferencesKeys {
  themeModeKey("theme-mode"),
  accessTokenKey("access-token");

  const SharedPreferencesKeys(this.keyText);

  final String keyText;
}

enum EndPoints {
  signIn('auth/login');

  final String url;

  const EndPoints(this.url);
}

enum BaseUrls {
  api('https://api.brunos.kitchen/bruno/api/v1/');

  final String url;

  const BaseUrls(this.url);
}


