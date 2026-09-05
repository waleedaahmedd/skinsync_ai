import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/custom_button.dart';
import 'login_bottom_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});
  static const String routeName = '/GetStartedScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            gradient: CustomColors.blueWithWhiteGradient,
          ),
          child: Stack(
            children: [
              Positioned(
                top: context.h(70),
                right: context.w(0),
                left: context.w(0),
                child: Image.asset(
                  PngAssets.vector2,
                  height: context.h(552),
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: context.h(70),
                right: context.w(0),
                left: context.w(0),
                child: Image.asset(
                  PngAssets.vector,
                  height: context.h(376),
                  fit: BoxFit.fill,
                  color: const Color(0xff88E3FB).withValues(alpha: 0.7),
                ),
              ),
              Positioned(
                top: context.isLessThan(.md) ? context.h(92) : context.h(80),
                right: 0,
                left: 0,

                child: Image.asset(
                  PngAssets.faceAndMarks,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),
              // Positioned(
              //   top: context.h(215),
              //   left: context.w(0),
              //   right: context.w(0),
              //   child: Image.asset(
              //     PngAssets.faceMarks,
              //     height: context.w(300),
              //     fit: BoxFit.fitHeight,
              //   ),
              // ),
              Positioned(
                top: context.isLessThan(.md) ? context.h(432) : context.h(650),
                left: 0,
                right: 0,
                child: Image.asset(
                  PngAssets.blur,
                  fit: .fitWidth,
                  height: context.h(564),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(20),
                  vertical: context.h(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: context.h(60)),
                    Text("SkinSync AI", style: CustomFonts.grey20w500),
                    Text('Your Aesthetic', style: CustomFonts.black50w600),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        //Text('Journey ', style: CustomFonts.black50w600),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              CustomColors.lightBlueColor,
                              CustomColors.lightPurpleColor,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: Text(
                            'Journey Starts',
                            style: CustomFonts.white50w600,
                          ),
                        ),
                      ],
                    ),
                    Text('Here!', style: CustomFonts.black50w600),
                    SizedBox(height: context.h(37.2)),
                    SizedBox(
                      width: double.infinity,
                      child: Consumer(
                        builder: (_, ref, _) {
                          return CustomButton(
                            onPressed: () {
                              ref
                                  .read(authViewModel.notifier)
                                  .checkBiometricAvailability();
                              Navigator.pushNamed(
                                context,
                                LoginBottomScreen.routeName,
                              );
                            },
                            text: "Get Started",
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    } else {
                      final data = snapshot.data;
                      if (data == null) {
                        return const SizedBox.shrink();
                      }
                      return Align(
                        alignment: .topCenter,
                        child: Text(
                          '${data.version} (${data.buildNumber})',
                          style: CustomFonts.grey12w400,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
