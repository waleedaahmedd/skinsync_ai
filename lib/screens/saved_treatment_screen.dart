import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/heading_with_right_arrow.dart';

class SavedTreatmentScreen extends StatelessWidget {
  const SavedTreatmentScreen({super.key});
  static const String routeName = '/SavedTreatmentScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        showTitle: true,
        title: "Saved Treatments",
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: CustomColors.greyColor.withValues(alpha: 0.6), height: 1.h),
            SizedBox(height: 24.h),

            // Section 1: AI Model Treatment Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your AI Treatment Models",
                        style: CustomFonts.black20w600,
                      ),
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CustomColors.greyColor.withValues(alpha: 0.6),
                        ),
                        child: Icon(
                          CupertinoIcons.arrow_right,
                          size: 14.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Horizontal AI Models list
            SizedBox(
              height: 225.h,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 24.w : 0,
                      right: 12.w,
                    ),
                    child: Container(
                      width: 170.w,
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: CustomColors.greyColor.withValues(alpha: 0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.015),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14.r),
                            child: Image.asset(
                              DummyAssets.doctorImage,
                              height: 125.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Expanded(
                            child: Text(
                              "AI Model Session",
                              style: CustomFonts.black13w600,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Divider(color: Colors.grey.shade100, height: 1.h),
            ),
            SizedBox(height: 24.h),

            // Section 2: Clinical Treatment List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: HeadingWithRightArrow(
                title: "Your Saved Clinics & Treatments",
                onTap: () {},
              ),
            ),
            SizedBox(height: 16.h),

            // Saved Clinics List
            SizedBox(
              height: 220.h,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 24.w : 0,
                      right: 12.w,
                    ),
                    child: Container(
                      width: 290.w,
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: CustomColors.greyColor.withValues(alpha: 0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.015),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14.r),
                            child: Image.asset(
                              DummyAssets.treatmentimage,
                              height: 120.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Botox Treatment",
                                      style: CustomFonts.black13w600,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      "October 20, 3:00 PM",
                                      style: CustomFonts.grey700_10w400,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    SvgAssets.mappin,
                                    height: 11.h,
                                    width: 11.w,
                                    colorFilter: const ColorFilter.mode(
                                      CustomColors.pinkColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Glow Clinic",
                                    style: CustomFonts.pink10w700,
                                  ),
                                ],
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
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}