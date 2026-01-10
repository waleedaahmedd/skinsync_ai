import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return   Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 13.29.h,
                          horizontal: 15.51.w,
                        ),
                        height: 150.h,
                        decoration: BoxDecoration(
                          color: CustomColors.lightBlueColor.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child: Center(
                                    child: Image.asset(
                                      DummyAssets.acen,
                                      fit: BoxFit.cover,
                                      height: 64.w,
                                      width: 64.w,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 9.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Botox Treatment",
                                      style: CustomFonts.black18w600,
                                    ),
                                    Text(
                                      "Glow Skin Clinic",
                                      style: CustomFonts.grey14w400,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 13.39.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.86.h,
                                horizontal: 26.w,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: CustomColors.lightBlueColor.withValues(
                                  alpha: 0.5,
                                ),
                              ),

                              child: Row(
                                children: [
                                  Icon(
                                    Iconsax.calendar_2,
                                    color: Colors.black,
                                    size: 11.sp,
                                  ),
                                  SizedBox(width: 11.71.w),
                                  Text(
                                    "Monday,july25",
                                    style: CustomFonts.black12w400,
                                  ),
                                  Spacer(),
                                  Icon(
                                    Iconsax.clock,
                                    size: 11,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 11.71.w),
                                  Text(
                                    "10:30 am - 12:30 pm",
                                    style: CustomFonts.black12w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    
  }
}