import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';
import 'package:skinsync_ai/widgets/heading_with_right_arrow.dart';

class SavedTreatmentScreen extends StatelessWidget {
  const SavedTreatmentScreen({super.key});
  static const String routeName = '/SavedTreatmentScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          "Saved Treatments & Clinics",
          style: CustomFonts.black26w600,
        ),
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
            height: 217.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 30.w : 0,
                    right: 12.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 181.w,
                        height: 174.h,
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
                        width: 150.w,
                        height: 37.h,
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
          SizedBox(height: 30.h),

          Divider(height: 0, color: CustomColors.greyColor),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: HeadingWithRightArrow(
              title: "Your AI Treatment Model",
              onTap: () {},
            ),
          ),
          SizedBox(height: 13.h),
          SizedBox(
            height: 213.h,

            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 30.w : 0,
                    right: 12.w,
                  ),
                  child: SizedBox(
                    width: 310.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 160.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Image.asset(
                            DummyAssets.treatmentimage,
                            height: 160.h,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Botox Treatment",
                                  style: CustomFonts.black18w600,
                                ),
                                Text(
                                  "October 20, 3:00 PM",
                                  style: CustomFonts.grey14w400,
                                ),
                              ],
                            ),
                            Spacer(),
                            SvgPicture.asset(
                              SvgAssets.mappin,
                              height: 12.h,
                              width: 12.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Glow Skin Clinic",
                              style: CustomFonts.grey14w400,
                            ),
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
