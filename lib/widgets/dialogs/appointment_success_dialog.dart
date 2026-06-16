import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';

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
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Beautiful Success Icon with Gradient-like background
              Container(
                height: 100.h,
                width: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.lightBlueColor.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Iconsax.verify5, // Consistent with your icon style
                  size: 60.sp,
                  color: CustomColors.blueColor,
                ),
              ),
              SizedBox(height: 30.h),
              Text("Success!", style: CustomFonts.black28w600),
              SizedBox(height: 12.h),
              Text(
                "Appointment has been created. The clinic will coordinate with you soon!",
                textAlign: TextAlign.center,
                style: CustomFonts.grey18w400,
              ),
              SizedBox(height: 40.h),
              // Consistent Black Button
              SizedBox(
                width: double.infinity,
                height: 60.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (onDone != null) onDone();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                  child: Text("Great!", style: CustomFonts.white18w600),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
