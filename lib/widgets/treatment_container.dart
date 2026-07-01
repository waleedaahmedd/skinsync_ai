import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/screens/treatment_detail_screen.dart';
import 'package:skinsync_ai/screens/explore_clinics_screen.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';
import 'package:skinsync_ai/widgets/app_network_image.dart';
import 'package:skinsync_ai/widgets/scan_face_dialog.dart';

import '../main.dart';
import '../models/responses/treatment_list_response.dart';
import '../view_models/checkout_view_model.dart';

class TreatmentContainer extends StatelessWidget {
  final double? imageHeight;
  final double? width;
  final TreatmentData? treatments;
  
  // Custom Adaptive Fields for Selection Screen Reusability
  final String? customTitle;
  final String? customSubtitle;
  final String? customImageUrl;
  final String? customIcon;
  final VoidCallback? customOnTap;

  const TreatmentContainer({
    super.key,
    this.treatments,
    this.imageHeight,
    this.width,
    this.customTitle,
    this.customSubtitle,
    this.customImageUrl,
    this.customIcon,
    this.customOnTap,
  });

  Widget? _buildLeftIcon(String? iconKey) {
    // 1. If it's a network image URL, render it cleanly via AppNetworkImage
      return Container(
        margin: EdgeInsets.only(bottom: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
            ),
          ],
        ),
        child: AppNetworkImage(
          imageUrl: iconKey ?? '',
          width: 38.w,
          height: 38.w,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(10.r),
          errorIcon: Icons.broken_image,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final isTreatmentData = treatments is TreatmentData;
        final treatmentData = isTreatmentData ? treatments as TreatmentData : null;

        final titleText = customTitle ?? treatments?.name ?? "";
        final subtitleText = customSubtitle ?? treatmentData?.shortDescription ?? treatments?.description ?? "";
        final bgImage = customImageUrl ?? treatmentData?.image ?? treatments?.imageUrl ?? "";
        final iconKey = customIcon ?? treatments?.icon;
        final iconWidget = iconKey!= null?_buildLeftIcon(iconKey): null;
        final globalSku = treatmentData?.globalSku ?? "";
        final useInAiSimulator = treatmentData?.useInAiSimulator ?? false;

        return GestureDetector(
          onTap: customOnTap ?? () {
            if (treatments == null) return;
            ref.read(checkoutViewModel.notifier).clearState();
            ref.read(treatmentViewModel.notifier).clearAllSelectedTreatments();
            ref.read(treatmentViewModel.notifier).clearAiImage();
            ref.read(checkoutViewModel.notifier).addSelectedTreatment(treatments!);
            if (treatments!.isArea == true) {
              ref
                  .read(treatmentViewModel.notifier)
                  .onTapTreatment(
                    treatmentModel: treatments!,
                    isCallPredictAPI: false,
                  );
            }
            if (useInAiSimulator) {
              showMScanFaceDialog(context);
            } else {
              Navigator.pushNamed(
                context,
                ExploreClinicsScreen.routeName,
                arguments: {
                  'treatmentId': treatments!.id,
                  'sideAreaIds': <int>[],
                },
              );
            }
          },
          child: Container(
            height: imageHeight ?? 300.h,
            width: width ?? MediaQuery.sizeOf(context).width,
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: CustomColors.purpleColor.withValues(alpha: 0.12),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Stack(
                children: [
                  // 1. Full-Cover Image Background via AppNetworkImage
                  Positioned.fill(
                    child: AppNetworkImage(
                      imageUrl: bgImage,
                      fit: BoxFit.cover,
                      placeholderColor: Colors.transparent, // Keeps overlay visual hierarchy clean
                    ),
                  ),

                  // 2. Translucent Premium White Mask Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.20),
                            Colors.white
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3. MedSpa Elegant Glow Layer on Left
/*
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 220.w,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            CustomColors.purpleColor.withValues(alpha: 0.15),
                            CustomColors.lightBlueColor.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
*/

                  // 4. Elegant Content Layer (Title, Description, and Chevron aligned to bottom)
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(22.w, 12.h, 22.w, 16.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  titleText,
                                  style: CustomFonts.black22w600,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (subtitleText.isNotEmpty) ...[
                                  SizedBox(height: 6.h),
                                  Text(
                                    subtitleText,
                                    style: CustomFonts.grey12w400,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                if (globalSku.isNotEmpty) ...[
                                  SizedBox(height: 6.h),
                                  Text(
                                    "SKU: $globalSku",
                                    style: CustomFonts.grey12w400.copyWith(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),

                          // Translucent Circular Action Arrow
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black12,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.black87,
                              size: 22.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 5. Left-hand Icon on Top Left
                  if (iconWidget != null)
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      child: iconWidget,
                    ),

                  // AI Compatible Badge
                  if (useInAiSimulator)
                    Positioned(
                      top: 12.h,
                      right: (treatments != null && !isDeploymentMode) ? 44.w : 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: CustomColors.purpleColor.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: CustomColors.purpleColor.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 10.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "AI Compatible",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Degular',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // 6. Info Button on Top Right (if not in deployment mode and real treatment is present)
                  if (treatments != null)
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
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                          ),
                        ),
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
