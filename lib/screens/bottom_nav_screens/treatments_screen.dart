import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

import '../../widgets/grey_container.dart';

class TreatmentsScreen extends StatefulWidget {
  const TreatmentsScreen({super.key});

  @override
  State<TreatmentsScreen> createState() => _TreatmentsScreenState();
}

class _TreatmentsScreenState extends State<TreatmentsScreen> {
  int selectedFilterIndex = 0;
  List<Fillter> fillter = [
    Fillter(title: "All Treatment"),
    Fillter(title: "Injectables & Fillers ", svg: SvgAssets.treatment),
    Fillter(title: "Laser Treatments", svg: SvgAssets.treatment),
    Fillter(title: "Sculpting & Contouring", svg: SvgAssets.treatment),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 84.h,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.location, size: 20.sp, color: Colors.black),
                SizedBox(width: 6.w),
                Text("Hello, Burak!", style: CustomFonts.black30w600),
              ],
            ),
            SizedBox(height: 2.h),
            Text("195 Karlie Brooks, Anderson", style: CustomFonts.grey18w400),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0.w),
            child: GreyContainer(icon:   Icons.notifications_none_outlined, onTap: () {
              // Handle notification tap
            },),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: CustomColors.greyColor),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  TextField(
                    style: CustomFonts.black18w400,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        size: 18.sp,
                        color: CustomColors.textGreyColor,
                      ),
                      hintText: "Search Here",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            SizedBox(
              height: 50.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fillter.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 30.w : 0,
                      right: 10.w,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilterIndex = index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: selectedFilterIndex == index
                              ? Colors.black
                              : CustomColors.greyColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                fillter[index].svg != null
                                    ? SvgPicture.asset(
                                        SvgAssets.treatment,
                                        height: 21.h,
                                        width: 21.w,
                                        colorFilter: ColorFilter.mode(
                                          selectedFilterIndex == index
                                              ? Colors.white
                                              : Colors.black,
                                          BlendMode.srcIn,
                                        ),
                                      )
                                    : SizedBox(),
                                fillter[index].svg != null
                                    ? SizedBox(width: 7.w)
                                    : SizedBox(),
                                Text(
                                  fillter[index].title,
                                  style: selectedFilterIndex == index
                                      ? CustomFonts.white17w500
                                      : CustomFonts.black16w400,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 32.h),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 30.0.w),
              child: Text(
                "Recommended Treatments",
                style: CustomFonts.black24w600,
              ),
            ),
            SizedBox(
              height: 352.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fillter.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 30.w : 0,
                      right: 20.w,
                      top: 28.h,
                      bottom: 25.h,
                    ),
                    child: Container(
                      height: 299.h,
                      width: 279.w,
                      padding: EdgeInsets.only(bottom: 20.w),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(PngAssets.laserTreatment),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.r),
                            color: Colors.transparent.withValues(alpha: 0.2),
                          ),
                          child: Text("Laser Treatment"),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Skincare & Facial Treatments",
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
            ),
            SizedBox(height: 13.h),
            SizedBox(
              height: 221.h,

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
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Injectables & Fillers ",
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
            ),
            SizedBox(height: 13.h),
            SizedBox(
              height: 221.h,

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
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Laser Treatments",
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
            ),
            SizedBox(height: 13.h),
            SizedBox(
              height: 221.h,

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
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sculpting & Contouring",
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
            ),
            SizedBox(height: 13.h),
            SizedBox(
              height: 221.h,

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
            SizedBox(height: 170.h,)
          ],
        ),
      ),
    );
  }
}

class Fillter {
  final String? svg;
  final String title;
  Fillter({required this.title, this.svg});
}
