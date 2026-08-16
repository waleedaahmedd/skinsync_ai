import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../utils/assets.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1FAFE), // Soft luxury pastel blue/grey
        borderRadius: BorderRadius.circular(context.r(20)),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.08),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      height: context.h(144),
      width: context.w(360), // Slightly adjusted width for better fitting on smaller screen widths
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.r(20)),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(context.w(16), context.h(16), context.w(12), context.h(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Botox Treatment",
                          style: CustomFonts.black16w600,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: context.h(2)),
                        Text(
                          "Glow Skin Clinic",
                          style: CustomFonts.grey700_10w400,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: context.w(10), vertical: context.h(4)),
                      decoration: BoxDecoration(
                        color: CustomColors.pinkColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(context.r(20)),
                      ),
                      child: Text(
                        "20% Off",
                        style: CustomFonts.pink10w700,
                      ),
                    ),
                    Text(
                      "Valid Till 30 March",
                      style: CustomFonts.grey700_10w400,
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(context.r(20))),
                  child: Image.asset(
                    DummyAssets.treatmentimage,
                    width: context.w(150),
                    height: context.h(144),
                    fit: BoxFit.cover,
                  ),
                ),
                // Dark Gradient overlay on image side to blend it back into background
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFF1FAFE), // Blend image edge back into card background
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: context.h(12),
                  right: context.w(12),
                  child: Container(
                    height: context.w(40),
                    width: context.w(40),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: CustomColors.pinkColor,
                    ),
                    child: Center(
                      child: Text(
                        "20%\nOFF",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: context.sp(10),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Degular',
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
