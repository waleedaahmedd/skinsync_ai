import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/treatment_detail_screen.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/treatment_view_model.dart';
import 'scan_face_dialog.dart';

import '../main.dart';
import '../models/responses/treatment_response_model.dart';
import '../view_models/checkout_view_model.dart';

class TreatmentContainer extends StatelessWidget {
  final double? imageHeight;
  final double? width;
  final TreatmentsModel treatments;
  const TreatmentContainer({
    super.key,
    required this.treatments,
    this.imageHeight,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return GestureDetector(
          onTap: () {
            ref.read(checkoutViewModel.notifier).clearState();
            ref.read(treatmentViewModel.notifier).clearAllSelectedTreatments();
            ref.read(treatmentViewModel.notifier).clearAiImage();
            ref
                .read(checkoutViewModel.notifier)
                .updateState(treatmentId: treatments.id);
            if (treatments.isArea == true) {
              // Use onTapTreatment to properly set treatmentId and handle the logic
              ref
                  .read(treatmentViewModel.notifier)
                  .onTapTreatment(
                    treatmentModel: treatments,
                    isCallPredictAPI: false,
                  );
              // TreatmentAreaScreen.show(context);
            }
            showMScanFaceDialog(context);
            //else {
            // Navigator.pushNamed(
            //   context,
            //   ref.read(checkoutViewModel.notifier).navigateTo(),
            // );
            // }
          },
          child: Container(
            width: width ?? MediaQuery.sizeOf(context).width,
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: CustomColors.whiteColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: CustomColors.lightPurpleColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: CustomColors.purpleColor.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: imageHeight ?? 180.h,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Image.network(
                          treatments.name == "Botox"
                              ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQl-cyJqFlcZav1TlRMEuajtrg2RJlWY3rTQA&s"
                              : "https://movelmedspa.com/storage/2024/05/Cheek-Filler-Treatment-at-Movel-Med-Spa.webp",
                          fit: BoxFit.fill,
                          height: imageHeight ?? 180.h,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image);
                          },
                        ),
                        Visibility(
                          visible: !isDeploymentMode,
                          child: Positioned(
                            top: 12.h,
                            right: 12.w,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  TreatmentDetailScreen.routeName,
                                  arguments: treatments,
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
                        ),
                      ],
                    ),
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
                        if (treatments.description != null &&
                            treatments.description!.isNotEmpty) ...[
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
