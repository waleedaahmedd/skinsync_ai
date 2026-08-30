import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../widgets/custom_button.dart';
import 'privacy_policy_screen.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({super.key});
  static const String routeName = '/TermsOfServiceScreen';

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
  bool _isAccepted = false;

  final List<Map<String, String>> _termsSections = const [
    {
      'title': '1. Agreement and Separate Consents',
      'body':
          'By creating an account and affirmatively accepting these Terms, you agree to them. The Privacy Policy is a notice and does not serve as blanket consent. Separate affirmative consents govern consumer health-data collection, facial and biometric processing, electronic records, marketing, clinic sharing, and any future optional purpose requiring consent.',
    },
    {
      'title': '2. Eligibility and Account Security',
      'body':
          'The Platform is intended for individuals at least 18 years old who may agree for themselves. Provide accurate information, protect credentials, and do not upload another person’s image or information without verified authority and all required consent.',
    },
    {
      'title': '3. Technology Service; No Medical Practice',
      'body':
          'SkinSync provides technology for image processing, visible-feature descriptions, illustrative simulations, Treatment Journey creation, comparison, clinic sharing, scheduling, communications, and progress tracking. SkinSync is not a medical practice, does not diagnose or prescribe, and does not replace independent professional judgment.',
    },
    {
      'title': '4. Treatment Journeys and Simulations',
      'body':
          'A Treatment Journey Group may contain multiple private Simulation Options. “Final” means only the user-selected option for discussion; it does not mean approval, recommendation, prescription, medical necessity, booking, price commitment, or guaranteed result. A clinic may revise or reject any option.',
    },
    {
      'title': '5. Health Information and Facial Data',
      'body':
          'Health intake and facial processing are available only after the applicable standalone consents. You retain rights in submitted content and grant SkinSync a limited license to host, reproduce, transform, display, and transmit it only to provide requested services, protect the Platform, and comply with law.',
    },
    {
      'title': '6. Clinic Sharing and Post-Treatment Records',
      'body':
          'Nothing is shared with a clinic until the required clinic-share process is completed. Clinic-connected post-treatment records may become part of the clinic’s medical record and may be retained under the clinic’s legal duties. Private consumer records remain segregated unless the user directs a share or SkinSync is otherwise acting for the clinic.',
    },
    {
      'title': '7. AI Training and Secondary Use',
      'body':
          'SkinSync will not use identifiable facial images, identifiable consumer health data, Treatment Journey content, or PHI for generalized or cross-customer model training, sale, data brokerage, or cross-context behavioral advertising. A future materially different use requires separate legal review and any required specific authorization; a Terms update alone is insufficient.',
    },
    {
      'title': '8. Communications',
      'body':
          'SkinSync may send security, consent, receipt, account, and requested service communications. Marketing email or texts require separate channel-specific consent and may be stopped without losing core service. A clinic-share authorization does not authorize unrelated clinic marketing.',
    },
    {
      'title': '9. Acceptable Use and Intellectual Property',
      'body':
          'Do not violate law or another person’s rights, impersonate, bypass security, access another user’s data, introduce malicious code, scrape or reverse engineer except where law forbids restriction, or use output as a substitute for required clinical judgment. SkinSync and its licensors own the Platform, models, interfaces, trademarks, and SkinSync-created materials.',
    },
    {
      'title': '10. Suspension, Deletion, and Survival',
      'body':
          'SkinSync may suspend access for security, fraud, unlawful activity, material breach, patient safety, or system risk. Deletion is subject to applicable consumer rights, clinic medical-record duties, legal holds, security evidence, consent records, and disclosed backup cycles. Confidentiality, intellectual-property, liability, and other provisions that by nature survive remain effective.',
    },
    {
      'title': '11. Disclaimers and Liability',
      'body':
          'TO THE MAXIMUM EXTENT PERMITTED BY LAW, THE PLATFORM AND AI OUTPUTS ARE PROVIDED “AS IS” AND “AS AVAILABLE.” SKINSYNC DOES NOT WARRANT THAT OUTPUTS ARE COMPLETE, UNBIASED, CLINICALLY APPROPRIATE, OR ACHIEVABLE. SKINSYNC WILL NOT BE LIABLE FOR INDIRECT, SPECIAL, CONSEQUENTIAL, EXEMPLARY, OR PUNITIVE DAMAGES WHERE EXCLUSION IS LAWFUL. FOR OTHER CLAIMS, SKINSYNC’S AGGREGATE LIABILITY WILL NOT EXCEED THE GREATER OF \$100 OR AMOUNTS THE USER PAID TO SKINSYNC DURING THE PRIOR TWELVE MONTHS. NONWAIVABLE RIGHTS AND LIABILITY ARE NOT LIMITED.',
    },
    {
      'title': '12. Changes, Governing Law, and Contact',
      'body':
          'Material changes affecting sensitive-data uses will receive additional notice and renewed consent when required. Delaware law governs subject to mandatory consumer protections. Questions: legal@skinsyncai.com, 9 N. Wabash Avenue, Chicago, Illinois 60602, 312-847-2424.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(minHeight: MediaQuery.heightOf(context)),
        decoration: const BoxDecoration(
          gradient: CustomColors.purpleWhiteBlueGradient,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(30)),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(40)),
                Text(
                  "TERMS OF SERVICE",
                  style: CustomFonts.black30w600,
                ),
                SizedBox(height: context.h(4)),
                Text(
                  "Effective date: August 23, 2026",
                  style: CustomFonts.black14w400.copyWith(
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: context.h(8)),
                Text(
                  "Please review and accept our terms before proceeding.",
                  style: CustomFonts.black18w400,
                ),
                SizedBox(height: context.h(24)),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: context.h(16)),
                          child: Text(
                            "These Terms govern use of the SkinSync AI website, applications, and related services (the “Platform”). “SkinSync,” “we,” and “us” mean SkinSync AI Inc., 9 N. Wabash Avenue, Chicago, Illinois 60602.",
                            style: CustomFonts.black14w400.copyWith(
                              height: 1.4,
                              color: Colors.black.withValues(alpha: 0.75),
                            ),
                          ),
                        ),
                        ..._termsSections.map(
                          (section) => Padding(
                            padding: EdgeInsets.only(bottom: context.h(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  section['title']!,
                                  style: CustomFonts.black18w600,
                                ),
                                SizedBox(height: context.h(6)),
                                Text(
                                  section['body']!,
                                  style: CustomFonts.black14w400.copyWith(
                                    height: 1.4,
                                    color: Colors.black.withValues(alpha: 0.75),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: context.h(12)),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isAccepted = !_isAccepted;
                    });
                  },
                  borderRadius: BorderRadius.circular(context.r(8)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: context.h(8)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: context.w(24),
                          width: context.w(24),
                          child: Checkbox(
                            value: _isAccepted,
                            activeColor: CustomColors.darkPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(context.r(4)),
                            ),
                            onChanged: (bool? value) {
                              setState(() {
                                _isAccepted = value ?? false;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: context.w(12)),
                        Expanded(
                          child: Text(
                            "I have read, understood, and accept the terms of service.",
                            style: CustomFonts.black14w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: context.h(20)),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: "Next",
                    onPressed: _isAccepted
                        ? () {
                           Navigator.pushNamedAndRemoveUntil(
                                context,
                                PrivacyPolicyScreen.routeName,
                                arguments: false,
                                (Route<dynamic> route) => false,
                              );
                          }
                        : null,
                  ),
                ),
                SizedBox(height: context.h(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}