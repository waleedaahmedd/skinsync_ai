import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pinput/pinput.dart';
import 'package:skinsync_ai/screens/face_scan_screen.dart';
import 'package:skinsync_ai/screens/login_screen.dart';
import 'package:skinsync_ai/screens/signup_onboarding.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/auth_view_model.dart';

import '../widgets/custom_app_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  static const String routeName = '/NotificationScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showTitle: true, title: "Notification"),
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
