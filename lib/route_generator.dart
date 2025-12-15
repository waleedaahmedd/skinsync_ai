
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/my_profile_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_page.dart';
import 'package:skinsync_ai/screens/get_notified_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/face_scanning_complete_screen.dart';
import 'package:skinsync_ai/screens/home_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/scan_your_face_screen.dart';
import 'package:skinsync_ai/screens/get_started_screen.dart';
import 'package:skinsync_ai/screens/login_screen.dart';
import 'package:skinsync_ai/screens/otp_screen.dart';
import 'package:skinsync_ai/screens/personal_detail_screen.dart';
import 'package:skinsync_ai/screens/saved_treatment_screen.dart';
import 'package:skinsync_ai/screens/setting_screen.dart';
import 'package:skinsync_ai/screens/your_profile_screen.dart';
import 'package:skinsync_ai/screens/signup_onboarding.dart';
import 'package:skinsync_ai/screens/splash_screen.dart';
import 'package:skinsync_ai/view_models/bottom_nav_view_model.dart';
import 'package:skinsync_ai/view_models/sign_up_onboarding_view_model.dart';

import 'screens/bottom_nav_screens/face_detection_screen.dart';

const String splashScreen = '/';
const String homeScreen = '/home_screen';
const String getStartedScreen = '/get_started_screen';
const String loginScreen = '/login_screen';
const String otpScreen = '/otp_screen';
const String signupOnboarding = '/signup_onboarding';
const String profileScreen  = "/profile_screen"; 
const String getNotifiedScreen = '/get_notified_screen';
const String bottomNavPage = '/bottom_nav_page';
const String scanYourFace = '/scan_youir_face';
const String faceDetection = '/face_detection';
const String faceScanningCompleteScreen = '/face_scanning_complete_screen';
const String myProfileScreen = "/my_profile_screen";
const String settingScreen = "/setting_screen";
const String personalDetailScreen = "/personal_detail_screen";
const String savedTreatmentScreen = "/saved_treatment_screen";

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    //  CP.yellow('Navigating to ${settings.name} with args: $args');
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
          builder: (_) => ChangeNotifierProvider(
            create: (context) => SignUpOnboardingViewModel(),
            builder: (context, _) {
              return SignupOnboarding();
            },
          ),
        );
         case profileScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name:profileScreen),
          builder: (_) => YourProfileScreen(),
        ); 
         case getNotifiedScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name:getNotifiedScreen),
          builder: (_) => GetNotifiedScreen(),
        ); 
          case bottomNavPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: bottomNavPage),

          builder: (_) => ChangeNotifierProvider(
            create: (context) => BottomNavViewModel(),
            builder: (context, _) {
              return BottomNavPage();
            },
          ),
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
