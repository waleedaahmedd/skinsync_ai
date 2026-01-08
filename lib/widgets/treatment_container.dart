import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_ai/screens/bottom_nav_screens/face_detection_screen.dart';
import 'package:skinsync_ai/screens/treatment_detail_screen.dart';
import 'package:skinsync_ai/screens/select_sections_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';

import '../models/dummy_list_model.dart';
import '../models/responses/treatment_response_model.dart';
import '../view_models/checkout_view_model.dart';

class TreatmentContainer extends StatelessWidget {
  final TreatmentsModel treatments;
  const TreatmentContainer({super.key, required this.treatments});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return GestureDetector(
          onTap: () {
            if (treatments.isArea == true) {
               ref
                  .read(checkoutViewModel.notifier)
                  .updateState(treatmentId: treatments.id);
              ref
                  .read(treatmentViewModel.notifier)
                  .getSelectSectionApi(sectionId: treatments.id ?? 0);
              ref.read(treatmentViewModel.notifier).treatmentId = treatments.id;
              Navigator.pushNamed(context, SelectSectionsScreen.routeName);
            } else {
              ref
                  .read(checkoutViewModel.notifier)
                  .updateState(treatmentId: treatments.id);
              Navigator.pushNamed(
                context,
                ref.read(checkoutViewModel.notifier).navigateTo(),
              );
            }
          },
          child: Container(
            padding: EdgeInsets.only(
              left: 12.w,
              right: 12.w,
              top: 12.h,
              bottom: 12.h,
            ),
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(200.w),
                topRight: Radius.circular(20.w),
                bottomLeft: Radius.circular(200.w),
                bottomRight: Radius.circular(20.w),
              ),
              border: Border.all(
                color: CustomColors.lightPurpleColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: CustomColors.purpleColor.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Big icon in circle on left with title on right
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Big icon inside circle with enhanced visibility
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: Offset(0, 4),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          SvgAssets.treatment,
                          height: 42.h,
                          width: 42.w,
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    // Title on right of icon - more visible
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            treatments.name!,
                            style: CustomFonts.black24w600,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Info icon in top right corner
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // Only this button opens detail page
                      Navigator.pushNamed(
                        context,
                        TreatmentDetailScreen.routeName,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.black,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
