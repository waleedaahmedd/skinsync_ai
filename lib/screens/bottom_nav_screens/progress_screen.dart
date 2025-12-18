import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

import '../../widgets/grey_container.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String selectedFilter = 'ongoing'; // 'completed' or 'ongoing'

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
      body: Column(
        children: [
          Divider(color: CustomColors.greyColor),
          SizedBox(height: 15.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFilter = 'completed';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 16.h,
                            horizontal: 38.w,
                          ),
                          decoration: BoxDecoration(
                            color: selectedFilter == 'completed'
                                ? Colors.black
                                : CustomColors.greyColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                SvgAssets.tick,
                                height: 18.h,
                                width: 18.w,
                                color: selectedFilter == 'completed'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              SizedBox(width: 7.w),
                              Text(
                                "Completed",
                                style: selectedFilter == 'completed'
                                    ? CustomFonts.white17w500
                                    : CustomFonts.black17w500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 11.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFilter = 'ongoing';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 16.h,
                            horizontal: 48.w,
                          ),
                          decoration: BoxDecoration(
                            color: selectedFilter == 'ongoing'
                                ? Colors.black
                                : CustomColors.greyColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  SvgAssets.progressfilled,
                                  height: 18.h,
                                  width: 18.w,
                                  color: selectedFilter == 'ongoing'
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                SizedBox(width: 7.w),
                                Text(
                                  "Ongoing",
                                  style: selectedFilter == 'ongoing'
                                      ? CustomFonts.white17w500
                                      : CustomFonts.black17w500,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 248.h,
                        width: 379.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(DummyAssets.treatmentimage),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 16.h,
                              right: 16.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.r),
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                child: Text(
                                  "Next Appointment In 4hrs",
                                  style: CustomFonts.white14w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 11.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dermal Fillers – Cheeks",
                            style: CustomFonts.black18w600,
                          ),

                          Row(
                            children: [
                              SvgPicture.asset(
                                SvgAssets.progressfilled,
                                color: CustomColors.lightBlueColor,
                                height: 18.h,
                                width: 18.w,
                              ),
                              SizedBox(width: 7.w,),
                              Text("28%", style: CustomFonts.black17w500),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h,),
                      Text("Glow Skin Clinic",style:CustomFonts.grey14w400,),
                       SizedBox(height: 1.h,),
                      Text("08 Sessions",style:CustomFonts.grey14w400,),
                      SizedBox(height: 22.h,)
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 70.h,)
        ],
      ),
    );
  }
}
