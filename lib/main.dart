import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'app_init.dart';
import 'firebase_options.dart';
import 'services/storage_service.dart';
import 'utills/secure_storage_service.dart';

bool isDeploymentMode = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    // Replace this string with the permanent token you generated in Step 1

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );

    // For native platforms, ensure the token is fed directly into the native layer.
    // If you are using environment variables via --dart-define-from-file:
    // const token = String.fromEnvironment('APP_CHECK_DEBUG_TOKEN');
  } else {
    // Production attestation providers
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttestWithDeviceCheckFallback,
    );
  }
  await ScreenUtilPlus.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SecureStorage().init();
  await StorageService.instance.init();
  runApp(const ProviderScope(child: AppInit()));
}
