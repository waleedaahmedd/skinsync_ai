import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/svg.dart';
import '../screens/progress_detail_screen.dart';
import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, ProgressDetailScreen.routeName);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: context.h(248),
            width: context.w(379),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(DummyAssets.treatmentimage),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(context.r(10)),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: context.h(16),
                  right: context.w(16),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(12),
                      vertical: context.h(8),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.r(50)),
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                    child: Text(
                      "Next Appointment In 4hrs",
                      style: CustomFonts.white14w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.h(11)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Dermal Fillers – Cheeks", style: CustomFonts.black18w600),
      
              Row(
                children: [
                  SvgPicture.asset(
                    SvgAssets.progressfilled,
                    colorFilter: const ColorFilter.mode(
                      CustomColors.lightBlueColor,
                      BlendMode.srcIn,
                    ),
                    height: context.h(18),
                    width: context.w(18),
                  ),
                  SizedBox(width: context.w(7)),
                  Text("28%", style: CustomFonts.black17w500),
                ],
              ),
            ],
          ),
          SizedBox(height: context.h(4)),
          Text("Glow Skin Clinic", style: CustomFonts.grey14w400),
          SizedBox(height: context.h(1)),
          Text("08 Sessions", style: CustomFonts.grey14w400),
          SizedBox(height: context.h(22)),
        ],
      ),
    );
  }
}
