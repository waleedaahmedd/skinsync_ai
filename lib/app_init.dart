
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:skinsync_ai/route_generator.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/screen_size.dart';
import 'package:skinsync_ai/utills/theme.dart';
import 'package:skinsync_ai/view_models/theme_view_model.dart';

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
    final ThemeMode themeMode = ThemeMode.light;
    return ScreenUtilInit(
        designSize: getDesignSize(context: context),
        ensureScreenSize: true,
        minTextAdapt: true,
        splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SkinSync AI',
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
          themeMode: themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

        );
      }
    );
  }
}
