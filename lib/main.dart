import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'app_init.dart';
import 'firebase_options.dart';
import 'services/storage_service.dart';
import 'utils/secure_storage_service.dart';

bool isDeploymentMode = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await ScreenUtilPlus.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SecureStorage().init();
  await StorageService.instance.init();
  runApp(const ProviderScope(child: AppInit()));
}
