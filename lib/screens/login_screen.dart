import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 60),
              Text(
                'Your Journey',
                style: CustomFonts.black50w600,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'to ',
                    style: CustomFonts.black50w600,
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        CustomColors.lightBlueColor, // Light blue
                        CustomColors.lightPurpleColor, // Light pink
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: Text(
                      'Glowing Skin',
                      style: CustomFonts.white50w600,
                    ),
                  ),
                ],
              ),
              Text(
                'Starts Here!',
                style: CustomFonts.black50w600,
              ),
              SizedBox(height: 37.2.h),
              ElevatedButton(onPressed: () {}, child: Text("Get Started")),
            ],
          ),
        ),
      ),
    );
  }
}
