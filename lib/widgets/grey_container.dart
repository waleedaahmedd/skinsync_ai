import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/color_constant.dart';

class GreyContainer extends StatelessWidget {
  const GreyContainer({
    super.key,  this.shape = BoxShape.rectangle, this.height = 44, this.width = 44, required this.icon, required this.onTap,
    
  });
  final BoxShape shape;
  final VoidCallback onTap;
  final double height;  final double width; final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: shape,
          color: CustomColors.greyColor,
          borderRadius: shape != BoxShape.circle ? BorderRadius.circular(8.r) : null,
        ),
        height: height.h,
        width: width.w,
      
        child: Icon(
         icon,
          color: Colors.black,
        ),
      ),
    );
  }
}
