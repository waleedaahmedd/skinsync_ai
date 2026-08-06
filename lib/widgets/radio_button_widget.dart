import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utills/color_constant.dart';

class RadioButtonWidget extends StatelessWidget {
  final bool isSelected;
  const RadioButtonWidget({super.key, required this.isSelected});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.h(29),
      width: context.w(29),
      decoration: BoxDecoration(
        color: isSelected ? CustomColors.lightBlueColor : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ?CustomColors.lightBlueColor
              : CustomColors.lightBlueColor.withValues(alpha: 0.4),
          width: context.w(3),
        ),
      ),
      child: Center(
        child: Container(
          height: context.h(10),
          width: context.w(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.white : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
