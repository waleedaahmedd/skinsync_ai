import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';

class AppointmentDateWidget extends StatelessWidget {
  const AppointmentDateWidget({
    super.key, required this.day, required this.date,
  });
  final String day;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: context.w(12)),
                          decoration: BoxDecoration(
                            color: CustomColors.greyColor,
                            borderRadius: BorderRadius.circular(context.r(8)),
                          ),
                           padding: EdgeInsets.symmetric(horizontal: context.w(9), vertical: context.h(11)),
                        
                        
                          child: Column(
                            children: [
                              Text(day, style: CustomFonts.black14w600),
                                SizedBox(height: context.h(3),),
    
                              Text(date, style: CustomFonts.black22w600),
                            ],
                          ),
                        );
  }
}