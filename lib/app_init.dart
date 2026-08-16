import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'utils/assets.dart';
import 'view_models/theme_view_model.dart';

import 'route_generator.dart';
import 'utils/color_constant.dart';
import 'utils/screen_size.dart';
import 'utils/theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void configLoading(BuildContext context) {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    // ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = context.w(50)
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = CustomColors.blackColor
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..indicatorWidget = SizedBox(
      height: context.w(60),
      width: context.w(60),
      child: Stack(
        children: [
          Center(
            child: Image.asset(PngAssets.splashLogo,
                width: context.w(50), height: context.w(50)),
          ),
          SizedBox(
            height: context.w(60),
            width: context.w(60),
            child: const CircularProgressIndicator(),
          ),
        ],
      ),
    )
    // ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class AppInit extends StatelessWidget {
  const AppInit({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilPlusInit(
      designSize: getDesignSize(context: context),
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        configLoading(context);
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
              theme: AppTheme.lightTheme(context),
              darkTheme: AppTheme.darkTheme,
              builder: EasyLoading.init(),
            );
          },
        );
      },
    );
  }
}