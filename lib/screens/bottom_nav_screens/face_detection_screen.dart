import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../utills/image_utills.dart';
import '../../utills/secure_storage_service.dart';
import '../../widgets/bottom_sheets/medical_disclaimer_bottomsheet.dart';

import '../../utills/assets.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../../view_models/checkout_view_model.dart';
import '../../view_models/treatment_view_model.dart';
import '../ar_face_model_Preview_screen.dart';

class FaceDetectionScreen extends ConsumerStatefulWidget {
  const FaceDetectionScreen({super.key});

  static const String routeName = '/FaceDetectionScreen';

  @override
  ConsumerState<FaceDetectionScreen> createState() =>
      _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends ConsumerState<FaceDetectionScreen> {
  CameraController? _cameraController;
  XFile? _capturedImage;

  bool _isCapturing = false;

  // Store ref for use in callbacks
  WidgetRef? _storedRef;

  @override
  void initState() {
    super.initState();
    _storedRef = ref;
    _initCamera(ref);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final show = await SecureStorage().getMedicalDisclaimer();
      if (show) {
        MedicalDisclaimerBottomSheet.show(context);
      }
    });
  }

  Future<void> _initCamera(WidgetRef ref) async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          _showError('No cameras available');
        }
        return;
      }

      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        front,
        ResolutionPreset.veryHigh, // HD quality
        enableAudio: false,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();

      if (!mounted) return;

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to initialize camera: $e');
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> _captureAndNavigate(WidgetRef ref) async {
    if (_cameraController == null || _isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    // Capture the image
    final image = await _cameraController!.takePicture();

    // Process image: flip (if front camera) and crop in a single operation for better performance
    final finalImage = await cropImageToCircle(
      image,
      centerXPercent: 0.5, // Center horizontally
      centerYPercent: 0.42, // Position at top (28% from top)
      radiusPercent: 0.5, // 50% of image width
      flipHorizontally:
          _cameraController!.description.lensDirection ==
          CameraLensDirection.front, // Flip if front camera
    );

    // Store captured image in state to show in dialog
    if (!mounted) return;

    setState(() {
      _capturedImage = finalImage;
      _isCapturing = false;
    });

    // Show dialog with captured image
    _showImageVerificationDialog(ref, finalImage);
  }

  void _showImageVerificationDialog(WidgetRef ref, XFile capturedImage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Text(
                  "Verify your image",
                  style: CustomFonts.black24w600,
                  textAlign: TextAlign.center,
                ),
              ),
              // Captured image
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                height: 300.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: CustomColors.lightPurpleColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13.r),
                  child: Image.file(
                    File(capturedImage.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              // Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Row(
                  children: [
                    // Recapture button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _capturedImage = null;
                            _isCapturing = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          side: const BorderSide(
                            color: CustomColors.purpleColor,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          "Recapture",
                          style: CustomFonts.black18w600.copyWith(
                            color: CustomColors.purpleColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Submit button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Store captured image in view model
                          ref
                              .read(treatmentViewModel.notifier)
                              .setCapturedImage(capturedImage);
                          ref
                              .read(checkoutViewModel.notifier)
                              .updateState(capturedImage: capturedImage);
                          Navigator.pop(context);
                          if (mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              ArFaceModelPreviewScreen.routeName,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text("Submit", style: CustomFonts.white18w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep the treatment state alive by watching it
    ref.watch(treatmentViewModel.select((s) => s.capturedImage));

    return Scaffold(
      backgroundColor: Colors.black,
      body: _cameraController != null ? _buildCameraView() : const SizedBox.shrink(),
    );
  }

  Widget _buildCameraView() {
    // If we have a captured image, show it instead of camera preview
    if (_capturedImage != null) {
      return SizedBox.expand(
        child: Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
      );
    }

    final previewSize = _cameraController!.value.previewSize!;
    final aspectRatio = previewSize.height / previewSize.width;
    const circleRadiusPercent = 0.42;
    const circleCenterYPercent = 0.42;

    return SizedBox.expand(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate actual circle radius based on canvas width
                  final canvasWidth = constraints.maxWidth;
                  final canvasHeight = constraints.maxHeight;
                  final circleRadius = canvasWidth * circleRadiusPercent;
                  final circleCenterY = canvasHeight * circleCenterYPercent;
                  return Stack(
                    children: [
                      CameraPreview(_cameraController!),
                      // Face bounding box overlay - must be before dark overlay to be visible
                      // if (_faceBoundingBoxPaint != null)
                      //   Positioned.fill(child: _faceBoundingBoxPaint!),
                      // White square (camera lens corners) - keep visible
                      CustomPaint(
                        painter: TintOverlayPainter(
                          centerRadius: circleRadius,
                          centerY: circleCenterY,
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            left: 15.w,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 5.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.8),
                      Colors.black.withValues(alpha: 0.95),
                      Colors.black,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 24.h),
                    Text(
                      "Face Scan",
                      style: CustomFonts.white22w600.copyWith(
                        fontSize: 24.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "We'll scan your face and create a cool model just for you to enhance your experience!",
                      style: CustomFonts.white22w600.copyWith(
                        fontSize: 14.sp,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildInstructionRow(
                      icon: SvgAssets.eye,
                      text:
                          "Face forward and make sure your eyes are clearly visible.",
                      iconHeight: 24.h,
                      iconWidth: 26.w,
                    ),
                    SizedBox(height: 16.h),
                    _buildInstructionRow(
                      icon: SvgAssets.profileIcon,
                      text: "Align your face within the circular frame.",
                      iconHeight: 24.h,
                      iconWidth: 24.w,
                      iconColor: CustomColors.purpleColor,
                    ),
                    SizedBox(height: 16.h),
                    _buildInstructionRow(
                      icon: SvgAssets.glasses,
                      text:
                          "Remove anything that covers your face eg: Eye glasses, Cap etc",
                      iconHeight: 8.h,
                      iconWidth: 22.w,
                    ),
                    SizedBox(height: 16.h),
                    _buildInstructionRow(
                      icon: SvgAssets.face,
                      text: "Move Your Face Inside The Border",
                      iconHeight: 24.h,
                      iconWidth: 22.w,
                    ),
                    SizedBox(height: 16.h),
                    _buildInstructionRow(
                      icon: Icons.warning,
                      iconColor: CustomColors.purpleColor,
                      text:
                          "The app is not a medical device. Any results provided are for informational and aesthetic purposes only.",
                      iconHeight: 24.h,
                      iconWidth: 22.w,
                    ),
                    SizedBox(height: 30.h),
                    // Capture button
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          color: CustomColors.purpleColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _isCapturing
                                ? null
                                : () {
                                    if (_storedRef != null) {
                                      _captureAndNavigate(_storedRef!);
                                    }
                                  },
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 18.h),
                              alignment: Alignment.center,
                              child: _isCapturing
                                  ? SizedBox(
                                      height: 20.h,
                                      width: 20.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      "Capture",
                                      style: CustomFonts.white18w600,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionRow({
    required dynamic icon,
    required String text,
    required double iconHeight,
    required double iconWidth,
    Color? iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon is String)
          SvgPicture.asset(
            icon,
            height: iconHeight,
            width: iconWidth,
            colorFilter: iconColor != null
                ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                : null,
          )
        else
          Icon(icon, size: iconHeight, color: iconColor),
        SizedBox(width: 17.w),
        Flexible(
          child: Text(
            text,
            style: CustomFonts.white22w600.copyWith(
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class TintOverlayPainter extends CustomPainter {
  final double centerRadius;
  final double? centerY; // Optional Y position, defaults to center if null

  TintOverlayPainter({required this.centerRadius, this.centerY});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, centerY ?? size.height / 2);
    // Square size is 50% of circle diameter - smaller and centered
    final squareSize = centerRadius * 2 * 0.50;
    final squareRect = Rect.fromCenter(
      center: center,
      width: squareSize,
      height: squareSize,
    );

    // Corner indicator style - like camera viewfinder
    final cornerLength =
        squareSize * 0.20; // Longer corners for better visibility
    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    // Top-left corner (L-shaped)
    canvas.drawLine(
      Offset(squareRect.left, squareRect.top + cornerLength),
      Offset(squareRect.left, squareRect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(squareRect.left, squareRect.top),
      Offset(squareRect.left + cornerLength, squareRect.top),
      cornerPaint,
    );

    // Top-right corner (L-shaped)
    canvas.drawLine(
      Offset(squareRect.right - cornerLength, squareRect.top),
      Offset(squareRect.right, squareRect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(squareRect.right, squareRect.top),
      Offset(squareRect.right, squareRect.top + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner (L-shaped)
    canvas.drawLine(
      Offset(squareRect.left, squareRect.bottom - cornerLength),
      Offset(squareRect.left, squareRect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(squareRect.left, squareRect.bottom),
      Offset(squareRect.left + cornerLength, squareRect.bottom),
      cornerPaint,
    );

    // Bottom-right corner (L-shaped)
    canvas.drawLine(
      Offset(squareRect.right - cornerLength, squareRect.bottom),
      Offset(squareRect.right, squareRect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(squareRect.right, squareRect.bottom),
      Offset(squareRect.right, squareRect.bottom - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(TintOverlayPainter oldDelegate) {
    return oldDelegate.centerRadius != centerRadius ||
        oldDelegate.centerY != centerY;
  }
}
