import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';

class RadioButtonWidget extends StatelessWidget {
   bool isSelected = false;
  RadioButtonWidget({super.key, required this.isSelected});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 29.h,
      width: 29.w,
      decoration: BoxDecoration(
        color: isSelected ? CustomColors.lightBlueColor : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ?CustomColors.lightBlueColor
              : CustomColors.lightBlueColor.withValues(alpha: 0.4),
          width: 3.w,
        ),
      ),
      child: Center(
        child: Container(
          height: 10.h,
          width: 10.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.white : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
