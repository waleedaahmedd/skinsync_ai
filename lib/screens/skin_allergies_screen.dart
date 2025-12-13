import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/sign_up_onboarding_view_model.dart';
import 'package:skinsync_ai/widgets/question_title.dart';
import 'package:skinsync_ai/widgets/radio_button_widget.dart';

class SkinAllergiesScreen extends StatelessWidget {
  const SkinAllergiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 33.h),
          Text(
            'Have you been diagnosed with any skin conditions or allergies?',
            style: CustomFonts.black28w600,
          ),
          SizedBox(height: 39.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Container(
                        height: 118.h,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(DummyAssets.acen),
                          ),
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Center(
                        child: Text("Acne", style: CustomFonts.black18w600),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Container(
                        height: 118.h,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(DummyAssets.acen),
                          ),
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Center(
                        child: Text("Acne", style: CustomFonts.black18w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Container(
                        height: 118.h,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(DummyAssets.acen),
                          ),
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Center(
                        child: Text("Acne", style: CustomFonts.black18w600),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Container(
                        height: 118.h,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(DummyAssets.acen),
                          ),
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Center(
                        child: Text("Acne", style: CustomFonts.black18w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          QuestionTitle(title: "None of the above "),
          SizedBox(height: 40.h),
          Text(
            "Are you currently using any medications or treatments for your skin? ",
            style: CustomFonts.black28w600,
          ),
          SizedBox(height: 13.h),
          Row(
            children: [
              RadioButtonWidget(),
              SizedBox(width: 13.w),
              Text("Yes ( Please Specify)", style: CustomFonts.black18w600),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              RadioButtonWidget(),
              SizedBox(width: 13.w),
              Text("No", style: CustomFonts.black18w600),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<SignUpOnboardingViewModel>().skipOnboarding(
                  context,
                );
              },
              child: Text("Next"),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
