import 'package:flutter/material.dart';
import 'models/responses/get_clinic_response.dart';
import 'models/responses/simulation_history_response.dart';
import 'screens/additional_info_screen.dart';
import 'screens/allergy_and_medical_history.dart';
import 'screens/biometric_screen.dart';
import 'screens/bottom_nav_page.dart';
import 'screens/bottom_nav_screens/face_scanning_complete_screen.dart';
import 'screens/clinic_service_screen.dart';
import 'screens/clinics_detail_screen.dart';
import 'screens/face_scan_screen.dart';
import 'screens/get_notified_screen.dart';
import 'screens/get_started_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/personal_detail_screen.dart';
import 'screens/progress_detail_screen.dart';
import 'screens/saved_treatment_screen.dart';
import 'screens/select_product_screen.dart';
import 'screens/setting_screen.dart';
import 'screens/signup_onboarding.dart';
import 'screens/splash_screen.dart';
import 'screens/suggested_treatmentsScreen.dart';
import 'screens/treatment_detail_screen.dart';
import 'screens/your_profile_screen.dart';
import 'utills/enums.dart';

import 'models/responses/treatment_response_model.dart';
import 'screens/ar_face_model_Preview_screen.dart';
import 'screens/bottom_nav_screens/face_detection_screen.dart';
import 'screens/bottom_nav_screens/my_profile_screen.dart';
import 'screens/bottom_nav_screens/treatments_screen.dart';
import 'screens/doctors_listing_screen.dart';
import 'screens/explore_clinics_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/simulation_history_screen.dart';
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
          settings: const RouteSettings(name: SplashScreen.routeName),
          builder: (_) => const SplashScreen(),
        );
      case HomeScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: HomeScreen.routeName),
          builder: (_) => const HomeScreen(),
        );
      case GetStartedScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: GetStartedScreen.routeName),
          builder: (_) => const GetStartedScreen(),
        );
      case LoginScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: LoginScreen.routeName),
          builder: (_) => LoginScreen(loginWith: args as LoginProviders),
        );
      case OtpScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: OtpScreen.routeName),
          builder: (_) => const OtpScreen(),
        );
      case SignupOnboarding.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: SignupOnboarding.routeName),
          builder: (_) => const SignupOnboarding(),
        );
      case YourProfileScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: YourProfileScreen.routeName),
          builder: (_) => const YourProfileScreen(),
        );
      case GetNotifiedScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: GetNotifiedScreen.routeName),
          builder: (_) => const GetNotifiedScreen(),
        );
      case BottomNavPage.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: BottomNavPage.routeName),
          builder: (_) => const BottomNavPage(),
        );
      case FaceDetectionScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: FaceDetectionScreen.routeName),
          builder: (_) => const FaceDetectionScreen(),
        );
      case FaceScanningCompleteScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: FaceScanningCompleteScreen.routeName),
          builder: (_) => const FaceScanningCompleteScreen(),
        );
      case FaceScanScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: FaceScanScreen.routeName),
          builder: (_) => const FaceScanScreen(),
        );
      case MyProfileScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: MyProfileScreen.routeName),
          builder: (_) => const MyProfileScreen(),
        );
      case ArFaceModelPreviewScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: ArFaceModelPreviewScreen.routeName),
          builder: (_) =>
              ArFaceModelPreviewScreen(simulationData: args as SimulationData?),
        );
      case SuggestedTreatmentScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: SuggestedTreatmentScreen.routeName),
          builder: (_) => const SuggestedTreatmentScreen(),
        );
      // case ServiceSelectionScreen.routeName:
      //   return MaterialPageRoute(
      //     settings: RouteSettings(name: ServiceSelectionScreen.routeName),
      //     builder: (_) => ServiceSelectionScreen(),
      //   );
      case ExploreClinicsScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: ExploreClinicsScreen.routeName),
          builder: (_) {
            final arguments = args as Map<String, dynamic>?;
            return ExploreClinicsScreen(
              sideAreaIds: arguments?['sideAreaIds'] ?? [],
              treatmentId: arguments?['treatmentId'] ?? 0,
            );
          },
        );
      case TreatmentDetailScreen.routeName:
        final treatments = settings.arguments as TreatmentsModel;
        return MaterialPageRoute(
          settings: const RouteSettings(name: TreatmentDetailScreen.routeName),
          builder: (_) => TreatmentDetailScreen(treatments: treatments),
        );
      // SelectSectionsScreen is now a bottom sheet, not a route
      // case SelectSectionsScreen.routeName:
      //   return MaterialPageRoute(
      //     settings: RouteSettings(name: SelectSectionsScreen.routeName),
      //     builder: (_) => SelectSectionsScreen(),
      //   );
      // SelectSubSectionsScreen is now a bottom sheet, not a route
      // case SelectSubSectionsScreen.routeName:
      //   return MaterialPageRoute(
      //     settings: RouteSettings(name: SelectSubSectionsScreen.routeName),
      //     builder: (_) => SelectSubSectionsScreen(),
      //   );
      case ClinicsDetailScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: ClinicsDetailScreen.routeName),
          builder: (_) => ClinicsDetailScreen(clinic: args as Clinic?),
        );
      case ClinicServiceScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: ClinicServiceScreen.routeName),
          builder: (_) => ClinicServiceScreen(clinic: args as Clinic?),
        );
      case SettingScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: SettingScreen.routeName),
          builder: (_) => const SettingScreen(),
        );
      case PersonalDetailScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: PersonalDetailScreen.routeName),
          builder: (_) => const PersonalDetailScreen(),
        );
      case SavedTreatmentScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: SavedTreatmentScreen.routeName),
          builder: (_) => const SavedTreatmentScreen(),
        );
      case AllergyAndMedicalHistory.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: AllergyAndMedicalHistory.routeName),
          builder: (_) => const AllergyAndMedicalHistory(),
        );
      case AdditionalInfoScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: AdditionalInfoScreen.routeName),
          builder: (_) => const AdditionalInfoScreen(),
        );
      case TreatmentsScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: TreatmentsScreen.routeName),
          builder: (_) => const TreatmentsScreen(),
        );
      case SelectProductScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: SelectProductScreen.routeName),
          builder: (_) => const SelectProductScreen(),
        );
      case PaymentScreen.routeName:
        final data = args as Map<String, dynamic>;
        return MaterialPageRoute(
          settings: const RouteSettings(name: PaymentScreen.routeName),
          builder: (_) => PaymentScreen(
            clinic: data['clinic'],
            doctor: data['doctor'],
            slot: data['slot'],
          ),
        );
      case NotesScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: NotesScreen.routeName),
          builder: (_) {
            final data = args as Map<String, dynamic>;
            return NotesScreen(
              slot: data['slot'],
              clinic: data['clinic'],
              doctor: data['doctor'],
              paymentOption: data['paymentOption'],
            );
          },
        );
      case NotificationScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: NotificationScreen.routeName),
          builder: (_) {
            return const NotificationScreen();
          },
        );
      case ProgressDetailScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: ProgressDetailScreen.routeName),
          builder: (_) => ProgressDetailScreen(),
        );
      case BiometricScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: BiometricScreen.routeName),
          builder: (_) => const BiometricScreen(),
        );
      case SimulationHistoryScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: SimulationHistoryScreen.routeName),
          builder: (_) => const SimulationHistoryScreen(),
        );
      case DoctorsListingScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: DoctorsListingScreen.routeName),
          builder: (_) => const DoctorsListingScreen(),
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
