class CP {
  // ANSI escape codes
  static const String reset = '\x1B[0m';
  static const String r = '🔴 ERROR:';
  static const String g = '🟢 SUCCESS:';
  static const String y = '🟡 WARNING:';
  static const String b = '\x1B[34m';
  static const String m = '\x1B[35m';
  static const String c = '\x1B[36m';
  static const String w = '\x1B[37m';

  static void red(String message) {
    print('$r$message');
  }

  static void green(String message) {
    print('$g$message');
  }

  static void yellow(String message) {
    print('$y$message');
  }

  static void blue(String message) {
    print('$b$message$reset');
  }

  static void magenta(String message) {
    print('$m$message$reset');
  }

  static void cyan(String message) {
    print('$c$message$reset');
  }

  static void white(String message) {
    print('$w$message$reset');
  }

}
