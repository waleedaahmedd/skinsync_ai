import 'package:flutter/material.dart';
import 'package:skinsync_ai/models/responses/get_clinic_response.dart';
import 'package:skinsync_ai/models/responses/simulation_history_response.dart';
import 'package:skinsync_ai/models/responses/treatment_category_list_response.dart';
import 'package:skinsync_ai/models/responses/treatment_area_list_response.dart';
import 'package:skinsync_ai/models/dummy_list_model.dart';
import 'package:skinsync_ai/screens/additional_info_screen.dart';
import 'package:skinsync_ai/screens/allergy_and_medical_history.dart';
import 'package:skinsync_ai/screens/biometric_screen.dart';
import 'package:skinsync_ai/screens/bottom_nav_page.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/face_scanning_complete_screen.dart';
import 'package:skinsync_ai/screens/clinic_service_screen.dart';
import 'package:skinsync_ai/screens/select_appointment_type_screen.dart';
import 'package:skinsync_ai/screens/doctors_screen.dart';
import 'package:skinsync_ai/screens/doctor_detail_screen.dart';
import 'package:skinsync_ai/screens/select_date_time_screen.dart';
import 'package:skinsync_ai/screens/review_screen.dart';
import 'package:skinsync_ai/screens/payment_screen.dart';
import 'package:skinsync_ai/screens/treatment_payment_screen.dart';
import 'package:skinsync_ai/screens/clinics_detail_screen.dart';
import 'package:skinsync_ai/screens/face_scan_screen.dart';
import 'package:skinsync_ai/screens/get_notified_screen.dart';
import 'package:skinsync_ai/screens/get_started_screen.dart';
import 'package:skinsync_ai/screens/home_screen.dart';
import 'package:skinsync_ai/screens/login_screen.dart';
import 'package:skinsync_ai/screens/notes_screen.dart';
import 'package:skinsync_ai/screens/otp_screen.dart';
import 'package:skinsync_ai/screens/personal_detail_screen.dart';
import 'package:skinsync_ai/screens/progress_detail_screen.dart';
import 'package:skinsync_ai/screens/saved_treatment_screen.dart';
import 'package:skinsync_ai/screens/select_product_screen.dart';
import 'package:skinsync_ai/screens/setting_screen.dart';
import 'package:skinsync_ai/screens/signup_onboarding.dart';
import 'package:skinsync_ai/screens/splash_screen.dart';
import 'package:skinsync_ai/screens/suggested_treatmentsScreen.dart';
import 'package:skinsync_ai/screens/treatment_detail_screen.dart';
import 'package:skinsync_ai/screens/your_profile_screen.dart';
import 'package:skinsync_ai/utills/enums.dart';

