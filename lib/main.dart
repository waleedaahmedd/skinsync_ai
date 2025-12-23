import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_init.dart';
import 'services/storage_service.dart';
import 'utills/secure_storage_service.dart';
import 'utills/shared_pref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPref.init();
  await SecureStorage().init();
  await StorageService.instance.init();
  runApp(ProviderScope(child: AppInit()));
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (context) => ThemeViewModel()),
  //       ChangeNotifierProvider(
  //         create: (context) => AuthViewModel(authRepository: authService),
  //       ),
  //     ],
  //     child: AppInit(),
  //   ),
  // );
}
