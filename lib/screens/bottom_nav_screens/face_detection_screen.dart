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

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(enableClassification: true),
    );
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
    // Don't process if we're already capturing or if progress is too far along
    // Once we're past 70% progress, don't reset to ensure capture happens
    if (_isCapturing || _progress > 0.7) {
      return;
    }

    // final imageWidth = image.width.toDouble();
    // final imageHeight = image.height.toDouble();
    // final cropSize =
    //     (imageWidth < imageHeight ? imageWidth : imageHeight) * 0.45;
    // final cropX = (imageWidth - cropSize) / 2;
    // final cropY = (imageHeight - cropSize) / 2;
    // final cropRect = Rect.fromLTWH(cropX, cropY, cropSize, cropSize);

    final inputImage = inputImageFromCameraImage(
      image,
      _cameraController!.description,
      // cropRect: cropRect,
    );

    final faces = await _faceDetector.processImage(inputImage);

    if (faces.isEmpty) {
      _resetProgress();
      return;
    }

    final face = faces.first;
    final previewSize = _cameraController!.value.previewSize!;

    final faceCenter = face.boundingBox.center;
    final previewCenter = Offset(image.width / 2, image.height / 2);

    final distance = (faceCenter - previewCenter).distance;
    final allowedRadius = previewSize.width * 0.3;

    if (distance <= allowedRadius) {
      _startProgress();
    } else {
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
        timer.cancel();
        if (mounted) {
          _captureAndNavigate(ref);
        }
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
    XFile finalImage = image;
    if (_cameraController!.description.lensDirection ==
        CameraLensDirection.front) {
      finalImage = await flipXFileHorizontally(image);
    }

    // Store captured image in provider
    await ref.read(faceScanProvider.notifier).setCapturedImage(finalImage);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, ArFaceModelPreviewScreen.routeName);
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

    return Scaffold(
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
                      fontSize: 80.sp,
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
                padding: EdgeInsets.symmetric(vertical: 34.h, horizontal: 52.w),
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
    );
  }

  Widget _buildCameraView() {
    // If we have a captured image, show it instead of camera preview
    if (_capturedImage != null) {
      return SizedBox.expand(
        child: Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _cameraController!.value.previewSize!.height,
          height: _cameraController!.value.previewSize!.width,
          child: Stack(
            children: [
              CameraPreview(_cameraController!),
              // Dark overlay with transparent center
              CustomPaint(
                painter: TintOverlayPainter(centerRadius: 0.6.sw),
                child: const SizedBox.expand(),
              ),
              // Progress ring
              Center(
                child: CustomPaint(
                  painter: FaceScanPainter(progress: _progress),
                  child: SizedBox(width: 1.4.sw, height: 1.4.sw),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for the tinted overlay with transparent center
class TintOverlayPainter extends CustomPainter {
  final double centerRadius;

  TintOverlayPainter({required this.centerRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = Offset(size.width / 2, size.height / 2);

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
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.drawPath(overlayPath, paint);
  }

  @override
  bool shouldRepaint(TintOverlayPainter oldDelegate) {
    return oldDelegate.centerRadius != centerRadius;
  }
}
