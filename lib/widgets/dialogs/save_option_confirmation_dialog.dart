import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../custom_button.dart';

void showSaveOptionConfirmationDialog({
  required BuildContext screenContext,
  required String groupName,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: screenContext,
    barrierDismissible: true,
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
              Container(
                height: context.w(72),
                width: context.w(72),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.lightPurpleColor.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Icon(
                    Iconsax.add_square,
                    size: context.sp(32),
                    color: CustomColors.purpleColor,
                  ),
                ),
              ),
              SizedBox(height: context.h(24)),
              Text(
                "Save Option?",
                textAlign: TextAlign.center,
                style: CustomFonts.black20w600,
              ),
              SizedBox(height: context.h(12)),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: CustomFonts.textGrey14w400,
                  children: [
                    const TextSpan(
                      text:
                          "Are you sure you want to add this new simulation option to the group ",
                    ),
                    TextSpan(
                      text: "\"$groupName\"",
                      style: CustomFonts.black14w600.copyWith(
                        color: CustomColors.purpleColor,
                      ),
                    ),
                    const TextSpan(text: "?"),
                  ],
                ),
              ),
              SizedBox(height: context.h(28)),
              CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                text: "Save",
              ),
              SizedBox(height: context.h(15)),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Cancel",
                  isBorder: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
