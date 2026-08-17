import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/custom_fonts.dart';
import '../custom_button.dart';

void showDeleteConfirmationDialog({
  required BuildContext context,
  required String title,
  required String description,
  required VoidCallback onDelete,
  String deleteButtonText = "Delete",
}) {
  showDialog(
    context: context,
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
              // Red Warning Badge Icon
              Container(
                height: context.w(72),
                width: context.w(72),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade50,
                ),
                child: Center(
                  child: Icon(
                    Iconsax.trash,
                    size: context.sp(32),
                    color: const Color(0xffD72547),
                  ),
                ),
              ),
              SizedBox(height: context.h(24)),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: CustomFonts.black20w600,
              ),
              SizedBox(height: context.h(12)),

              // Subtitle
              Text(
                description,
                textAlign: TextAlign.center,
                style: CustomFonts.textGrey14w400,
              ),
              SizedBox(height: context.h(28)),

              // Delete Action Button
              CustomButton(
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                  onDelete();
                },
                backgroundColor: const Color(0xffD72547),
                text: deleteButtonText,
              ),
              SizedBox(height: context.h(15)),

              // Cancel Button
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
