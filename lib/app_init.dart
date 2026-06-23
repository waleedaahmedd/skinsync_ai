import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'utills/assets.dart';
import 'view_models/theme_view_model.dart';

import 'route_generator.dart';
import 'utills/color_constant.dart';
import 'utills/screen_size.dart';
import 'utills/theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    // ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 50.w
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = CustomColors.blackColor
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..indicatorWidget = SizedBox(
      height: 60.w,
      width: 60.w,
      child: Stack(
        children: [
          Center(
            child: Image.asset(PngAssets.splashLogo, width: 50.w, height: 50.w),
          ),
          SizedBox(
            height: 60.w,
            width: 60.w,
            child: const CircularProgressIndicator(),
          ),
        ],
      ),
    )
    // ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class AppInit extends StatelessWidget {
  const AppInit({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: getDesignSize(context: context),
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        configLoading();
        return Consumer(
          builder: (context, ref, child) {
            final ThemeMode themeMode = ref.watch(themeViewModel);
            return MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'SkinSync AI',
              initialRoute: '/',
              onGenerateRoute: RouteGenerator.generateRoute,
              themeMode: themeMode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              builder: EasyLoading.init(),
            );
          },
        );
      },
    );
  }
}