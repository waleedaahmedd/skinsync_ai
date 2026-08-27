import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../widgets/custom_app_bar.dart';
import 'consent_detail_screen.dart';

class ComplianceFormsScreen extends StatelessWidget {
  const ComplianceFormsScreen({super.key});

  static const String routeName = "/ComplianceFormsScreen";

  @override
  Widget build(BuildContext context) {
    // Dummy data for agreements
    final List<Map<String, String>> agreements = [
      {
        "title": "Nationwide Launch Agreements + Consent Package",
        "subtitle": "Agreement A: Terms of Service",
        "date": "Effective date: August 23, 2026",
        "id": "1",
      },
      {
        "title": "Privacy Practices Agreement",
        "subtitle": "Agreement B: Data Privacy",
        "date": "Effective date: August 25, 2026",
        "id": "2",
      },
      {
        "title": "Telehealth Consent Form",
        "subtitle": "Agreement C: Remote Consultation",
        "date": "Effective date: September 01, 2026",
        "id": "3",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Compliance Forms"),
      body: ListView.separated(
        padding: EdgeInsets.all(context.w(20)),
        itemCount: agreements.length,
        separatorBuilder: (context, index) => SizedBox(height: context.h(16)),
        itemBuilder: (context, index) {
          final agreement = agreements[index];
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                ConsentDetailScreen.routeName,
                arguments: agreement,
              );
            },
            borderRadius: BorderRadius.circular(context.r(16)),
            child: Container(
              padding: EdgeInsets.all(context.w(16)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(context.r(16)),
                border: Border.all(
                  color: CustomColors.greyColor.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(context.w(10)),
                    decoration: BoxDecoration(
                      color: CustomColors.purpleColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.document_text,
                      color: CustomColors.purpleColor,
                      size: context.w(24),
                    ),
                  ),
                  SizedBox(width: context.w(16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agreement["title"]!,
                          style: CustomFonts.black16w600,
                        ),
                        SizedBox(height: context.h(4)),
                        Text(
                          agreement["subtitle"]!,
                          style: CustomFonts.grey14w400,
                        ),
                        SizedBox(height: context.h(8)),
                        Text(
                          agreement["date"]!,
                          style: CustomFonts.grey12w400.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade400,
                    size: context.sp(24),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
