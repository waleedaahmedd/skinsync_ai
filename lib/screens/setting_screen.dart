import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar:   AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
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
        title: Text("Settings",style: CustomFonts.black26w600,),
      ),
      body: Column(
        children: [
          Divider(color:CustomColors.greyColor),
          SizedBox(height: 32.h,),
          Padding(padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Iconsax.notification,size: 24.sp,color: Colors.black,),
                  SizedBox(width: 16.w,),
                  Text("Push Notifications Off",style: CustomFonts.black22w500,),
                  Spacer(),
                  CustomSizedSwitch()

                ],
              ),
              SizedBox(height: 37.h,),
              Row(
                children: [
                  SvgPicture.asset(
                    SvgAssets.authentication,
                    height: 24.h,
                    width: 24.w,
                  ),
                  
                  SizedBox(width: 16.w,),
                  Text("Two-Factor Authentication",style: CustomFonts.black22w500,),
                  Spacer(),
                  CustomSizedSwitch()

                ],
              ),
              SizedBox(height: 37.h,),
               Row(
                children: [
                   SvgPicture.asset(
                    SvgAssets.biometric,
                    height: 24.h,
                    width: 24.w,
                    color: Colors.black,
                  ),
                  SizedBox(width: 16.w,),
                  Text("Biometric Authentication",style: CustomFonts.black22w500,),
                 

                ],
              ),
              SizedBox(height: 37.h,),
               Row(
                children: [
                   SvgPicture.asset(
                    SvgAssets.card,
                    height: 24.h,
                    width: 24.w,
                  ),
                  SizedBox(width: 16.w,),
                  Text("Payments & Wallets",style: CustomFonts.black22w500,),
                 

                ],
              )
            ],
          ),),
        ],
      ),
    );
  }
}
class CustomSizedSwitch extends StatefulWidget {
  const CustomSizedSwitch({super.key});

  @override
  State<CustomSizedSwitch> createState() => _CustomSizedSwitchState();
}

class _CustomSizedSwitchState extends State<CustomSizedSwitch> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: SwitchTheme(
        data: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(Colors.white),
          trackColor: MaterialStateProperty.all(Colors.black),
          trackOutlineColor:
              MaterialStateProperty.all(Colors.transparent),
          materialTapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
        ),
        child: Switch(
          value: isOn,
          onChanged: (value) {
            setState(() {
              isOn = value;
            });
          },
        ),
      ),
    );
  }
}
