import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skinsync_ai/route_generator.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/auth_view_model.dart';
import 'package:skinsync_ai/widgets/phone_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool loginWithEmail = context.read<AuthViewModel>().loginWithEmail;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.iconColor,
              ),
              child: Icon(
                CupertinoIcons.arrow_left,
                size: 20.w,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.only(
          left: 30.w,
          right: 30.w,
          
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 43.h),
            Container(
              padding: EdgeInsets.all(14.w),
              height: 79.h, width: 79.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.lightBlueColor.withValues(alpha: 0.4),
              ),
            child: Image.asset(PngAssets.email, height: 50.h, width: 50.w)),
            SizedBox(height: 27.h),
            Text(
              loginWithEmail ? "Continue with Email" : "Continue with Phone",
              style: CustomFonts.black30w600,
            ),
            SizedBox(height: 4.h),
            Text(
              "Sign in or sign up with your email.",
              style: CustomFonts.grey18w400,
            ),
            SizedBox(height: 22.h),
            loginWithEmail
                ? TextField(
                    style: TextStyle(color: CustomColors.blackColor),
                    decoration: InputDecoration(hintText: "Email Address"),
                  )
                : PhoneWidget(
                    controller: context.read<AuthViewModel>().phoneController,
                    filled: true,
                  ),
            
           
           
          ],
        ),
      ),
      bottomNavigationBar: Padding(padding: EdgeInsets.all(30.w),
      child:    SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, otpScreen);
              }, child: Text("Next")),
            ),),
    );
  }
}
