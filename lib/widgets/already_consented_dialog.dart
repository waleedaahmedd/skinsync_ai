import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import 'custom_button.dart';

class AlreadyConsentedDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onViewPdf;
  final VoidCallback onContinue;

  const AlreadyConsentedDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onViewPdf,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(20)),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(context.w(24)),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(context.r(20)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: context.h(60),
              width: context.w(60),
              decoration: const BoxDecoration(
                color: CustomColors.purpleColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 40,
              ),
            ),
            SizedBox(height: context.h(20)),
            Text(
              title,
              style: CustomFonts.black18w600,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(12)),
            Text(
              message,
              style: CustomFonts.textGrey14w400,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(24)),
            CustomButton(
              onPressed: onContinue,
              text: "Continue",
            ),
            SizedBox(height: context.h(12)),
            TextButton(
              onPressed: onViewPdf,
              child: Text(
                "View Signed Document",
                style: CustomFonts.purple14w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
