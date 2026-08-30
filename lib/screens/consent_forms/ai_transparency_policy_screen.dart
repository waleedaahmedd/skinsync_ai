import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../utils/secure_storage_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';

class AiTransparencyPolicyScreen extends StatefulWidget {
  final VoidCallback? onPolicyAccepted;

  const AiTransparencyPolicyScreen({super.key, this.onPolicyAccepted});

  static const String routeName = "/AiTransparencyPolicyScreen";

  @override
  State<AiTransparencyPolicyScreen> createState() =>
      _AiTransparencyPolicyScreenState();
}

class _AiTransparencyPolicyScreenState extends State<AiTransparencyPolicyScreen> {
  bool _isAcknowledged = false;

  Future<void> _handleAccept() async {
    await SecureStorage().saveAiPolicyAccepted();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("AI Transparency & Responsible Use Policy acknowledged."),
          backgroundColor: CustomColors.purpleColor,
        ),
      );
      if (widget.onPolicyAccepted != null) {
        widget.onPolicyAccepted!();
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        title: "AI Transparency & Policy",
        onBackTap: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.w(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Text(
                "AI TRANSPARENCY AND RESPONSIBLE USE POLICY",
                style: CustomFonts.black16w600.copyWith(
                  letterSpacing: 0.2,
                  color: CustomColors.blackColor,
                ),
              ),
              SizedBox(height: context.h(6)),
              Text(
                "Effective date: August 23, 2026",
                style: CustomFonts.textGrey12w400.copyWith(fontStyle: FontStyle.italic),
              ),
              SizedBox(height: context.h(16)),

              // 1. Where AI Is Used
              _buildSectionCard(
                title: "1. Where AI Is Used",
                content:
                    "AI may assess scan quality, describe visible characteristics, "
                    "create illustrative simulations, generate informational Treatment Journeys, "
                    "organize patient inputs, and support safety or quality checks.",
              ),
              SizedBox(height: context.h(12)),

              // 2. Limitations
              _buildSectionCard(
                title: "2. Limitations",
                content:
                    "AI does not conduct a physical examination, access every relevant fact, "
                    "diagnose, establish medical necessity, prescribe, obtain treatment consent, "
                    "or guarantee an outcome. Outputs may be inaccurate, inconsistent, biased, "
                    "or less reliable for underrepresented populations or poor capture conditions.",
              ),
              SizedBox(height: context.h(12)),

              // 3. Patient Control and Human Review
              _buildSectionCard(
                title: "3. Patient Control and Human Review",
                content:
                    "Users choose whether to scan, compare private options, select or change a Final "
                    "option, preview the exact clinic report, refuse sharing, withdraw eligible "
                    "consent, and exercise privacy rights. Clinics must independently review all "
                    "clinically relevant information.",
              ),
              SizedBox(height: context.h(12)),

              // 4. Training and Improvement
              _buildSectionCard(
                title: "4. Training and Improvement",
                content:
                    "At launch, SkinSync prohibits identifiable health data, facial images, "
                    "biometric data, Treatment Journey content, and PHI from generalized or "
                    "cross-customer training. Properly de-identified data may be used only after "
                    "documented legal and technical review, applicable expert determination for "
                    "facial representations, no-reidentification controls, and compatibility with "
                    "user promises and clinic agreements.",
              ),
              SizedBox(height: context.h(12)),

              // 5. Fairness, Safety, and Reporting
              _buildSectionCard(
                title: "5. Fairness, Safety, and Reporting",
                content:
                    "SkinSync will test material model changes across representative skin tones, "
                    "adult age groups, sex and gender presentations, camera conditions, lighting, "
                    "and accessibility contexts; document limitations and rollback; and provide "
                    "reporting through support@skinsyncai.com or legal@skinsyncai.com without "
                    "asking users to email facial images through an insecure channel.",
              ),
              SizedBox(height: context.h(16)),

              // Acknowledgment Checkbox Section
              _buildCheckboxItem(
                value: _isAcknowledged,
                text:
                    "I have read, understood, and acknowledge the AI Transparency and Responsible Use Policy.",
                onChanged: (val) {
                  setState(() {
                    _isAcknowledged = val ?? false;
                  });
                },
              ),
              SizedBox(height: context.h(100)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: context.w(24),
          right: context.w(24),
          bottom: MediaQuery.paddingOf(context).bottom + context.h(20),
          top: context.h(20),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: CustomButton(
          text: "Acknowledge & Continue",
          onPressed: _isAcknowledged ? _handleAccept : null,
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomFonts.black14w700,
          ),
          SizedBox(height: context.h(8)),
          Text(
            content,
            style: CustomFonts.black13w400.copyWith(height: 1.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem({
    required bool value,
    required String text,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: context.h(24),
            width: context.w(24),
            child: Checkbox(
              value: value,
              activeColor: CustomColors.purpleColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.r(4)),
              ),
              side: BorderSide(color: Colors.grey.shade400, width: 1.5),
              onChanged: onChanged,
            ),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(!value),
              child: Text(
                text,
                style: CustomFonts.black13w400.copyWith(
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
