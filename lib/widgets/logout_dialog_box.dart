import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../services/google_auth_service.dart';
import '../utills/custom_fonts.dart';

void showLogoutDialog({
  required BuildContext screenContext,
  required String desc,
  required Function onSuccess,
}) {
  showDialog(
    context: screenContext,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Beautiful Red Warning Badge Icon
              Container(
                height: 72.w,
                width: 72.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade50,
                ),
                child: Center(
                  child: Icon(
                    Iconsax.logout,
                    size: 32.sp,
                    color: const Color(0xffD72547),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Title
              Text(
                "Logout?",
                textAlign: TextAlign.center,
                style: CustomFonts.black20w600,
              ),
              SizedBox(height: 12.h),

              // Subtitle
              Text(
                "Are you sure you want to log out from the application?",
                textAlign: TextAlign.center,
                style: CustomFonts.textGrey14w400,
              ),
              SizedBox(height: 28.h),

              // Logout Action Button
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await GoogleAuthService().logout();
                    onSuccess();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffD72547),
                    padding: EdgeInsets.zero, // Zero padding prevents vertical text clipping
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                    elevation: 1,
                  ),
                  child: Text(
                    "Logout",
                    style: CustomFonts.white16w600,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero, // Zero padding prevents vertical text clipping
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: CustomFonts.black14w600.copyWith(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
