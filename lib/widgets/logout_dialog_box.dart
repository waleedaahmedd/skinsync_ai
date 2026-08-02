import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.r(24))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(24), vertical: context.h(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Beautiful Red Warning Badge Icon
              Container(
                height: context.w(72),
                width: context.w(72),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade50,
                ),
                child: Center(
                  child: Icon(
                    Iconsax.logout,
                    size: context.sp(32),
                    color: const Color(0xffD72547),
                  ),
                ),
              ),
              SizedBox(height: context.h(24)),

              // Title
              Text(
                "Logout?",
                textAlign: TextAlign.center,
                style: CustomFonts.black20w600,
              ),
              SizedBox(height: context.h(12)),

              // Subtitle
              Text(
                "Are you sure you want to log out from the application?",
                textAlign: TextAlign.center,
                style: CustomFonts.textGrey14w400,
              ),
              SizedBox(height: context.h(28)),

              // Logout Action Button
              SizedBox(
                width: double.infinity,
                height: context.h(52),
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
                      borderRadius: BorderRadius.circular(context.r(26)),
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
              SizedBox(height: context.h(12)),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: context.h(52),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero, // Zero padding prevents vertical text clipping
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.r(26)),
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
