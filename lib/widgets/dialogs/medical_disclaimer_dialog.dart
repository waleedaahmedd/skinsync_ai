import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/custom_fonts.dart';
import '../custom_button.dart';

void showMedicalDisclaimerDialog({
  required BuildContext context,
  VoidCallback? onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => MedicalDisclaimerDialog(onConfirm: onConfirm),
  );
}

class MedicalDisclaimerDialog extends StatelessWidget {
  final VoidCallback? onConfirm;

  const MedicalDisclaimerDialog({super.key, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: context.w(20)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(24)),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.w(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.medical_services_outlined,
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Iconsax.close_circle, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: context.h(16)),
            Text(
              "Medical Disclaimer",
              style: CustomFonts.black20w600.copyWith(color: Colors.red),
            ),
            SizedBox(height: context.h(12)),
            Text(
              "Important: SkinSync AI does not provide medical advice, diagnosis, or treatment. AI visualizations are for illustrative purposes only. Always consult a licensed healthcare professional for medical advice and before making any treatment decisions.",
              style: CustomFonts.black14w400.copyWith(
                height: 1.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(24)),
            CustomButton(
              text: "I Understand",
              onPressed: () {
                Navigator.pop(context);
                onConfirm?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
