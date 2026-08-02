import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';
import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return   Container(
                        padding: EdgeInsets.symmetric(
                          vertical: context.h(13.29),
                          horizontal: context.w(15.51),
                        ),
                        height: context.h(150),
                        decoration: BoxDecoration(
                          color: CustomColors.lightBlueColor.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(context.r(15)),
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
                                      height: context.w(64),
                                      width: context.w(64),
                                    ),
                                  ),
                                ),
                                SizedBox(width: context.w(9)),
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
                            SizedBox(height: context.h(13.39)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: context.h(8.86),
                                horizontal: context.w(26),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(context.r(12)),
                                color: CustomColors.lightBlueColor.withValues(
                                  alpha: 0.5,
                                ),
                              ),

                              child: Row(
                                children: [
                                  Icon(
                                    Iconsax.calendar_2,
                                    color: Colors.black,
                                    size: context.sp(11),
                                  ),
                                  SizedBox(width: context.w(11.71)),
                                  Text(
                                    "Monday,july25",
                                    style: CustomFonts.black12w400,
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Iconsax.clock,
                                    size: 11,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: context.w(11.71)),
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