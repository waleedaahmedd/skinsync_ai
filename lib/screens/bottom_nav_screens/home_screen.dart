import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

import '../../utills/color_constant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(child: Column(children: [AppbarWidget( showIcon: false,
        
        ),
        SizedBox(height: 44.h,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30.w),
            
            height: 150.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              gradient: CustomColors.purpleBlueGradient,)),
        SizedBox(height: 44.h,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30.w),
            
            height: 150.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              gradient: CustomColors.purpleBlueGradient,)),
        SizedBox(height: 44.h,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30.w),
            
            height: 150.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              gradient: CustomColors.purpleBlueGradient,)),
        SizedBox(height: 44.h,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30.w),
            
            height: 150.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              gradient: CustomColors.purpleBlueGradient,)),
        SizedBox(height: 44.h,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30.w),
            
            height: 150.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              gradient: CustomColors.purpleBlueGradient,)),
        SizedBox(height: 44.h,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30.w),
            
            height: 150.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              gradient: CustomColors.purpleBlueGradient,)),
        SizedBox(height: 44.h,),
        ])),
      ),
    );
  }
}

class AppbarWidget extends StatelessWidget {
  final bool showIcon;
  const AppbarWidget({super.key, this.showIcon = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  showIcon
                      ? Icon(
                          Icons.location_on_outlined,
                          color: CustomColors.blackColor,
                        )
                      : SizedBox.shrink(),
                  showIcon ? SizedBox(width: 8.w) : SizedBox.shrink(),
                  Text("New York", style: CustomFonts.black30w600),
                ],
              ),
              Text(
                "195 Karlie Brooks, Anderson",
                style: CustomFonts.black18w400,
              ),
            ],
          ),
          Spacer(),
          SvgPicture.asset(SvgAssets.notification),
        ],
      ),
    );
  }
}
