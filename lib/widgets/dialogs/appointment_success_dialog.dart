import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

void showAppointmentSuccessDialog({
  required BuildContext context,
  VoidCallback? onDone,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Beautiful Success Icon with Gradient-like background
              Container(
                height: 72.w,
                width: 72.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.lightBlueColor.withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Icon(
                    Iconsax.verify5, // Consistent with your icon style
                    size: 40.sp,
                    color: CustomColors.blueColor,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text("Success!", style: CustomFonts.black24w600),
              SizedBox(height: 12.h),
              Text(
                "Your appointment has been successfully created. The clinic will coordinate with you soon!",
                textAlign: TextAlign.center,
                style: CustomFonts.textGrey14w400,
              ),
              SizedBox(height: 28.h),
              // Consistent Black Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onDone != null) onDone();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    elevation: 1,
                  ),
                  child: Text("Great!", style: CustomFonts.white16w600),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}