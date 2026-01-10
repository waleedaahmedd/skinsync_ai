import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

class HomeTreamentCard extends StatelessWidget {
  const HomeTreamentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 310.w,
      child: Column(
        children: [
          Container(
            height: 160.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Image.asset(DummyAssets.treatmentimage, height: 160.h),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text("Botox Treatment", style: CustomFonts.black18w600),
              Spacer(),
              SvgPicture.asset(SvgAssets.mappin, height: 12.h, width: 12.w),
              SizedBox(width: 4.w),
              Text("Glow Skin Clinic", style: CustomFonts.grey14w400),
            ],
          ),
        ],
      ),
    );
  }
}