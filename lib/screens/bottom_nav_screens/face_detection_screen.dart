import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:skinsync_ai/utills/image_utills.dart';

import '../../utills/assets.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../../utills/face_detector_painter.dart';
import '../../utills/ml_kit_utills.dart';
import '../../view_models/checkout_view_model.dart';
import '../../view_models/face_scan_provider.dart';
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
  late FaceDetector _faceDetector;
  bool _isDetecting = false;
  XFile? _capturedImage;

  bool _isCapturing = false;

  // CustomPaint? _faceBoundingBoxPaint;

  // Store ref for use in callbacks
  WidgetRef? _storedRef;

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(enableClassification: true),
    );
    _storedRef = ref;
    _initCamera(ref);
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

      _cameraController!.startImageStream((image) {
        if (_isDetecting || !mounted) return;
        _isDetecting = true;

        _process(ref, image).whenComplete(() {
          if (mounted) {
            _isDetecting = false;
          }
        });
      });

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

  Future<void> _process(WidgetRef ref, CameraImage image) async {
    // Don't process if we're already capturing
    if (_isCapturing) {
      return;
    }

    // Use full image for detection (cropping might have issues)
    // We'll check if face is centered and within the circular guide area
    final inputImage = inputImageFromCameraImage(
      image,
      _cameraController!.description,
    );

    // Detect faces in the full image
    final faces = await _faceDetector.processImage(inputImage);

    // Update face bounding box painter
    // Use the actual camera preview size for accurate coordinate mapping
    // final previewSize = _cameraController!.value.previewSize;
    // if (mounted) {
    //   setState(() {
    //     if (faces.isNotEmpty &&
    //         inputImage.metadata?.size != null &&
    //         inputImage.metadata?.rotation != null &&
    //         previewSize != null) {
    //       // Create bounding box paint when face is detected and metadata is available
    //       _faceBoundingBoxPaint = CustomPaint(
    //         painter: FaceDetectorPainter(
    //           faces: faces,
    //           imageSize: inputImage.metadata!.size,
    //           rotation: inputImage.metadata!.rotation,
    //           cameraLensDirection: _cameraController!.description.lensDirection,
    //           previewSize: Size(
    //             previewSize.width.toDouble(),
    //             previewSize.height.toDouble(),
    //           ),
    //         ),
    //         child: const SizedBox.expand(),
    //       );
    //     } else {
    //       // Clear bounding box paint when no faces or metadata unavailable
    //       _faceBoundingBoxPaint = null;
    //     }
    //   });
    // }

    if (faces.isEmpty) {
      return;
    }

    final face = faces.first;

    // Get face bounding box - coordinates are in the InputImage coordinate system
    final faceBox = face.boundingBox;
    final faceCenter = faceBox.center;
    final faceWidth = faceBox.width;
    final faceHeight = faceBox.height;

    // Get the input image size (accounts for rotation)
    final inputImageSize =
        inputImage.metadata?.size ??
        Size(image.width.toDouble(), image.height.toDouble());

    // IMPORTANT: The camera preview uses AspectRatio which may letterbox the image
    // Face detection coordinates are relative to the full InputImage, not the visible preview
    // The center calculation should use the actual image center

    // Calculate the square area (lens square) in image coordinates
    // Square is 50% of circle diameter, centered at circle center
    // Circle center: 50% width, 29% height from top
    // Circle radius: 42% of canvas width
    // Square size: 50% of circle diameter = 42% of canvas width
    // For simplicity, use image dimensions directly (42% of image width)
    final squareCenterX = inputImageSize.width / 2.0; // 50% width
    final squareCenterY = inputImageSize.height * 0.42; // 29% from top
    final squareSize = inputImageSize.width * 0.42; // 42% of image width
    final squareHalfSize = squareSize / 2.0;

    // Square bounds in image coordinates
    final squareLeft = squareCenterX - squareHalfSize;
    final squareRight = squareCenterX + squareHalfSize;
    final squareTop = squareCenterY - squareHalfSize;
    final squareBottom = squareCenterY + squareHalfSize;

    // Check if face bounding box aligns with the square (lens area)
    // Use very lenient tolerance for alignment - face should be mostly within square
    final tolerance =
        squareSize * 0.40; // 40% tolerance for alignment (very lenient)

    // Check if face center is within the square area (with tolerance)
    final faceCenterInSquare =
        faceCenter.dx >= (squareLeft - tolerance) &&
        faceCenter.dx <= (squareRight + tolerance) &&
        faceCenter.dy >= (squareTop - tolerance) &&
        faceCenter.dy <= (squareBottom + tolerance);

    // Check if face bounding box overlaps with square (simpler check)
    // Face is considered aligned if center is in square AND bounding box intersects with square
    final faceBoxIntersectsSquare =
        faceBox.right >= (squareLeft - tolerance) &&
        faceBox.left <= (squareRight + tolerance) &&
        faceBox.bottom >= (squareTop - tolerance) &&
        faceBox.top <= (squareBottom + tolerance);

    // Face is aligned if center is in square OR bounding box intersects (more lenient)
    final isFaceInSquare = faceCenterInSquare || faceBoxIntersectsSquare;

    // Calculate the center of the INPUT IMAGE (where face detection happens)
    final imageCenter = Offset(
      inputImageSize.width / 2,
      inputImageSize.height / 2,
    );

    // Calculate distance from center (circular check)
    final dx = faceCenter.dx - imageCenter.dx;
    final dy = faceCenter.dy - imageCenter.dy;
    final distanceFromCenter = (dx * dx + dy * dy);

    // Use a circular radius - 30% of smaller dimension (stricter for better centering)
    final smallerDimension = inputImageSize.width < inputImageSize.height
        ? inputImageSize.width
        : inputImageSize.height;
    final circleRadius = smallerDimension * 0.30; // Reduced from 35% to 30%
    final allowedRadiusSquared = circleRadius * circleRadius;

    // Also use rectangular check as fallback (more lenient)
    final horizontalDistance = (faceCenter.dx - imageCenter.dx).abs();
    final verticalDistance = (faceCenter.dy - imageCenter.dy).abs();
    final allowedHorizontalOffset =
        inputImageSize.width * 0.25; // Reduced from 30% to 25%
    final allowedVerticalOffset =
        inputImageSize.height * 0.25; // Reduced from 30% to 25%
    final isWithinRect =
        horizontalDistance <= allowedHorizontalOffset &&
        verticalDistance <= allowedVerticalOffset;

    // Check if face center is within the circle OR rectangle (whichever is more lenient)
    final isWithinCircle = distanceFromCenter <= allowedRadiusSquared;
    final isCentered = isWithinCircle || isWithinRect;

    // Face is aligned with lens square if face overlaps with square and center is in square
    final isAlignedWithSquare = isFaceInSquare;

    // Check if face is fully visible (not cut off at edges)
    // Face should be at least 3% away from all edges to ensure full face is visible
    final edgeMargin =
        smallerDimension * 0.03; // Increased from 1% to 3% for stricter check
    final isFullyVisible =
        faceBox.left >= edgeMargin &&
        faceBox.top >= edgeMargin &&
        faceBox.right <= (inputImageSize.width - edgeMargin) &&
        faceBox.bottom <= (inputImageSize.height - edgeMargin);

    // Check if face size is reasonable (not too small or too large)
    // Face should be between 8% and 50% of the smaller dimension
    final minFaceSize = smallerDimension * 0.08; // Increased from 5% to 8%
    final maxFaceSize = smallerDimension * 0.50; // Reduced from 65% to 50%
    final isReasonableSize =
        (faceWidth >= minFaceSize && faceWidth <= maxFaceSize) &&
        (faceHeight >= minFaceSize && faceHeight <= maxFaceSize);

    // Check face aspect ratio - ensure it's a normal face (not too stretched)
    final faceAspectRatio = faceWidth / faceHeight;
    final isNormalAspectRatio =
        faceAspectRatio >= 0.6 && faceAspectRatio <= 1.4; // Stricter range

    // Face is valid ONLY if: aligned with square AND fully visible AND reasonable size AND normal aspect ratio
    // ALL conditions must be met - this ensures full face is detected and aligned with lens square
    final isValidFace =
        isAlignedWithSquare && // Face must be aligned with lens square
        isFullyVisible && // Must be fully visible (not cut off)
        isReasonableSize && // Must have reasonable size
        isNormalAspectRatio; // Must have normal proportions

  }

  Future<void> _captureAndNavigate(WidgetRef ref) async {
    if (_cameraController == null || _isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    // Stop the image stream first
    await _cameraController!.stopImageStream();

    // Capture the image
    final image = await _cameraController!.takePicture();

    // Process image: flip (if front camera) and crop in a single operation for better performance
    final finalImage = await cropImageToCircle(
      image,
      centerXPercent: 0.5, // Center horizontally
      centerYPercent: 0.42, // Position at top (28% from top)
      radiusPercent: 0.5, // 50% of image width
      flipHorizontally: _cameraController!.description.lensDirection ==
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
                          // Restart image stream
                          _cameraController?.startImageStream((image) {
                            if (_storedRef != null) {
                              _process(_storedRef!, image);
                            }
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          side: BorderSide(
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
                          // Store captured image in provider
                          await ref
                              .read(faceScanProvider.notifier)
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
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep the provider alive by watching it
    ref.watch(faceScanProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_cameraController != null) _buildCameraView(),
        ],
      ),
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
    final circleRadiusPercent = 0.42;
    final circleCenterYPercent = 0.42;

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
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 30.w,
                vertical: 5.h,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.95),
                    Colors.black
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
                      color: Colors.white.withOpacity(0.9),
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
                            padding: EdgeInsets.symmetric(
                              vertical: 18.h,
                            ),
                            alignment: Alignment.center,
                            child: _isCapturing
                                ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(
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
        ],
      ),
    );
  }

  Widget _buildInstructionRow({
    required String icon,
    required String text,
    required double iconHeight,
    required double iconWidth,
    Color? iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          height: iconHeight,
          width: iconWidth,
          colorFilter: iconColor != null
              ? ColorFilter.mode(iconColor, BlendMode.srcIn)
              : null,
        ),
        SizedBox(width: 17.w),
        Flexible(
          child: Text(
            text,
            style: CustomFonts.white22w600.copyWith(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.9),
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
