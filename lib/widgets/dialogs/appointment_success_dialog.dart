import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';

import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../custom_button.dart';

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
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(24),
            vertical: context.h(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Beautiful Success Icon with Gradient-like background
              Container(
                height: context.w(72),
                width: context.w(72),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.lightBlueColor.withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Icon(
                    Iconsax.verify5, // Consistent with your icon style
                    size: context.sp(40),
                    color: CustomColors.blueColor,
                  ),
                ),
              ),
              SizedBox(height: context.h(24)),
              Text("Success!", style: CustomFonts.black24w600),
              SizedBox(height: context.h(12)),
              Text(
                "Your appointment has been successfully created. The clinic will coordinate with you soon!",
                textAlign: TextAlign.center,
                style: CustomFonts.textGrey14w400,
              ),
              SizedBox(height: context.h(28)),
              // Consistent Black Button
              CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (onDone != null) onDone();
                },
                text: "Great!",
              ),
            ],
          ),
        ),
      );
    },
  );
}
