import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_ai/screens/treatment_detail_screen.dart';
import 'package:skinsync_ai/utills/color_constant.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';
import 'package:skinsync_ai/view_models/treatment_view_model.dart';
import 'package:skinsync_ai/widgets/scan_face_dialog.dart';

import '../main.dart';
import '../models/responses/treatment_response_model.dart';
import '../view_models/checkout_view_model.dart';

class TreatmentContainer extends StatelessWidget {
  final double? imageHeight;
  final double? width;
  final TreatmentsModel? treatments;
  
  // Custom Adaptive Fields for Selection Screen Reusability
  final String? customTitle;
  final String? customSubtitle;
  final String? customImageUrl;
  final VoidCallback? customOnTap;

  const TreatmentContainer({
    super.key,
    this.treatments,
    this.imageHeight,
    this.width,
    this.customTitle,
    this.customSubtitle,
    this.customImageUrl,
    this.customOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final titleText = customTitle ?? treatments?.name ?? "";
        final subtitleText = customSubtitle ?? treatments?.description ?? "";
        final bgImage = customImageUrl ?? 
            (treatments?.name == "Botox"
                ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQl-cyJqFlcZav1TlRMEuajtrg2RJlWY3rTQA&s"
                : "https://movelmedspa.com/storage/2024/05/Cheek-Filler-Treatment-at-Movel-Med-Spa.webp");

        return GestureDetector(
          onTap: customOnTap ?? () {
            if (treatments == null) return;
            ref.read(checkoutViewModel.notifier).clearState();
            ref.read(treatmentViewModel.notifier).clearAllSelectedTreatments();
            ref.read(treatmentViewModel.notifier).clearAiImage();
            ref
                .read(checkoutViewModel.notifier)
                .updateState(treatmentId: treatments!.id);
            if (treatments!.isArea == true) {
              ref
                  .read(treatmentViewModel.notifier)
                  .onTapTreatment(
                    treatmentModel: treatments!,
                    isCallPredictAPI: false,
                  );
            }
            showMScanFaceDialog(context);
          },
          child: Container(
            height: imageHeight ?? 200.h,
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
                  // 1. Full-Cover Image Background
                  Positioned.fill(
                    child: Image.network(
                      bgImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: CustomColors.purpleBlueGradient,
                          ),
                          child: const Icon(Icons.broken_image, color: Colors.white24),
                        );
                      },
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
                            Colors.white.withValues(alpha: 0.40),
                            Colors.white.withValues(alpha: 0.95),
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

                  // 4. Elegant Content Layer (Title, Description, and Chevron)
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
                      child: Row(
                        children: [
                          // Left side column containing text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
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

                  // 5. Info Button on Top Right (if not in deployment mode and real treatment is present)
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
