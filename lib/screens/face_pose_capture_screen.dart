import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utills/assets.dart';
import '../utills/color_constant.dart';
import '../utills/custom_fonts.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/treatment_container.dart';
import 'ar_face_model_preview_screen.dart';
import 'bottom_nav_screens/face_detection_screen.dart';

class FacePoseCaptureScreen extends ConsumerWidget {
  static const String routeName = '/FacePoseCaptureScreen';

  const FacePoseCaptureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(treatmentViewModel);

    final bool allCaptured =
        state.frontPoseImage != null &&
        state.leftPoseImage != null &&
        state.rightPoseImage != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        showTitle: true,
        title: "Capture Your Profile",
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    "Clear photos from multiple angles ensure our AI provides the most precise treatment recommendations for your unique features.",
                    style: CustomFonts.grey14w400.copyWith(height: 1.4),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      _buildIndicator(
                        active: true,
                        color: CustomColors.purpleColor,
                      ),
                      SizedBox(width: 8.w),
                      _buildIndicator(
                        active: state.frontPoseImage != null,
                        color: CustomColors.purpleColor,
                      ),
                      SizedBox(width: 8.w),
                      _buildIndicator(
                        active:
                            state.leftPoseImage != null &&
                            state.rightPoseImage != null,
                        color: CustomColors.purpleColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                children: [
                  _buildPoseContainer(
                    context: context,
                    title: "Front Profile",
                    subtitle: "Look straight into the camera",
                    image: state.frontPoseImage,
                    onTap: () => _capturePose(context, 'front'),
                  ),
                  _buildPoseContainer(
                    context: context,
                    title: "Left Profile",
                    subtitle: "Turn your face to the left",
                    image: state.leftPoseImage,
                    onTap: () => _capturePose(context, 'left'),
                  ),
                  _buildPoseContainer(
                    context: context,
                    title: "Right Profile",
                    subtitle: "Turn your face to the right",
                    image: state.rightPoseImage,
                    onTap: () => _capturePose(context, 'right'),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: CustomButton(
                text: "Proceed to AI Preview",
                onPressed: allCaptured
                    ? () {
                        ref.read(treatmentViewModel.notifier).clearAiImage();
                        Navigator.pushNamed(
                          context,
                          ArFaceModelPreviewScreen.routeName,
                        );
                      }
                    : null,
                backgroundColor: allCaptured
                    ? Colors.black
                    : Colors.grey.shade300,
                textColor: allCaptured ? Colors.white : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator({required bool active, required Color color}) {
    return Expanded(
      child: Container(
        height: 3.h,
        decoration: BoxDecoration(
          color: active ? color : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }

  void _capturePose(BuildContext context, String pose) {
    Navigator.pushNamed(
      context,
      FaceDetectionScreen.routeName,
      arguments: pose,
    );
  }

  Widget _buildPoseContainer({
    required BuildContext context,
    required String title,
    required String subtitle,
    required XFile? image,
    required VoidCallback onTap,
  }) {
    final String poseLabel = title.toLowerCase().contains("front")
        ? "front pose"
        : title.toLowerCase().contains("left")
        ? "side pose (left)"
        : "side pose (right)";

    final String placeholderAsset = title.toLowerCase().contains("front")
        ? PngAssets.frontFace
        : title.toLowerCase().contains("left")
        ? PngAssets.leftFace
        : PngAssets.rightFace;

    return TreatmentContainer(
      imageHeight: 300.h,
      customTitle: title,
      customSubtitle: subtitle,
      customOnTap: onTap,
      backgroundWidget: image != null
          ? Image.file(File(image.path), fit: BoxFit.cover)
          : Image.asset(placeholderAsset, fit: BoxFit.cover),
      topRightWidget: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          poseLabel,
          style: CustomFonts.white10w600.copyWith(fontSize: 10.sp),
        ),
      ),
    );
  }
}
