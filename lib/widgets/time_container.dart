import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

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
                  height: context.h(44.17),
                  width: context.w(175.72),
                 //padding: EdgeInsets.symmetric(horizontal: context.w(26),vertical: context.h(13)),
                  decoration: BoxDecoration(
                    color: isBooked? CustomColors.greyColor : isSelected ? Colors.green:null,
                    border: Border.all(width: context.w(0.63),color: isAvailable && !isSelected?  CustomColors.blackColor : Colors.transparent ),
                    borderRadius: BorderRadius.circular(context.r(10))
                  ),
                  child: Center(child: Text(time,style:isBooked? CustomFonts.grey15w400: isSelected? CustomFonts.white15w400:CustomFonts.black15w400
            )),
                ),
    );
  }
}