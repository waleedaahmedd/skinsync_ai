import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';
import 'package:skinsync_ai/widgets/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  static const routeName = "/NotificationScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.greyColor,
      appBar: CustomAppBar(
        title: Text("Notifications", style: CustomFonts.black26w600),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            SizedBox(height: 19.h),
            Text("23 Feb 2025", style: CustomFonts.black16w600),
            SizedBox(height: 7.h),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 14.h),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return NotificationCard(
                    title: 'Your Appointment is Tomorrow!',
                    message:
                        'Hey! Just a quick reminder that your derma Fillers appointment is tomorrow at 10 AM.',
                  );
                },
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
