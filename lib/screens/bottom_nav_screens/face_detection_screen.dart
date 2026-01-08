import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:skinsync_ai/utills/image_utills.dart';

import '../../utills/custom_fonts.dart';
import '../../utills/ml_kit_utills.dart';
import '../../view_models/checkout_view_model.dart';
import '../../view_models/face_scan_provider.dart';
import '../../widgets/face_scan_radial_widget.dart';
import '../ar_face_model_Preview_screen.dart';
import '../service_selection_screen.dart';

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

  // Local state for face detection logic
  double _progress = 0.0;
  bool _isCapturing = false;
  Timer? _progressTimer;
  static const Duration _progressDuration = Duration(seconds: 3);

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
        ResolutionPreset.high,
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

    // If no face detected, always reset progress and stop countdown
    if (faces.isEmpty) {
      _resetProgress();
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

    // Face is valid ONLY if: centered AND fully visible AND reasonable size AND normal aspect ratio
    // ALL conditions must be met - this ensures full face is detected
    final isValidFace =
        isCentered &&
        isFullyVisible && // Must be fully visible (not cut off)
        isReasonableSize && // Must have reasonable size
        isNormalAspectRatio; // Must have normal proportions

    // Debug: Print face detection info
    // print('Face detected - Center: $faceCenter, Image Center: $imageCenter');
    // print('Distance from center: ${distanceFromCenter}, Allowed: $allowedRadiusSquared');
    // print('Face size: $faceWidth x $faceHeight, Min: $minFaceSize');
    // print('Is within circle: $isWithinCircle, Is reasonable size: $isReasonableSize');

    // Start or continue progress if face is valid
    if (isValidFace) {
      if (!_isCapturing && _progressTimer == null) {
        _startProgress();
      }
      // If timer is already running, let it continue
    } else {
      // Face is not valid - always reset progress and stop countdown
      _resetProgress();
    }
  }

  void _resetProgress() {
    if (mounted) {
      setState(() {
        _progress = 0.0;
      });
    }
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  void _startProgress() {
    if (_progressTimer != null && _progressTimer!.isActive) {
      return;
    }

    _progressTimer?.cancel();
    _progress = 0.0;

    final startTime = DateTime.now();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final elapsed = DateTime.now().difference(startTime);
      final newProgress =
          (elapsed.inMilliseconds / _progressDuration.inMilliseconds).clamp(
            0.0,
            1.0,
          );

      if (mounted) {
        setState(() {
          _progress = newProgress;
        });
      }

      if (newProgress >= 1.0) {
        // timer.cancel();
        // // Capture the image when countdown completes
        // if (mounted && _storedRef != null) {
          _captureAndNavigate(_storedRef!);
//}
      }
    });
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

    // Flip the image if using front camera (to match the mirrored preview)
    XFile processedImage = image;
    if (_cameraController!.description.lensDirection ==
        CameraLensDirection.front) {
      processedImage = await flipXFileHorizontally(image);
    }

    // Crop image to circle size (50% radius, centered at 50% width, 29% height)
    final finalImage = await cropImageToCircle(
      processedImage,
      centerXPercent: 0.5, // Center horizontally
      centerYPercent: 0.29, // Position at top (29% from top)
      radiusPercent: 0.5, // 50% of image width
    );

    // Store captured image in provider
    await ref.read(faceScanProvider.notifier).setCapturedImage(finalImage);
    ref.read(checkoutViewModel.notifier).updateState(capturedImage: finalImage);

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      ref.read(checkoutViewModel.notifier).navigateTo(),
    );
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep the provider alive by watching it
    ref.watch(faceScanProvider);

    return PopScope(
      onPopInvokedWithResult: (result, _) {
        ref.read(checkoutViewModel.notifier).clearState();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            if (_cameraController != null) _buildCameraView(),

            // Consumer(
            //   builder: (_, ref, _) {
            //     final isCapturing = ref.watch(
            //       faceScanProvider.select((state) => state.isCapturing),
            //     );
            //     if (isCapturing) return const SizedBox.shrink();

            //     return Align(
            //       alignment: Alignment.topRight,
            //       child: Padding(
            //         padding: EdgeInsets.only(top: 40.h, right: 20.w),
            //         child: GestureDetector(
            //           onTap: () {
            //             ref.read(faceScanProvider.notifier).toggleFlash();
            //             if (_cameraController != null) {
            //               _cameraController!.setFlashMode(
            //                 ref.read(faceScanProvider).flash
            //                     ? FlashMode.torch
            //                     : FlashMode.off,
            //               );
            //             }
            //           },
            //           child: Consumer(
            //             builder: (_, ref, child) {
            //               final flash = ref.watch(
            //                 faceScanProvider.select((state) => state.flash),
            //               );
            //               return Icon(
            //                 flash ? Icons.flash_on : Icons.flash_off,
            //                 color: Colors.white,
            //                 size: 30.sp,
            //               );
            //             },
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // ),
            Positioned(
              top: 10.h,
              left: 20.w,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    // _captureAndNavigate();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.h,
                      horizontal: 18.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      "Cancel",
                      textAlign: TextAlign.center,
                      style: CustomFonts.white22w600,
                    ),
                  ),
                ),
              ),
            ),
            // Countdown in the center of the screen
            if (_progress > 0 && _progress < 1.0)
              Center(
                child: Builder(
                  builder: (context) {
                    final remainingSeconds =
                        (_progressDuration.inSeconds -
                                (_progress * _progressDuration.inSeconds))
                            .ceil()
                            .clamp(1, _progressDuration.inSeconds);
                    return Text(
                      "$remainingSeconds",
                      textAlign: TextAlign.center,
                      style: CustomFonts.white50w600.copyWith(
                        fontSize: 100.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 34.h,
                    horizontal: 52.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Builder(
                    builder: (context) {
                      String message;
                      if (_isCapturing) {
                        message = "Hold Still";
                      } else {
                        message = "Align your face";
                      }

                      return Text(
                        message,
                        textAlign: TextAlign.center,
                        style: CustomFonts.black28w600,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownWidget(int count) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: 140.w,
          height: 140.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff88E3FB), Color(0xffE7C6E8)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xff88E3FB).withOpacity(0.6),
                blurRadius: 40,
                spreadRadius: 8,
              ),
              BoxShadow(
                color: Color(0xffE7C6E8).withOpacity(0.6),
                blurRadius: 40,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Transform.scale(
            scale: scale,
            child: Center(
              child: Text(
                "$count",
                style: CustomFonts.white50w600.copyWith(
                  fontSize: 100.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 15,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCameraView() {
    // If we have a captured image, show it instead of camera preview
    if (_capturedImage != null) {
      return SizedBox.expand(
        child: Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
      );
    }

    // Get camera preview size
    final previewSize = _cameraController!.value.previewSize!;
    final aspectRatio = previewSize.height / previewSize.width;

    // Calculate safe top padding
    final topPadding = MediaQuery.of(context).padding.top;
    // Use percentage of canvas width instead of screen width to ensure it fits
    // The circle radius will be calculated as a percentage of the actual canvas width
    final circleRadiusPercent = 0.50; // 50% of canvas width
    // Position circle center at the top - use radius as percentage of canvas width
    // Since radius is 50% of width, position center at top + small padding
    final circleCenterYPercent = 0.29; // 10% from top of canvas (near the top)

    return SizedBox.expand(
      child: Center(
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
                  // Dark overlay with transparent circle cutout at top
                  CustomPaint(
                    painter: TintOverlayPainter(
                      centerRadius: circleRadius,
                      centerY: circleCenterY,
                    ),
                    child: const SizedBox.expand(),
                  ),
                  // Progress ring - matches the circle cutout size, positioned at top
                  Positioned(
                    top:
                        circleCenterY -
                        circleRadius, // Align top of ring with top of circle
                    left: 0,
                    right: 0,
                    child: Center(
                      child: CustomPaint(
                        painter: FaceScanPainter(progress: _progress),
                        child: SizedBox(
                          width: circleRadius * 2,
                          height: circleRadius * 2,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// Custom painter for the tinted overlay with transparent center
class TintOverlayPainter extends CustomPainter {
  final double centerRadius;
  final double? centerY; // Optional Y position, defaults to center if null

  TintOverlayPainter({required this.centerRadius, this.centerY});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // Use provided centerY or default to center of screen
    final center = Offset(size.width / 2, centerY ?? size.height / 2);

    // Create a path for the entire screen
    final path = Path()..addRect(rect);

    // Cut out a circle from the center
    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: centerRadius));

    // Subtract the circle from the full screen path
    final overlayPath = Path.combine(
      PathOperation.difference,
      path,
      circlePath,
    );

    // Draw the dark overlay
    final paint = Paint()
      ..color = Colors
          .black // Increased opacity for better visibility
      ..style = PaintingStyle.fill;

    canvas.drawPath(overlayPath, paint);

    // Draw a border around the circle cutout for better visibility
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, centerRadius, borderPaint);
  }

  @override
  bool shouldRepaint(TintOverlayPainter oldDelegate) {
    return oldDelegate.centerRadius != centerRadius ||
        oldDelegate.centerY != centerY;
  }
}
