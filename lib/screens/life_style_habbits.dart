import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utills/custom_fonts.dart';
import '../view_models/sign_up_onboarding_view_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/question_title.dart';

class LifeStyleHabbits extends StatelessWidget {
  const LifeStyleHabbits({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.h(33)),
          Text(
            'How would you describe your lifestyle and habits?',
            style: CustomFonts.black28w600,
          ),
          SizedBox(height: context.h(39)),

          // ⭐ FIX: Give ListView a height using Expanded
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return const QuestionTitle(
                  isSelected: false,
                  title: "Do you eat a balanced diet with plenty of water? ",
                );
              },
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
