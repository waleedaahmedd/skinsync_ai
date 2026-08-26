import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/custom_fonts.dart';
import '../custom_button.dart';

void showFacialScanConsentDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: context.w(20)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(20),
            vertical: context.h(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Confirmation",
                      style: CustomFonts.black20w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Iconsax.close_circle, color: Colors.grey),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: context.h(20)),
              Text(
                "By continuing, you confirm that you are voluntarily submitting new facial images for SkinSync’s facial-analysis, simulation, treatment-planning, and progress-tracking features under your existing Facial Scan and Biometric Consent. Do not continue if you have withdrawn that consent.",
                style: CustomFonts.black14w400.copyWith(
                  height: 1.5,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.h(28)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: context.h(14)),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.r(30)),
                        ),
                      ),
                      child: Text(
                        "No",
                        style: CustomFonts.black14w600.copyWith(color: Colors.black54),
                      ),
                    ),
                  ),
                  SizedBox(width: context.w(12)),
                  Expanded(
                    child: CustomButton(
                      text: "Yes",
                      height: context.h(52),
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
