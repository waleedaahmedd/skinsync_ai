import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'treatment_payment_screen.dart';
import '../widgets/custom_button.dart';
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
              top: -context.h(100),
              child: Image.asset(
                PngAssets.signupVector,
                height: context.h(201),
                colorBlendMode: BlendMode.dstOver,
                fit: BoxFit.fitWidth,
                color: CustomColors.lightBlueColor.withValues(alpha: 0.2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(30.0)),
              child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    SizedBox(height: context.h(68)),
                    Text(
                      "Please Provide The Additional Information Needed To Send To Your Injector.",
                      style: CustomFonts.black28w600,
                    ),
                    SizedBox(height: context.h(28)),
                    const Divider(color: CustomColors.greyColor, height: 0),
                    SizedBox(height: context.h(24)),
                    Text("Do you smoke ?", style: CustomFonts.black26w600),
                    SizedBox(height: context.h(18)),
                    Row(
                      children: [
                        const RadioButtonWidget(isSelected: false),
                        SizedBox(width: context.w(13)),
                        Text("Yes", style: CustomFonts.black18w600),
                        SizedBox(height: context.h(35)),
                      ],
                    ),
                    SizedBox(height: context.h(16)),
                    Row(
                      children: [
                        const RadioButtonWidget(isSelected: false),
                        SizedBox(width: context.w(13)),
                        Text("No", style: CustomFonts.black18w600),
                        SizedBox(height: context.h(37)),
                      ],
                    ),
                    SizedBox(height: context.h(35)),
                    Text(
                      "Previous Aesthetic treatments? Please Specify (Botox, Fillers, Laser, Microneedling)",
                      style: CustomFonts.black26w600,
                    ),
                    SizedBox(height: context.h(18)),
                    Row(
                      children: [
                        const RadioButtonWidget(isSelected: false),
                        SizedBox(width: context.w(13)),
                        Text("Yes", style: CustomFonts.black18w600),
                        SizedBox(height: context.h(35)),
                      ],
                    ),
                    SizedBox(height: context.h(16)),
                    Row(
                      children: [
                        const RadioButtonWidget(isSelected: false),
                        SizedBox(width: context.w(13)),
                        Text("No", style: CustomFonts.black18w600),
                        SizedBox(height: context.h(35)),
                      ],
                    ),
                    SizedBox(height: context.h(16)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: context.h(16),
                        horizontal: context.w(20),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(context.r(10)),
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
                    SizedBox(height: context.h(35)),
                    Text(
                      "Do You Have Any Allergies to Lidocaine Or Other Anesthetics?",
                      style: CustomFonts.black26w600,
                    ),
                    SizedBox(height: context.h(18)),
                    Row(
                      children: [
                        const RadioButtonWidget(isSelected: false),
                        SizedBox(width: context.w(13)),
                        Text("Yes", style: CustomFonts.black18w600),
                        SizedBox(height: context.h(35)),
                      ],
                    ),
                    SizedBox(height: context.h(16)),
                    Row(
                      children: [
                        const RadioButtonWidget(isSelected: false),
                        SizedBox(width: context.w(13)),
                        Text("No", style: CustomFonts.black18w600),
                        SizedBox(height: context.h(35)),
                      ],
                    ),
                    SizedBox(height: context.h(16)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: context.h(16),
                        horizontal: context.w(20),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(context.r(10)),
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
                    SizedBox(height: context.h(25)),
                    CustomButton(
                      text: "Submit Now",
                      borderRadius: context.r(25),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          TreatmentPaymentScreen.routeName,
                        );
                      },
                    ),
                    SizedBox(height: context.h(19)),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            TreatmentPaymentScreen.routeName,
                          );
                        },
                        child: Text(
                          "Not Now",
                          style: CustomFonts.black22w600Underline,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: context.h(35) + MediaQuery.paddingOf(context).bottom,
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
