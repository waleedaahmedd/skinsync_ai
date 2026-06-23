import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_init.dart';
import 'firebase_options.dart';
import 'services/storage_service.dart';
import 'utills/secure_storage_service.dart';
import 'utills/shared_pref.dart';

bool isDeploymentMode = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPref.init();
  await SecureStorage().init();
  await StorageService.instance.init();
  runApp(const ProviderScope(child: AppInit()));
}
