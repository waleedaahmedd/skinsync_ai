import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/svg.dart';
import '../utills/assets.dart';
import '../utills/custom_fonts.dart';

class HomeTreamentCard extends StatelessWidget {

  const HomeTreamentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w(310),
      child: Column(
        children: [
          Container(
            height: context.h(160),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.r(10)),
            ),
            child: Image.asset(DummyAssets.treatmentimage, height: context.h(160)),
          ),
          SizedBox(height: context.h(8)),
          Row(
            children: [
              Text("Botox Treatment", style: CustomFonts.black18w600),
              const Spacer(),
              SvgPicture.asset(SvgAssets.mappin, height: context.h(12), width: context.w(12)),
              SizedBox(width: context.w(4)),
              Text("Glow Skin Clinic", style: CustomFonts.grey14w400),
            ],
          ),
        ],
      ),
    );
  }
}