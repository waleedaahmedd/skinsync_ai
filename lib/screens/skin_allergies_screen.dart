import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/assets.dart';
import '../utils/custom_fonts.dart';
import '../view_models/sign_up_onboarding_view_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/question_title.dart';
import '../widgets/radio_button_widget.dart';

class SkinAllergiesScreen extends StatelessWidget {
  const SkinAllergiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(30)),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.h(33)),
                    Text(
                      'Have you been diagnosed with any skin conditions or allergies?',
                      style: CustomFonts.black28w600,
                    ),
                    SizedBox(height: context.h(39)),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(context.w(8)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                context.r(15),
                              ),
                            ),
                            margin: EdgeInsets.zero,
                            child: Column(
                              children: [
                                Container(
                                  height: context.h(118),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      context.r(15),
                                    ),
                                    image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(DummyAssets.acen),
                                    ),
                                  ),
                                ),
                                SizedBox(height: context.h(7)),
                                Center(
                                  child: Text(
                                    "Acne",
                                    style: CustomFonts.black18w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: context.w(10)),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(context.w(8)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                context.r(15),
                              ),
                            ),
                            margin: EdgeInsets.zero,
                            child: Column(
                              children: [
                                Container(
                                  height: context.h(118),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      context.r(15),
                                    ),
                                    image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(DummyAssets.acen),
                                    ),
                                  ),
                                ),
                                SizedBox(height: context.h(7)),
                                Center(
                                  child: Text(
                                    "Acne",
                                    style: CustomFonts.black18w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(10)),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(context.w(8)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                context.r(15),
                              ),
                            ),
                            margin: EdgeInsets.zero,
                            child: Column(
                              children: [
                                Container(
                                  height: context.h(118),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      context.r(15),
                                    ),
                                    image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(DummyAssets.acen),
                                    ),
                                  ),
                                ),
                                SizedBox(height: context.h(7)),
                                Center(
                                  child: Text(
                                    "Acne",
                                    style: CustomFonts.black18w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: context.w(10)),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(context.w(8)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                context.r(15),
                              ),
                            ),
                            margin: EdgeInsets.zero,
                            child: Column(
                              children: [
                                Container(
                                  height: context.h(118),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      context.r(15),
                                    ),
                                    image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(DummyAssets.acen),
                                    ),
                                  ),
                                ),
                                SizedBox(height: context.h(7)),
                                Center(
                                  child: Text(
                                    "Acne",
                                    style: CustomFonts.black18w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(14)),
                    const QuestionTitle(
                      title: "None of the above ",
                      isSelected: false,
                    ),
                    SizedBox(height: context.h(40)),
                    Text(
                      "Are you currently using any medications or treatments for your skin? ",
                      style: CustomFonts.black28w600,
                    ),
                    SizedBox(height: context.h(13)),
                    Row(
                      children: [
                        const RadioButtonWidget(isSelected: false),
                        SizedBox(width: context.w(13)),
                        Text(
                          "Yes ( Please Specify)",
                          style: CustomFonts.black18w600,
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(18)),
                    Row(
                      children: [
                        const RadioButtonWidget(isSelected: false),
                        SizedBox(width: context.w(13)),
                        Text("No", style: CustomFonts.black18w600),
                      ],
                    ),
                    SizedBox(height: context.h(20)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: context.h(20)),
          SizedBox(
            width: double.infinity,
            child: Consumer(
              builder: (_, ref, _) {
                return CustomButton(
                  onPressed: () {
                    ref
                        .read(onBoardingViewModel.notifier)
                        .onNextButton(context);
                  },
                  text: "Next",
                );
              },
            ),
          ),
          SizedBox(height: context.h(20)),
        ],
      ),
    );
  }
}