import 'models/responses/treatment_list_response.dart';
import 'screens/ar_face_model_Preview_screen.dart';
import 'screens/bottom_nav_screens/face_detection_screen.dart';
import 'screens/bottom_nav_screens/my_profile_screen.dart';
import 'screens/bottom_nav_screens/treatments_screen.dart';
import 'screens/treatment_explore_screen.dart';
import 'screens/treatment_category_screen.dart';
import 'screens/treatment_area_screen.dart';
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
          builder: (_) => LoginScreen(loginWith: args as LoginProviders),
        );
      case OtpScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: OtpScreen.routeName),
          builder: (_) => OtpScreen(),
        );
      case SignupOnboarding.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: SignupOnboarding.routeName),
          builder: (_) => SignupOnboarding(),
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
          builder: (_) => BottomNavPage(),
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
          builder: (_) => const ArFaceModelPreviewScreen(),
        );
      case SuggestedTreatmentScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: SuggestedTreatmentScreen.routeName),
          builder: (_) => SuggestedTreatmentScreen(),
        );
      // case ServiceSelectionScreen.routeName:
      //   return MaterialPageRoute(
      //     settings: RouteSettings(name: ServiceSelectionScreen.routeName),
      //     builder: (_) => ServiceSelectionScreen(),
      //   );
      case ExploreClinicsScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: ExploreClinicsScreen.routeName),
          builder: (_) {
            final arguments = args as Map<String, dynamic>?;
            return ExploreClinicsScreen(
              sideAreaIds: arguments?['sideAreaIds'] ?? [],
              treatmentId: arguments?['treatmentId'] ?? 0,
            );
          },
        );
      case TreatmentDetailScreen.routeName:
        final treatments = settings.arguments as TreatmentData;
        return MaterialPageRoute(
          settings: RouteSettings(name: TreatmentDetailScreen.routeName),
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
          settings: RouteSettings(name: ClinicsDetailScreen.routeName),
          builder: (_) => ClinicsDetailScreen(clinic: args as Clinic?),
        );
      case SelectAppointmentTypeScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: SelectAppointmentTypeScreen.routeName),
          builder: (_) => SelectAppointmentTypeScreen(clinic: args as Clinic),
        );
      case DoctorsScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: DoctorsScreen.routeName),
          builder: (_) => DoctorsScreen(clinic: args as Clinic),
        );
      case DoctorDetailScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: DoctorDetailScreen.routeName),
          builder: (_) => DoctorDetailScreen(doctor: args as DummyDoctor),
        );
      case SelectDateTimeScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: SelectDateTimeScreen.routeName),
          builder: (_) => const SelectDateTimeScreen(),
        );
      case ReviewScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: ReviewScreen.routeName),
          builder: (_) => const ReviewScreen(),
        );
      case PaymentScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: PaymentScreen.routeName),
          builder: (_) => const PaymentScreen(),
        );
      case ClinicServiceScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: ClinicServiceScreen.routeName),
          builder: (_) => ClinicServiceScreen(clinic: args as Clinic?),
        );
      case SettingScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: SettingScreen.routeName),
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
      case TreatmentsScreen.routeName:
        int? categoryId;
        int? areaId;
        if (args is Map<String, dynamic>) {
          categoryId = args['categoryId'] as int?;
          areaId = args['areaId'] as int?;
        }
        return MaterialPageRoute(
          settings: RouteSettings(name: TreatmentsScreen.routeName),
          builder: (_) => TreatmentsScreen(),
        );
      case TreatmentExploreScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: TreatmentExploreScreen.routeName),
          builder: (_) => TreatmentExploreScreen(),
        );
      case TreatmentCategoryScreen.routeName:
        final argsMap = args as Map<String, dynamic>? ?? {};
        final list = argsMap['categories'] as List<TreatmentCategoryModel>?;
        final screenTitle = argsMap['title'] as String? ?? "By Category";
        final path = argsMap['selectionPath'] as String? ?? "Categories";
        return MaterialPageRoute(
          settings: RouteSettings(name: TreatmentCategoryScreen.routeName),
          builder: (_) => TreatmentCategoryScreen(
            categories: list,
            title: screenTitle,
            selectionPath: path,
          ),
        );
      case TreatmentAreaScreen.routeName:
        final argsMap = args as Map<String, dynamic>? ?? {};
        final list = argsMap['areas'] as List<TreatmentAreaModel>?;
        final screenTitle = argsMap['title'] as String? ?? "Focus Areas";
        final path = argsMap['selectionPath'] as String? ?? "Focus Areas";
        return MaterialPageRoute(
          settings: RouteSettings(name: TreatmentAreaScreen.routeName),
          builder: (_) => TreatmentAreaScreen(
            areas: list,
            title: screenTitle,
            selectionPath: path,
          ),
        );
      case SelectProductScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: SelectProductScreen.routeName),
          builder: (_) => SelectProductScreen(),
        );
      case TreatmentPaymentScreen.routeName:
        final data = args as Map<String, dynamic>;
        return MaterialPageRoute(
          settings: RouteSettings(name: TreatmentPaymentScreen.routeName),
          builder: (_) => TreatmentPaymentScreen(
            clinic: data['clinic'],
            doctor: data['doctor'],
            slot: data['slot'],
          ),
        );
      case NotesScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: NotesScreen.routeName),
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
          settings: RouteSettings(name: NotificationScreen.routeName),
          builder: (_) {
            return NotificationScreen();
          },
        );
      case ProgressDetailScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: ProgressDetailScreen.routeName),
          builder: (_) => ProgressDetailScreen(),
        );
      case BiometricScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: BiometricScreen.routeName),
          builder: (_) => BiometricScreen(),
        );
      case SimulationHistoryScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: SimulationHistoryScreen.routeName),
          builder: (_) => SimulationHistoryScreen(),
        );
      case DoctorsListingScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(name: DoctorsListingScreen.routeName),
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
