import 'package:flutter/material.dart';

class AppColors {
  static const Color lightBlueColor = Color(0xff88E3FB);
  static const Color lightPurpleColor = Color(0xffE7C6E8);
  static const Color blackColor = Color(0xff000000);

  static const LinearGradient purpleBlueGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xff88E3FB), Color(0xffE7C6E8)],
  );

  static const LinearGradient blueWhitePurpleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xff88E3FB), Color(0xffFFFFFF), Color(0xffE7C6E8)],
  );
  static const LinearGradient purpleWhiteBlueGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xffE7C6E8), Color(0xffFFFFFF), Color(0xff88E3FB)],
  );
}
