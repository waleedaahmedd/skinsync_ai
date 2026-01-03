import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  const NotificationCard({super.key, required this.title,required this.message});

  @override
  Widget build(BuildContext context) {
    return  Container(
              padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 17.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset(
                      PngAssets.splashLogo,
                      fit: BoxFit.cover,
                      height: 57.67.w,
                      width: 58.39.w,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Appointment is Tomorrow!",
                          style: CustomFonts.black18w600,
                        ),
                        Text(
                          "Hey! Just a quick reminder that your derma Fillers appointment is tomorrow at 10 AM.",
                          style: CustomFonts.black18w400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
  }
}