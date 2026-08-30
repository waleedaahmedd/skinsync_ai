import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/enums.dart';
import '../widgets/custom_button.dart';

class UpdateVersionScreen extends StatelessWidget {
  const UpdateVersionScreen({super.key});
  static const String routeName = '/UpdateVersionScreen';

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
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(20),
                  vertical: context.h(40),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: context.h(80)),
                    Image.asset(
                      PngAssets.splashLogo,
                      height: context.h(120),
                      width: context.w(120),
                    ),
                    SizedBox(height: context.h(40)),
                    Text(
                      "New Version Available!",
                      style: CustomFonts.black30w600,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.h(20)),
                    Text(
                      "To continue using Skinsync AI, please update to the latest version. This update includes important improvements and bug fixes.",
                      style: CustomFonts.grey18w400,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: () async {
                          final store = Platform.isAndroid
                              ? Store.play
                              : Store.appstore;
                          await launchUrl(Uri.parse(store.link));
                        },
                        text: "Update Now",
                      ),
                    ),
                    SizedBox(height: context.h(20)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
