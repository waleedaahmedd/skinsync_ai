import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/custom_fonts.dart';

class MedicalDisclaimerBanner extends StatelessWidget {
  const MedicalDisclaimerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: context.w(20), vertical: context.h(10)),
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.medical_services_outlined,
            color: Colors.red.shade700,
            size: context.sp(20),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Text(
              "Important: SkinSync AI does not provide medical advice, diagnosis, or treatment. AI visualizations are for illustrative purposes only. Always consult a licensed healthcare professional for medical advice and before making any treatment decisions.",
              style: CustomFonts.black12w600.copyWith(
                color: Colors.red.shade900,
                fontSize: context.sp(11),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
