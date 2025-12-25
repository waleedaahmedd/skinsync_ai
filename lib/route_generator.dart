import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skinsync_ai/screens/additional_info_screen.dart';
import 'package:skinsync_ai/screens/allergy_and_medical_history.dart';
import 'package:skinsync_ai/screens/bottom_nav_page.dart';
import 'package:skinsync_ai/screens/clinic_service_screen.dart';
import 'package:skinsync_ai/screens/clinics_detail_screen.dart';
import 'package:skinsync_ai/screens/face_scan_screen.dart';
import 'package:skinsync_ai/screens/get_notified_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/face_scanning_complete_screen.dart';
import 'package:skinsync_ai/screens/home_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/scan_your_face_screen.dart';
import 'package:skinsync_ai/screens/get_started_screen.dart';
import 'package:skinsync_ai/screens/login_screen.dart';
import 'package:skinsync_ai/screens/notes_screen.dart';
import 'package:skinsync_ai/screens/notification_screen.dart';
import 'package:skinsync_ai/screens/otp_screen.dart';
import 'package:skinsync_ai/screens/payment_screen.dart';
import 'package:skinsync_ai/screens/personal_detail_screen.dart';
import 'package:skinsync_ai/screens/saved_treatment_screen.dart';
import 'package:skinsync_ai/screens/setting_screen.dart';
import 'package:skinsync_ai/screens/treatment_detail_screen.dart';
import 'package:skinsync_ai/screens/treatment_receipts_screen.dart';
import 'package:skinsync_ai/screens/your_profile_screen.dart';
import 'package:skinsync_ai/screens/signup_onboarding.dart';
import 'package:skinsync_ai/screens/splash_screen.dart';
import 'package:skinsync_ai/view_models/bottom_nav_view_model.dart';
import 'package:skinsync_ai/view_models/sign_up_onboarding_view_model.dart';

import 'screens/ar_face_model_Preview_screen.dart';
import 'screens/bottom_nav_screens/face_detection_screen.dart';
import 'screens/bottom_nav_screens/my_profile_screen.dart';
import 'screens/explore_clinics_screen.dart';
import 'screens/service_selection_screen.dart';
import 'utills/colored_print.dart';

// const String getStartedScreen = '/get_started_screen';
// const String loginScreen = '/login_screen';
// const String otpScreen = '/otp_screen';
// const String signupOnboarding = '/signup_onboarding';
// const String profileScreen = "/profile_screen";
// const String getNotifiedScreen = '/get_notified_screen';
// const String bottomNavPage = '/bottom_nav_page';
// const String scanYourFace = '/scan_youir_face';
// const String faceDetection = '/face_detection';
// const String faceScanningCompleteScreen = '/face_scanning_complete_screen';
// const String myProfileScreen = "/my_profile_screen";
// const String settingScreen = "/setting_screen";
// const String personalDetailScreen = "/personal_detail_screen";
// const String savedTreatmentScreen = "/saved_treatment_screen";
// const String faceScanScreen = '/face_scan_screen';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    CP.yellow('Navigating to ${settings.name} with args: $args');
    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: SplashScreen.routeName),
          builder: (_) => SplashScreen(),
        );
      case HomeScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: HomeScreen.routeName),
          builder: (_) => HomeScreen(),
        );
      case GetStartedScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: GetStartedScreen.routeName),
          builder: (_) => GetStartedScreen(),
        );
      case LoginScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: LoginScreen.routeName),
          builder: (_) => LoginScreen(),
        );
      case OtpScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: OtpScreen.routeName),
          builder: (_) => OtpScreen(),
        );
      case SignupOnboarding.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: SignupOnboarding.routeName),
          builder: (_) => ChangeNotifierProvider(
            create: (context) => SignUpOnboardingViewModel(),
            builder: (context, _) {
              return SignupOnboarding();
            },
          ),
        );
      case YourProfileScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: YourProfileScreen.routeName),
          builder: (_) => YourProfileScreen(),
        );
      case GetNotifiedScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: GetNotifiedScreen.routeName),
          builder: (_) => GetNotifiedScreen(),
        );
      case BottomNavPage.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: BottomNavPage.routeName),

          builder: (_) => ChangeNotifierProvider(
            create: (context) => BottomNavViewModel(),
            builder: (context, _) {
              return BottomNavPage();
            },
          ),
        );
      case ScanYourFaceScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: ScanYourFaceScreen.routeName),
          builder: (_) => ScanYourFaceScreen(),
        );
      case FaceDetectionScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: FaceDetectionScreen.routeName),
          builder: (_) => FaceDetectionScreen(),
        );
      case FaceScanningCompleteScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: FaceScanningCompleteScreen.routeName),
          builder: (_) => FaceScanningCompleteScreen(),
        );
      case FaceScanScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: FaceScanScreen.routeName),
          builder: (_) => FaceScanScreen(),
        );
      case MyProfileScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: MyProfileScreen.routeName),
          builder: (_) => MyProfileScreen(),
        );
      case ArFaceModelPreviewScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: ArFaceModelPreviewScreen.routeName),
          builder: (_) => ArFaceModelPreviewScreen(),
        );
      case ServiceSelectionScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: ServiceSelectionScreen.routeName),
          builder: (_) => ServiceSelectionScreen(),
        );
      case ExploreClinicsScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: ExploreClinicsScreen.routeName),
          builder: (_) => ExploreClinicsScreen(),
        );
        case TreatmentDetailScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: TreatmentDetailScreen.routeName),
          builder: (_) => TreatmentDetailScreen(),
        );
        case ClinicsDetailScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: ClinicsDetailScreen.routeName),
          builder: (_) => ClinicsDetailScreen(),
        );
         case ClinicServiceScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: ClinicServiceScreen.routeName),
          builder: (_) => ClinicServiceScreen(),
        );
        case SettingScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name:SettingScreen.routeName),
          builder: (_) => SettingScreen(),
        );
        case PersonalDetailScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: PersonalDetailScreen.routeName),
          builder: (_) => PersonalDetailScreen(),
        );
        case SavedTreatmentScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: SavedTreatmentScreen.routeName),
          builder: (_) => SavedTreatmentScreen(),
        );
         case AllergyAndMedicalHistory.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: AllergyAndMedicalHistory.routeName),
          builder: (_) => AllergyAndMedicalHistory(),
        );
         case AdditionalInfoScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: AdditionalInfoScreen.routeName),
          builder: (_) => AdditionalInfoScreen(),
        );
        case PaymentScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: PaymentScreen.routeName),
          builder: (_) => PaymentScreen(),
        );
         case NotesScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: NotesScreen.routeName),
          builder: (_) => NotesScreen(),
        );
         case NotificationScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: NotificationScreen.routeName),
          builder: (_) => NotificationScreen(),
        );
         case TreatmentReceiptsScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: TreatmentReceiptsScreen.routeName),
          builder: (_) => TreatmentReceiptsScreen(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    CP.red('Error: Route not found');
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
