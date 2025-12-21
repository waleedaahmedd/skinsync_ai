import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class TimeContainer extends StatelessWidget {
  final bool isBooked;
  final bool isAvailable;
  final bool isSelected;
  final String time;
  final VoidCallback onTap;
  const TimeContainer({super.key, required this.onTap,required this.time,required this.isAvailable,required this.isBooked,required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ,
      child: Container(
                  height: 44.17.h,
                  width: 175.72.w,
                 //padding: EdgeInsets.symmetric(horizontal: 26.w,vertical: 13.h),
                  decoration: BoxDecoration(
                    color: isBooked? CustomColors.greyColor : isSelected ? Colors.green:null,
                    border: Border.all(width: 0.63.w,color: isAvailable && !isSelected?  CustomColors.blackColor : Colors.transparent ),
                    borderRadius: BorderRadius.circular(10.r)
                  ),
                  child: Center(child: Text(time,style:isBooked? CustomFonts.grey15w400: isSelected? CustomFonts.white15w400:CustomFonts.black15w400
            )),
                ),
    );
  }
}