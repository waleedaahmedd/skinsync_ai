import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../widgets/custom_app_bar.dart';

class ConsentDetailScreen extends StatelessWidget {
  const ConsentDetailScreen({super.key});

  static const String routeName = "/ConsentDetailScreen";

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
    final title = args?['title'] ?? "Agreement";
    final id = args?['id'] ?? "1";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: title),
      body: id == "1"
          ? _buildFirstAgreement(context)
          : _buildDummyAgreement(context, title),
    );
  }

  Widget _buildDummyAgreement(BuildContext context, String title) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.w(24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.document_code,
              size: context.w(64),
              color: CustomColors.purpleColor.withValues(alpha: 0.3),
            ),
            SizedBox(height: context.h(24)),
            Text(
              "Coming Soon",
              style: CustomFonts.black22w600,
            ),
            SizedBox(height: context.h(12)),
            Text(
              "The details for \"$title\" are currently being finalized and will be available shortly.",
              textAlign: TextAlign.center,
              style: CustomFonts.grey14w400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstAgreement(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SKINSYNC AI INC. NATIONWIDE LAUNCH AGREEMENTS + CONSENT PACKAGE",
            style: CustomFonts.black18w600,
          ),
          SizedBox(height: context.h(8)),
          Text(
            "AGREEMENT A: TERMS OF SERVICE",
            style: CustomFonts.black16w600
                .copyWith(color: CustomColors.purpleColor),
          ),
          SizedBox(height: context.h(4)),
          Text(
            "Effective date: August 23, 2026",
            style: CustomFonts.grey14w400.copyWith(fontStyle: FontStyle.italic),
          ),
          SizedBox(height: context.h(20)),
          Text(
            "These Terms govern use of the SkinSync AI website, applications, and related services (the “Platform”). “SkinSync,” “we,” and “us” mean SkinSync AI Inc., 9 N. Wabash Avenue, Chicago, Illinois 60602.",
            style: CustomFonts.black14w400,
          ),
          SizedBox(height: context.h(24)),
          _buildSection(
            "1. Agreement and Separate Consents",
            "By creating an account and affirmatively accepting these Terms, you agree to them. The Privacy Policy is a notice and does not serve as blanket consent. Separate affirmative consents govern consumer health-data collection, facial and biometric processing, electronic records, marketing, clinic sharing, and any future optional purpose requiring consent.",
          ),
          _buildSection(
            "2. Eligibility and Account Security",
            "The Platform is intended for individuals at least 18 years old who may agree for themselves. Provide accurate information, protect credentials, and do not upload another person’s image or information without verified authority and all required consent.",
          ),
          _buildSection(
            "3. Technology Service; No Medical Practice",
            "SkinSync provides technology for image processing, visible-feature descriptions, illustrative simulations, Treatment Journey creation, comparison, clinic sharing, scheduling, communications, and progress tracking. SkinSync is not a medical practice, does not diagnose or prescribe, and does not replace independent professional judgment.",
          ),
          _buildSection(
            "4. Treatment Journeys and Simulations",
            "A Treatment Journey Group may contain multiple private Simulation Options. “Final” means only the user-selected option for discussion; it does not mean approval, recommendation, prescription, medical necessity, booking, price commitment, or guaranteed result. A clinic may revise or reject any option.",
          ),
          _buildSection(
            "5. Health Information and Facial Data",
            "Health intake and facial processing are available only after the applicable standalone consents. You retain rights in submitted content and grant SkinSync a limited license to host, reproduce, transform, display, and transmit it only to provide requested services, protect the Platform, and comply with law.",
          ),
          _buildSection(
            "6. Clinic Sharing and Post-Treatment Records",
            "Nothing is shared with a clinic until the required clinic-share process is completed. Clinic-connected post-treatment records may become part of the clinic’s medical record and may be retained under the clinic’s legal duties. Private consumer records remain segregated unless the user directs a share or SkinSync is otherwise acting for the clinic.",
          ),
          _buildSection(
            "7. AI Training and Secondary Use",
            "SkinSync will not use identifiable facial images, identifiable consumer health data, Treatment Journey content, or PHI for generalized or cross-customer model training, sale, data brokerage, or cross-context behavioral advertising. A future materially different use requires separate legal review and any required specific authorization; a Terms update alone is insufficient.",
          ),
          _buildSection(
            "8. Communications",
            "SkinSync may send security, consent, receipt, account, and requested service communications. Marketing email or texts require separate channel-specific consent and may be stopped without losing core service. A clinic-share authorization does not authorize unrelated clinic marketing.",
          ),
          _buildSection(
            "9. Acceptable Use and Intellectual Property",
            "Do not violate law or another person’s rights, impersonate, bypass security, access another user’s data, introduce malicious code, scrape or reverse engineer except where law forbids restriction, or use output as a substitute for required clinical judgment. SkinSync and its licensors own the Platform, models, interfaces, trademarks, and SkinSync-created materials.",
          ),
          _buildSection(
            "10. Suspension, Deletion, and Survival",
            "SkinSync may suspend access for security, fraud, unlawful activity, material breach, patient safety, or system risk. Deletion is subject to applicable consumer rights, clinic medical-record duties, legal holds, security evidence, consent records, and disclosed backup cycles. Confidentiality, intellectualproperty, liability, and other provisions that by nature survive remain effective.",
          ),
          _buildSection(
            "11. Disclaimers and Liability",
            "TO THE MAXIMUM EXTENT PERMITTED BY LAW, THE PLATFORM AND AI OUTPUTS ARE PROVIDED “AS IS” AND “AS AVAILABLE.” SKINSYNC DOES NOT WARRANT THAT OUTPUTS ARE COMPLETE, UNBIASED, CLINICALLY APPROPRIATE, OR ACHIEVABLE. SKINSYNC WILL NOT BE LIABLE FOR INDIRECT, SPECIAL, CONSEQUENTIAL, EXEMPLARY, OR PUNITIVE DAMAGES WHERE EXCLUSION IS LAWFUL. FOR OTHER CLAIMS, SKINSYNC’S AGGREGATE LIABILITY WILL NOT EXCEED THE GREATER OF \$100 OR AMOUNTS THE USER PAID TO SKINSYNC DURING THE PRIOR TWELVE MONTHS. NONWAIVABLE RIGHTS AND LIABILITY ARE NOT LIMITED.",
          ),
          _buildSection(
            "12. Changes, Governing Law, and Contact",
            "Material changes affecting sensitive-data uses will receive additional notice and renewed consent when required. Delaware law governs subject to mandatory consumer protections. Questions: legal@skinsyncai.com, 9 N. Wabash Avenue, Chicago, Illinois 60602, 312-847-2424.",
          ),
          SizedBox(height: context.h(40)),
        ],
      ),
    );
  }

  Widget _buildSection(String heading, String body) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: CustomFonts.black16w600,
          ),
          SizedBox(height: 8.h),
          Text(
            body,
            style: CustomFonts.grey14w400.copyWith(
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
