import 'package:flutter/material.dart';

import 'models/responses/get_clinic_response.dart';
import 'models/responses/treatment_area_list_response.dart';
import 'models/responses/treatment_category_list_response.dart';
import 'models/responses/treatment_list_response.dart';
import 'screens/additional_info_screen.dart';
import 'screens/allergy_and_medical_history.dart';
import 'screens/ar_face_model_preview_screen.dart';
import 'screens/biometric_screen.dart';
import 'screens/bottom_nav_page.dart';
import 'screens/bottom_nav_screens/appointments_screen.dart';
import 'screens/bottom_nav_screens/face_detection_screen.dart';
import 'screens/bottom_nav_screens/my_profile_screen.dart';
import 'screens/treatments_screen.dart';
import 'screens/clinic_service_screen.dart';
import 'screens/clinics_detail_screen.dart';
import 'screens/doctor_detail_screen.dart';
import 'screens/doctors_screen.dart';
import 'screens/explore_clinics_screen.dart';
import 'screens/face_pose_capture_screen.dart';
import 'screens/face_scan_screen.dart';
import 'screens/get_notified_screen.dart';
import 'screens/get_started_screen.dart';
import 'screens/bottom_nav_screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/personal_detail_screen.dart';
import 'screens/progress_detail_screen.dart';
import 'screens/review_screen.dart';
import 'screens/saved_treatment_screen.dart';
import 'screens/select_appointment_type_screen.dart';
import 'screens/select_date_time_screen.dart';
import 'screens/select_product_screen.dart';
import 'screens/setting_screen.dart';
import 'screens/signup_onboarding.dart';
import 'screens/simulation_history_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/treatment_area_screen.dart';
import 'screens/treatment_category_screen.dart';
import 'screens/treatment_detail_screen.dart';
import 'screens/bottom_nav_screens/treatment_explore_screen.dart';
import 'screens/treatment_payment_screen.dart';
import 'screens/your_profile_screen.dart';
import 'utills/colored_print.dart';
import 'utills/enums.dart';

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
          builder: (_) => FaceDetectionScreen(pose: args as String? ?? 'front'),
        );
      case FacePoseCaptureScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: FacePoseCaptureScreen.routeName),
          builder: (_) => const FacePoseCaptureScreen(),
        );
      case FaceScanScreen.routeName:
        final pose = settings.arguments as String? ?? 'front';
        return MaterialPageRoute(
          settings: RouteSettings(
            name: FaceScanScreen.routeName,
            arguments: pose,
          ),
          builder: (_) => FaceScanScreen(pose: pose),
        );
      case AppointmentsScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppointmentsScreen.routeName),
          builder: (_) => const AppointmentsScreen(),
        );
      case MyProfileScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: MyProfileScreen.routeName),
          builder: (_) => const MyProfileScreen(),
        );
      case ArFaceModelPreviewScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(
            name: ArFaceModelPreviewScreen.routeName,
          ),
          builder: (_) => const ArFaceModelPreviewScreen(),
        );
      case ExploreClinicsScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: ExploreClinicsScreen.routeName),
          builder: (_) => const ExploreClinicsScreen(),
        );
      case TreatmentDetailScreen.routeName:
        final treatments = settings.arguments as TreatmentData;
        return MaterialPageRoute(
          settings: const RouteSettings(name: TreatmentDetailScreen.routeName),
          builder: (_) => TreatmentDetailScreen(treatments: treatments),
        );
      case ClinicsDetailScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: ClinicsDetailScreen.routeName),
          builder: (_) => ClinicsDetailScreen(clinic: args as Clinic?),
        );
      case SelectAppointmentTypeScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(
            name: SelectAppointmentTypeScreen.routeName,
          ),
          builder: (_) => const SelectAppointmentTypeScreen(),
        );
      case DoctorsScreen.routeName:
        final argsMap = args as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          settings: const RouteSettings(name: DoctorsScreen.routeName),
          builder: (_) => DoctorsScreen(
            isFromHome: argsMap['isFromHome'] as bool? ?? false,
          ),
        );
      case DoctorDetailScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: DoctorDetailScreen.routeName),
          builder: (_) {
            final data = args as Map<String, dynamic>;
            return DoctorDetailScreen(
              doctor: data['doctor']!,
              clinic: data['clinic'],
            );
          },
        );
      case SelectDateTimeScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: SelectDateTimeScreen.routeName),
          builder: (_) => const SelectDateTimeScreen(),
        );
      case ReviewScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: ReviewScreen.routeName),
          builder: (_) => const ReviewScreen(),
        );
      case PaymentScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: PaymentScreen.routeName),
          builder: (_) => const PaymentScreen(),
        );
      case ClinicServiceScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: ClinicServiceScreen.routeName),
          builder: (_) => const ClinicServiceScreen(),
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
          settings: const RouteSettings(
            name: AllergyAndMedicalHistory.routeName,
          ),
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
      case TreatmentExploreScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: TreatmentExploreScreen.routeName),
          builder: (_) => const TreatmentExploreScreen(),
        );
      case TreatmentCategoryScreen.routeName:
        final argsMap = args as Map<String, dynamic>? ?? {};
        final list = argsMap['categories'] as List<TreatmentCategoryModel>?;
        final screenTitle = argsMap['title'] as String? ?? "By Category";
        final path = argsMap['selectionPath'] as String? ?? "Categories";
        return MaterialPageRoute(
          settings: const RouteSettings(
            name: TreatmentCategoryScreen.routeName,
          ),
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
        final treatmentId = argsMap['treatmentId'] as int?;
        return MaterialPageRoute(
          settings: const RouteSettings(name: TreatmentAreaScreen.routeName),
          builder: (_) => TreatmentAreaScreen(
            areas: list,
            title: screenTitle,
            selectionPath: path,
            treatmentId: treatmentId,
          ),
        );
      case SelectProductScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: SelectProductScreen.routeName),
          builder: (_) => const SelectProductScreen(),
        );
      case TreatmentPaymentScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: TreatmentPaymentScreen.routeName),
          builder: (_) => const TreatmentPaymentScreen(),
        );
      case NotesScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: NotesScreen.routeName),
          builder: (_) => const NotesScreen(),
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
          builder: (_) => const ProgressDetailScreen(),
        );
      case BiometricScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: BiometricScreen.routeName),
          builder: (_) => const BiometricScreen(),
        );
      case SimulationHistoryScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(
            name: SimulationHistoryScreen.routeName,
          ),
          builder: (_) => const SimulationHistoryScreen(),
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
