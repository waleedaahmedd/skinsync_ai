
import 'package:flutter/material.dart';
import 'package:skinsync_ai/screens/home_screen.dart';
import 'package:skinsync_ai/screens/get_started_screen.dart';
import 'package:skinsync_ai/screens/login_screen.dart';
import 'package:skinsync_ai/screens/otp_screen.dart';
import 'package:skinsync_ai/screens/signup_onboarding.dart';
import 'package:skinsync_ai/screens/splash_screen.dart';

const String splashScreen = '/';
const String homeScreen = '/home_screen';
const String getStartedScreen = '/get_started_screen';
const String loginScreen = '/login_screen';
const String otpScreen = '/otp_screen';
const String signupOnboarding = '/signup_onboarding';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: splashScreen),
          builder: (_) => SplashScreen(),
        );
      case homeScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: homeScreen),
          builder: (_) => HomeScreen(),
        );
      case getStartedScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: getStartedScreen),
          builder: (_) => GetStartedScreen());
          case loginScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: loginScreen),
          builder: (_) => LoginScreen(),
        );  
         case otpScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: otpScreen),
          builder: (_) => OtpScreen(),
        ); 
          case signupOnboarding:
        return MaterialPageRoute(
          settings: RouteSettings(name: signupOnboarding),
          builder: (_) => SignupOnboarding(),
        ); 
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('ERROR')),
        );
      },
    );
  }
}
