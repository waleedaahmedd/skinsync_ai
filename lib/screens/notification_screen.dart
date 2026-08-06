import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utills/custom_fonts.dart';

import '../widgets/custom_app_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  static const String routeName = '/NotificationScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showTitle: true, title: "Notification"),
      body: Padding(
        padding: EdgeInsets.only(
          left: context.w(30),
          right: context.w(30),
          bottom: MediaQuery.paddingOf(context).bottom,
        ),
        child: Center(
          child: Center(
            child: Text('My Notifications Yet', style: CustomFonts.grey16w400),
          ),
        ),
      ),
    );
  }
}
