import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class TreatmentsScreen extends StatelessWidget {
  const TreatmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 84.h,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.location,size: 20.sp, color: Colors.black,),
                SizedBox(width: 6.w,),
                Text("Hello, Burak!", style: CustomFonts.black30w600),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              "195 Karlie Brooks, Anderson",
              style: CustomFonts.grey18w400,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 30.0.w),
            child: Container(
              decoration: BoxDecoration(
                color: CustomColors.greyColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              height: 44.h,
              width: 44.w,

              child: Icon(
                Icons.notifications_none_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
body: Column(children: [
  Divider(color: CustomColors.greyColor,),
  Padding(padding: EdgeInsets.symmetric(horizontal: 30.w))
],),
    );
  }
}