import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/screens/treatment_detail_screen.dart';
import 'package:skinsync_ai/screens/treatment_area_screen.dart';
import 'package:skinsync_ai/utills/assets.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';

import '../models/responses/treatment_response_model.dart';
import '../view_models/checkout_view_model.dart';
import '../view_models/face_scan_provider.dart';

class TreatmentContainer extends StatelessWidget {
  final TreatmentsModel treatments;
  const TreatmentContainer({super.key, required this.treatments});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return GestureDetector(
          onTap: () {
            ref.read(checkoutViewModel.notifier).clearState();
            ref.read(treatmentViewModel.notifier).clearAllSelectedTreatments();
            ref.read(faceScanProvider.notifier).clearAiImage();
            ref
                .read(checkoutViewModel.notifier)
                .updateState(treatmentId: treatments.id);
            if (treatments.isArea == true) {
              // Use onTapTreatment to properly set treatmentId and handle the logic
              ref
                  .read(treatmentViewModel.notifier)
                  .onTapTreatment(treatmentModel: treatments, isCallPredictAPI: false);
             // TreatmentAreaScreen.show(context);
            }
            //else {
              Navigator.pushNamed(
                context,
                ref.read(checkoutViewModel.notifier).navigateTo(),
              );
            // }
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 180.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(PngAssets.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12.h,
                        right: 12.w,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              TreatmentDetailScreen.routeName,
                            );
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          treatments.name!,
                          style: CustomFonts.black20w600,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (treatments.description != null && treatments.description!.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Text(
                            treatments.description!,
                            style: CustomFonts.grey14w400,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
