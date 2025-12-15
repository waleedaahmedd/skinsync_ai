import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';

class SavedTreatmentScreen extends StatelessWidget {
  const SavedTreatmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showTitle: true,
        title: "Saved Treatments & Clinics",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: CustomColors.greyColor),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 22.h),

                /// HEADER ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your AI Treatment Model",
                      style: CustomFonts.black22w600,
                    ),
                    Container(
                      padding: EdgeInsets.all(7.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CustomColors.greyColor,
                      ),
                      child: Icon(
                        CupertinoIcons.arrow_right,
                        size: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
  ],
            ),
          ),
                SizedBox(height: 25.h),

                /// HORIZONTAL LIST (FIXED HEIGHT ✅)
                SizedBox(
                  height: 221.h,

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: index== 0 ? 30.w:0, right: 12.w),
                        child: Column(
                          children: [
                            Container(
                              width: 181.w,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                gradient: CustomColors.whitePurpleGradient,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                child: Image.asset(
                                  DummyAssets.doctorImage,
                                height: 164.h,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            SizedBox(
                              width: 181.w,
                              child: Text(
                                "AI Model Treatment Name",
                                style: CustomFonts.black18w600,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 31.h,),
              

            
          Divider(color: CustomColors.greyColor,),
          SizedBox(height: 31.h,),
          Padding(padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your AI Treatment Model",
                      style: CustomFonts.black22w600,
                    ),
                    Container(
                      padding: EdgeInsets.all(7.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CustomColors.greyColor,
                      ),
                      child: Icon(
                        CupertinoIcons.arrow_right,
                        size: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
            ],
          ),),
          SizedBox(height: 13.h,),
           SizedBox(
                  height: 221.h,

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: index== 0 ? 30.w:0, right: 12.w),
                        child: SizedBox(
      width: 310.w,
      child: Column(
        children: [
          Container(
            height: 160.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Image.asset(DummyAssets.treatmentimage, height: 160.h),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Botox Treatment", style: CustomFonts.black18w600),
                Text("October 20, 3:00 PM",style: CustomFonts.grey14w400,)
                ],
              ),
              Spacer(),
              SvgPicture.asset(SvgAssets.mappin, height: 12.h, width: 12.w),
              SizedBox(width: 4.w),
              Text("Glow Skin Clinic", style: CustomFonts.grey14w400),
            ],
          ),
        ],
      ),
    ),  
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
