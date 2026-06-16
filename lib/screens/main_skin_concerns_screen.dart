import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utills/custom_fonts.dart';
import '../view_models/sign_up_onboarding_view_model.dart';
import '../widgets/question_title.dart';

class MainSkinConcernsScreen extends StatelessWidget {
  const MainSkinConcernsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 33.h),
          Text(
            'What are your main skin concerns? (Select all that apply)',
            style: CustomFonts.black28w600,
          ),
          SizedBox(height: 39.h),

          // ⭐ FIX: Give ListView a height using Expanded
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return QuestionTitle(isSelected: false,title: "Dark spots or pigmentation ");
              },
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: Consumer(
              builder: (_, ref, _) {
                return ElevatedButton(
                  onPressed: () {
                    ref
                        .read(onBoardingViewModel.notifier)
                        .onNextButton(context);
                  },
                  child: const Text("Next"),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
