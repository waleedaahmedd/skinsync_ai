import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/view_models/theme_view_model.dart';

import 'route_generator.dart';
import 'utills/color_constant.dart';
import 'utills/screen_size.dart';
import 'utills/theme.dart';

class AppInit extends StatelessWidget {
  const AppInit({super.key});
  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      // ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = CustomColors.blackColor
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      // ..maskColor = Colors.black.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  @override
  Widget build(BuildContext context) {
    configLoading();
    return ScreenUtilInit(
      designSize: getDesignSize(context: context),
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return Consumer(
          builder: (context, ref, child) {
            final ThemeMode themeMode = ref.watch(themeViewModel);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'SkinSync AI',
              initialRoute: '/',
              onGenerateRoute: RouteGenerator.generateRoute,
              themeMode: themeMode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
            );
          },
        );
      },
    );
  }
}
