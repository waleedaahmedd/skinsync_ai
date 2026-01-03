import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/widgets/custom_app_bar.dart';

class TreatmentReceiptsScreen extends StatelessWidget {
  const TreatmentReceiptsScreen({super.key});
  static const routeName = "/TreatmentReceiptsScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Treatment Receipts", style: CustomFonts.black26w600),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            SizedBox(height: 32.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 21.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: CustomColors.greyColor, width: 1.w),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Receipt ID #51581521",
                        style: CustomFonts.black22w600,
                      ),
                      Spacer(),
                      Icon(Iconsax.eye, color: Colors.black, size: 20.sp),
                      SizedBox(width: 21.w),
                      Icon(Iconsax.import_1, color: Colors.black, size: 20.sp),
                    ],
                  ),
                  SizedBox(height: 18),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 15.h,
                    ),
                    decoration: BoxDecoration(
                      color: CustomColors.lightBlueColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("For", style: CustomFonts.grey14w400),
                            SizedBox(height: 5.h),
                            Text(
                              "Derma Fillers - Cheeks",
                              style: CustomFonts.black16w600,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
