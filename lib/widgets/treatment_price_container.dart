import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class TreatmentPriceContainer extends StatelessWidget {
  final String image;
  final String treatmentName;
  final int price;
  final bool  isSelected;
  final VoidCallback onTap;
  const TreatmentPriceContainer({super.key,required this.image,required this.treatmentName,required this.price,required this.isSelected,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:isSelected? CustomColors.lightPurpleColor.withValues(alpha: 0.2):Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color:isSelected? CustomColors.lightPurpleColor :CustomColors.greyColor,
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 48.h,
                          width: 48.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.r)),
                            image: DecorationImage(
                              image: AssetImage(image),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        SizedBox(width: 11.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              treatmentName,
                              style: CustomFonts.black14w700,
                            ),
                            SizedBox(height: 2.h),
                            Text("\$ $price", style: CustomFonts.red13w500),
                          ],
                        ),
                      ],
                    ),
                  ),
    );
  }
}