import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../widgets/custom_button.dart';
import 'get_notified_screen.dart';

class MedicalDisclaimerScreen extends StatefulWidget {
  const MedicalDisclaimerScreen({super.key});
  static const String routeName = '/MedicalDisclaimerScreen';

  @override
  State<MedicalDisclaimerScreen> createState() =>
      _MedicalDisclaimerScreenState();
}

class _MedicalDisclaimerScreenState extends State<MedicalDisclaimerScreen> {
  bool _isAccepted = false;

  final List<Map<String, String>> _disclaimerSections = const [
    {
      'title': '1. Technology Only',
      'body':
          'SkinSync is a technology and visualization platform. It does not provide medical advice, diagnosis, prescription, treatment, or emergency services. Outputs support—but do not replace—a conversation with a qualified licensed professional.',
    },
    {
      'title': '2. Illustrative, Not Predictive',
      'body':
          'A simulation is not a forecast, guarantee, before-and-after claim, or clinical photograph of an expected result. Outcomes vary based on anatomy, health, technique, product, dose, healing, lighting, image quality, and other factors.',
    },
    {
      'title': '3. Independent Clinical Review',
      'body':
          'Only an appropriately licensed provider who evaluates the patient may determine candidacy, contraindications, diagnosis, treatment plan, risks, alternatives, informed consent, pricing, follow-up, and care. A clinic may modify or decline any Treatment Journey.',
    },
    {
      'title': '4. No Emergencies',
      'body':
          'Do not use SkinSync for emergencies. Call 911 or local emergency services for an emergency and seek prompt professional care for severe pain, infection signs, breathing difficulty, vision changes, allergic reactions, or other concerning symptoms.',
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
                  "MEDICAL DISCLAIMER",
                  style: CustomFonts.black30w600,
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
                        ..._disclaimerSections.map(
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
                            "I have read, understood, and accept the medical disclaimer.",
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
                                GetNotifiedScreen.routeName,
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