import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';

class RadioButtonWidget extends StatefulWidget {
  RadioButtonWidget({super.key});
  bool isSelected = false;
  @override
  State<RadioButtonWidget> createState() => _RadioButtonWidgetState();
}

class _RadioButtonWidgetState extends State<RadioButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
      },
      child: Container(
        height: 29.h,
        width: 29.w,
        decoration: BoxDecoration(
          color: widget.isSelected ? CustomColors.lightBlueColor : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.isSelected
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
              color: widget.isSelected ? Colors.white : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
