import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class AppointmentDateWidget extends StatelessWidget {
  const AppointmentDateWidget({
    super.key, required this.day, required this.date,
  });
  final String day;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 12.w),
                          decoration: BoxDecoration(
                            color: CustomColors.greyColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                           padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 11.h),
                        
                        
                          child: Column(
                            children: [
                              Text(day, style: CustomFonts.black14w600),
                                SizedBox(height: 3.h,),
    
                              Text(date, style: CustomFonts.black22w600),
                            ],
                          ),
                        );
  }
}