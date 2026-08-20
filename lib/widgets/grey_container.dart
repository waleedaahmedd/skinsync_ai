import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/color_constant.dart';

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
          borderRadius: shape != BoxShape.circle ? BorderRadius.circular(context.r(8)) : null,
        ),
        height: context.h(height),
        width:context.w(width),
      
        child: Icon(
         icon,
          color: Colors.black,
        ),
      ),
    );
  }
}
