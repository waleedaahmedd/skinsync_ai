
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:skinsync_ai/route_generator.dart';
import 'package:skinsync_ai/utills/screen_size.dart';
import 'package:skinsync_ai/utills/theme.dart';
import 'package:skinsync_ai/view_models/theme_view_model.dart';

class AppInit extends StatelessWidget {
  const AppInit({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch();
    // ScreenUtil.init(context);
    final ThemeMode themeMode = context.watch<ThemeViewModel>().themeMode;
    return ScreenUtilInit(
        designSize: getDesignSize(context: context),
        ensureScreenSize: true,
        minTextAdapt: true,
        splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Beauty Points',
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
