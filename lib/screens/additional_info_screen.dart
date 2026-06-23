import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'payment_screen.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../widgets/radio_button_widget.dart';

class AdditionalInfoScreen extends StatelessWidget {
  const AdditionalInfoScreen({super.key});
  static const String routeName = '/AdditionalInfoScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: CustomColors.blueWhitePurpleGradient,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -100.h,
              child: Image.asset(
                PngAssets.signupVector,
                height: 201.h,
                colorBlendMode: BlendMode.dstOver,
                fit: BoxFit.fitWidth,
                color: CustomColors.lightBlueColor.withValues(alpha: 0.2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    SizedBox(height: 68.h),
                    Text(
                      "Please Provide The Additional Information Needed To Send To Your Injector.",
                      style: CustomFonts.black28w600,
                    ),
                    SizedBox(height: 28.h),
                    const Divider(color: CustomColors.greyColor, height: 0),
                    SizedBox(height: 24.h),
                    Text("Do you smoke ?", style: CustomFonts.black26w600),
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        RadioButtonWidget(isSelected: false),
                        SizedBox(width: 13.w),
                        Text("Yes", style: CustomFonts.black18w600),
                        SizedBox(height: 35.h),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        RadioButtonWidget(isSelected: false),
                        SizedBox(width: 13.w),
                        Text("No", style: CustomFonts.black18w600),
                        SizedBox(height: 37.h),
                      ],
                    ),
                    SizedBox(height: 35.h),
                    Text(
                      "Previous Aesthetic treatments? Please Specify (Botox, Fillers, Laser, Microneedling)",
                      style: CustomFonts.black26w600,
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        RadioButtonWidget(isSelected: false),
                        SizedBox(width: 13.w),
                        Text("Yes", style: CustomFonts.black18w600),
                        SizedBox(height: 35.h),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        RadioButtonWidget(isSelected: false),
                        SizedBox(width: 13.w),
                        Text("No", style: CustomFonts.black18w600),
                        SizedBox(height: 35.h),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 20.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Describe The Medications Your Using Currently",
                            style: CustomFonts.black16w500,
                          ),

                          TextField(
                            style: CustomFonts.black18w400,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35.h),
                    Text(
                      "Do You Have Any Allergies to Lidocaine Or Other Anesthetics?",
                      style: CustomFonts.black26w600,
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        RadioButtonWidget(isSelected: false),
                        SizedBox(width: 13.w),
                        Text("Yes", style: CustomFonts.black18w600),
                        SizedBox(height: 35.h),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        RadioButtonWidget(isSelected: false),
                        SizedBox(width: 13.w),
                        Text("No", style: CustomFonts.black18w600),
                        SizedBox(height: 35.h),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 20.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Describe The Medications Your Using Currently",
                            style: CustomFonts.black16w500,
                          ),

                          TextField(
                            style: CustomFonts.black18w400,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            PaymentScreen.routeName,
                          );
                        },
                        child: const Text("Submit Now"),
                      ),
                    ),
                    SizedBox(height: 19.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            PaymentScreen.routeName,
                          );
                        },
                        child: Text(
                          "Not Now",
                          style: CustomFonts.black22w600Underline,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35.h + MediaQuery.paddingOf(context).bottom,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
