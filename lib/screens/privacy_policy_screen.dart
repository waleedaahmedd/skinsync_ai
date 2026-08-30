import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../widgets/custom_button.dart';
import 'medical_disclaimer_screen.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});
  static const String routeName = '/PrivacyPolicyScreen';

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _isAccepted = false;

  final List<Map<String, String>> _privacySections = const [
    {
      'title': '1. Information Collected',
      'body':
          'SkinSync may collect account/contact data; health intake such as allergies, medications, medical history, prior procedures, pregnancy or treatment considerations; facial images, scan frames, progress photos, facial mapping, geometry, landmarks, measurements, skin texture and visible-feature descriptions; Treatment Journeys, simulations, preferences and notes; clinic-share records; clinic and post-treatment records; device, security, transaction, and consent records.',
    },
    {
      'title': '2. Sources and Roles',
      'body':
          'Sources include the user, device, selected or sponsoring clinic, service providers, and SkinSync-generated inferences. SkinSync may act directly for the consumer in one workflow and as a clinic’s HIPAA Business Associate in another. Records are classified and logically segregated by role, clinic tenant, patient, purpose, and authorization.',
    },
    {
      'title': '3. Purposes',
      'body':
          '• Create and secure accounts and authenticate users.\n• Collect user-authorized intake; process scans; generate and compare simulations and Treatment Journeys.\n• At the user’s direction, transmit the exact authorized report to a named clinic and provide a receipt.\n• Support clinic-directed intake, consultation, scheduling, communications, treatment documentation, and post-treatment follow-up.\n• Operate, debug, audit, secure, and improve reliability using data minimized for the task.\n• Comply with law, respond to rights requests, investigate incidents, and protect users and systems.',
    },
    {
      'title': '4. No Identifiable Training, Sale, or Health Advertising',
      'body':
          'SkinSync does not sell consumer health or biometric data, does not use it for cross-context behavioral advertising, and does not use identifiable health data, facial images, biometric information, or PHI for generalized or cross-customer AI training. Service providers may process minimum necessary information only for contracted services under appropriate restrictions.',
    },
    {
      'title': '5. Clinic Disclosures',
      'body':
          'For an independent consumer share, SkinSync displays the clinic legal identity, location, exact data manifest, purpose, expiration, and limitations before obtaining the required affirmative actions. Other private options are excluded. Clinic-connected disclosures may also occur for treatment, payment, health-care operations, or contracted services as permitted by HIPAA, the BAA, the clinic’s notice, and applicable law.',
    },
  ];

  final List<Map<String, String>> _retentionSchedule = const [
    {
      'category': 'Facial source images and biometric-derived data',
      'schedule':
          'Destroy when the disclosed purpose is satisfied or no later than three years after the last interaction, whichever occurs first, unless a shorter rule controls or lawful clinic retention applies.',
    },
    {
      'category': 'Private non-final simulations and journeys',
      'schedule':
          'Until user deletion or 24 months of inactivity after advance deletion notice, unless needed for an active request.',
    },
    {
      'category': 'Clinic-specific PHI',
      'schedule':
          'As directed by the clinic and BAA; export and deletion after termination subject to law, documented infeasibility, and backup cycle.',
    },
    {
      'category':
          'Consent, authorization, disclosure, and audit evidence',
      'schedule':
          'At least six years where HIPAA documentation rules apply; otherwise seven years or the longer period reasonably required to prove compliance.',
    },
    {
      'category': 'Security and access logs',
      'schedule':
          'Seven years unless risk analysis supports a different documented schedule.',
    },
    {
      'category': 'Backups',
      'schedule':
          'Isolated from ordinary use and overwritten within 90 days after primary deletion unless a documented legal or technical exception applies.',
    },
  ];

  final List<Map<String, String>> _remainingSections = const [
    {
      'title': '7. Security',
      'body':
          'SkinSync applies HIPAA-aligned safeguards to identifiable health and biometric data, including encryption in transit and at rest, MFA, least privilege, tenant and object-level access controls, logging, secure development, vulnerability management, backups, incident response, vendor review, workforce training, and sanctions.',
    },
    {
      'title': '8. Rights and Appeals',
      'body':
          'Subject to applicable law and exceptions, users may confirm processing; access, correct, download, or delete information; withdraw consent; obtain relevant recipient information; opt out of marketing, sale, targeted advertising, and qualifying profiling; and appeal a denial. Use in-app privacy controls or privacy@skinsyncai.com. SkinSync will apply the most protective reasonably applicable response standard and will not unlawfully discriminate.',
    },
    {
      'title': '9. HIPAA and Clinics',
      'body':
          'A record is PHI when it is created, received, maintained, or transmitted by a Covered Entity or by SkinSync on behalf of a Covered Entity or Business Associate. SkinSync’s decision to apply HIPAA-aligned safeguards to all health data does not represent that every consumer record is legally PHI. A clinic’s Notice of Privacy Practices governs its clinical record.',
    },
    {
      'title': '10. Adults Only; U.S. Service; Contact',
      'body':
          'The launch Platform is limited to U.S. adults age 18 or older. SkinSync does not knowingly permit minors in the launch workflow. Contact privacy@skinsyncai.com, 9 N. Wabash Avenue, Chicago, Illinois 60602, 312-847-2424.',
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
                  "PRIVACY POLICY",
                  style: CustomFonts.black30w600,
                ),
                SizedBox(height: context.h(8)),
                Text(
                  "Please review and accept our privacy practices before proceeding.",
                  style: CustomFonts.black18w400,
                ),
                SizedBox(height: context.h(24)),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sections 1 through 5
                        ..._privacySections.map(
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

                        // Section 6: Retention Table
                        Text(
                          '6. Retention',
                          style: CustomFonts.black18w600,
                        ),
                        SizedBox(height: context.h(8)),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(context.r(12)),
                            border: Border.all(
                              color: Colors.black.withValues(alpha: 0.1),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(context.r(12)),
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(1.2),
                                1: FlexColumnWidth(2.0),
                              },
                              border: TableBorder.symmetric(
                                inside: BorderSide(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  width: 1,
                                ),
                              ),
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: CustomColors.darkPurple
                                        .withValues(alpha: 0.1),
                                  ),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(context.w(10)),
                                      child: Text(
                                        'Category',
                                        style: CustomFonts.black14w600,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(context.w(10)),
                                      child: Text(
                                        'Baseline Schedule',
                                        style: CustomFonts.black14w600,
                                      ),
                                    ),
                                  ],
                                ),
                                ..._retentionSchedule.map(
                                  (item) => TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(context.w(10)),
                                        child: Text(
                                          item['category']!,
                                          style: CustomFonts.black14w600
                                              .copyWith(
                                            fontSize: context.sp(12),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(context.w(10)),
                                        child: Text(
                                          item['schedule']!,
                                          style: CustomFonts.black14w400
                                              .copyWith(
                                            fontSize: context.sp(12),
                                            color: Colors.black
                                                .withValues(alpha: 0.75),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: context.h(20)),

                        // Sections 7 through 10
                        ..._remainingSections.map(
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
                            "I have read, understood, and accept the privacy policy.",
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
                                MedicalDisclaimerScreen.routeName,
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