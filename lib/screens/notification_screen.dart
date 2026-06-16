import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          left: 30.w,
          right: 30.w,
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
