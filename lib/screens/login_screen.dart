import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
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
      body: Padding(
        padding: EdgeInsetsGeometry.only(left: 30.w,right: 30.w,bottom: MediaQuery.viewInsetsOf(context).bottom,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 43.h),
            SvgPicture.asset(SvgAssets.email, height: 79.h, width: 79.w),
            SizedBox(height: 27.h),
            Text("Continue with Email", style: CustomFonts.black30w600),
            SizedBox(height: 4.h),
            Text(
              "Sign in or sign up with your email.",
              style: CustomFonts.grey18w400,
            ),
            SizedBox(height: 22.h),
            TextField(
               style: TextStyle(color:CustomColors.blackColor),
              decoration:InputDecoration(
                
                hintText: "Email Address",
              )
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: (){}, child: Text("Next"))),
              SizedBox(height: 20.h,),
          ],
        ),
      ),
    );
  }
}
