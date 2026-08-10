import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_detection_tflite/face_detection_tflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_litert/flutter_litert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vibration/vibration.dart';

import '../../utills/assets.dart';
import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../../utills/face_detection_utils.dart';
import '../../utills/image_utills.dart';
import '../../utills/secure_storage_service.dart';
import '../../view_models/treatment_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/bottom_sheets/medical_disclaimer_bottomsheet.dart';
import '../../widgets/custom_bordered_button.dart';
import '../../widgets/custom_button.dart';

class FaceDetectionScreen extends ConsumerStatefulWidget {
  final String pose;
  const FaceDetectionScreen({super.key, this.pose = 'front'});

  static const String routeName = '/FaceDetectionScreen';

  @override
  ConsumerState<FaceDetectionScreen> createState() =>
      _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends ConsumerState<FaceDetectionScreen> {
  CameraController? _cameraController;
  XFile? _capturedImage;

  bool _isCapturing = false;
  bool _isPoseCorrect = false;

  int _countdown = 3;
  Timer? _timer;
  bool _isCountingDown = false;

  // Store ref for use in callbacks
  WidgetRef? _storedRef;

  FaceDetector? _faceDetector;
  bool _isProcessingFrame = false;

  @override
  void initState() {
    super.initState();
    _storedRef = ref;
    _initFaceDetector();
    _initCamera(ref);

    // Listen to volume button presses for capture
    // VolumeController.instance.showSystemUI = false;
    // VolumeController.instance.addListener((volume) {
    //   if (_isPoseCorrect &&
    //       !_isCapturing &&
    //       _capturedImage == null &&
    //       mounted) {
    //     if (_storedRef != null) {
    //       _captureAndNavigate(_storedRef!);
    //     }
    //   }
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final show = await SecureStorage().getMedicalDisclaimer();
      if (show) {
        MedicalDisclaimerBottomSheet.show(context);
      }
    });
  }

  Future<void> _initFaceDetector() async {
    _faceDetector = await FaceDetector.create(minScore: 0.5, minFaceSize: 0.1);
  }

  CameraFrameRotation? _getRotation(int sensorOrientation) {
    switch (sensorOrientation) {
      case 90:
        return CameraFrameRotation.cw90;
      case 180:
        return CameraFrameRotation.cw180;
      case 270:
        return CameraFrameRotation.cw270;
      default:
        return null;
    }
  }

  void _onFrameAvailable(CameraImage image) async {
    if (_faceDetector == null ||
        _isProcessingFrame ||
        _isCapturing ||
        _capturedImage != null) {
      return;
    }

    _isProcessingFrame = true;

    try {
      final faces = await _faceDetector!.detectFacesFromCameraImage(
        image,
        rotation: _getRotation(
          _cameraController!.description.sensorOrientation,
        ),
      );

      bool isPoseCorrect = false;
      if (faces.isNotEmpty) {
        final face = faces.first;
        isPoseCorrect = face.isCorrectPose(widget.pose);
      }

      if (_isPoseCorrect != isPoseCorrect) {
        setState(() {
          _isPoseCorrect = isPoseCorrect;
        });
        if (_isPoseCorrect) {
          // if (await Vibration.hasVibrator()) {
          await Vibration.vibrate(duration: 200);
          await Future.delayed(const Duration(milliseconds: 200));
          // }
          _startCountdown();
        } else {
          _stopCountdown();
        }
      }
    } catch (e) {
      log('Face detection error: $e');
    } finally {
      _isProcessingFrame = false;
    }
  }

  void _startCountdown() {
    if (_isCountingDown || _isCapturing || _capturedImage != null) return;

    setState(() {
      _isCountingDown = true;
      _countdown = 3;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        _stopCountdown();
        if (_isPoseCorrect && _storedRef != null) {
          _captureAndNavigate(_storedRef!);
        }
      }
    });
  }

  void _stopCountdown() {
    _timer?.cancel();
    _timer = null;
    if (mounted) {
      setState(() {
        _isCountingDown = false;
        _countdown = 3;
      });
    }
  }

  Future<void> _toggleCamera() async {
    if (_cameraController == null || _isCapturing || _capturedImage != null) {
      return;
    }

    final cameras = await availableCameras();
    if (cameras.length < 2) return;

    final newDescription = cameras.firstWhere(
      (camera) =>
          camera.lensDirection != _cameraController!.description.lensDirection,
      orElse: () => cameras.first,
    );

    // Stop and dispose old controller
    if (_cameraController!.value.isStreamingImages) {
      await _cameraController!.stopImageStream();
    }
    await _cameraController!.dispose();

    if (!mounted) return;

    setState(() {
      _cameraController = null;
      _isPoseCorrect = false;
    });

    _initCamera(_storedRef!, description: newDescription);
  }

  Future<void> _initCamera(
    WidgetRef ref, {
    CameraDescription? description,
  }) async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          _showError('No cameras available');
        }
        return;
      }

      final target =
          description ??
          cameras.firstWhere(
            (c) => c.lensDirection == .front,
            orElse: () => cameras.first,
          );

      _cameraController = CameraController(
        target,
        ResolutionPreset.veryHigh, // HD quality
        enableAudio: false,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();

      if (!mounted) return;

      // Start face detection stream for automatic capture
      _cameraController!.startImageStream(_onFrameAvailable);

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

    _stopCountdown();

    setState(() {
      _isCapturing = true;
      _isPoseCorrect = false;
    });

    // Stop image stream before capture to avoid potential camera freezes on some devices
    try {
      if (_cameraController!.value.isStreamingImages) {
        await _cameraController!.stopImageStream();
      }
    } catch (e) {
      log("Error stopping image stream: $e");
    }

    try {
      final image = await _cameraController!.takePicture();

      // Process image: flip (if front camera) and crop in a single operation for better performance
      final finalImage = await cropImageToCircle(
        image,
        centerXPercent: 0.5, // Center horizontally
        centerYPercent: 0.42, // Position at top (28% from top)
        radiusPercent: 0.5, // 50% of image width
        flipHorizontally:
            _cameraController!.description.lensDirection == .front,
      );

      // Store captured image in state to show in dialog
      if (!mounted) return;

      setState(() {
        _capturedImage = finalImage;
        _isCapturing = false;
      });

      // Show dialog with captured image
      if (mounted) {
        _showImageVerificationDialog(ref, finalImage);
      }
    } catch (e) {
      log("Capture error: $e");
      setState(() {
        _isCapturing = false;
      });
      // Restart stream if capture failed
      if (_cameraController != null &&
          !_cameraController!.value.isStreamingImages) {
        _cameraController!.startImageStream(_onFrameAvailable);
      }
    }
  }

  void _showImageVerificationDialog(WidgetRef ref, XFile capturedImage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: context.w(20)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.r(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(context.w(20)),
                child: Text(
                  "Verify your image",
                  style: CustomFonts.black24w600,
                  textAlign: TextAlign.center,
                ),
              ),
              // Captured image
              Container(
                margin: EdgeInsets.symmetric(horizontal: context.w(20)),
                height: context.h(300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.r(15)),
                  border: Border.all(
                    color: CustomColors.lightPurpleColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(context.r(13)),
                  child: Image.file(
                    File(capturedImage.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              SizedBox(height: context.h(30)),
              // Buttons
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(20),
                  vertical: context.h(20),
                ),
                child: Row(
                  children: [
                    // Recapture button
                    Expanded(
                      child: CustomBorderedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _capturedImage = null;
                            _isCapturing = false;
                          });
                          // Restart image stream for detection
                          if (_cameraController != null &&
                              !_cameraController!.value.isStreamingImages) {
                            _cameraController!.startImageStream(
                              _onFrameAvailable,
                            );
                          }
                        },
                        // style: OutlinedButton.styleFrom(
                        //   padding: EdgeInsets.symmetric(
                        //     vertical: context.h(16),
                        //   ),
                        //   side: const BorderSide(
                        //     color: CustomColors.purpleColor,
                        //     width: 2,
                        //   ),
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(context.r(12)),
                        //   ),
                        // ),
                        text:
                        // Text(
                          "Recapture",
                          // style: CustomFonts.black18w600.copyWith(
                          //   color: CustomColors.purpleColor,
                          // ),
                       // ),
                      ),
                    ),
                    SizedBox(width: context.w(16)),
                    // Submit button
                    Expanded(
                      child: CustomButton(
                        onPressed: () async {
                          // Store captured image in view model
                          ref
                              .read(treatmentViewModel.notifier)
                              .setCapturedImage(
                                capturedImage,
                                pose: widget.pose,
                              );

                          Navigator.pop(context);
                          if (mounted) {
                            Navigator.pop(context, capturedImage);
                          }
                        },
                        text: "Submit",
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
    _timer?.cancel();
    _cameraController?.dispose();
    _faceDetector?.dispose();
    // VolumeController.instance.removeListener();
    super.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep the treatment state alive by watching it
    ref.watch(treatmentViewModel.select((s) => s));

    return Scaffold(
      backgroundColor: Colors.black,
      body: _cameraController != null
          ? _buildCameraView()
          : const SizedBox.shrink(),
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
                      if (_isCountingDown)
                        Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                            child: Text(
                              '$_countdown',
                              key: ValueKey<int>(_countdown),
                              style: TextStyle(
                                fontSize: context.sp(120),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(
                                    blurRadius: 10,
                                    color: Colors.black54,
                                    offset: Offset(0, 4),
                                  ),
                                ],
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
          Positioned(
            top: context.h(40),
            left: context.w(15),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: context.h(40),
            right: context.w(15),
            child: IconButton(
              icon: const Icon(
                Icons.flip_camera_ios_outlined,
                color: Colors.white,
              ),
              onPressed: _toggleCamera,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(30),
                  vertical: context.h(5),
                ),
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
                    SizedBox(height: context.h(24)),
                    Text(
                      "Face Scan",
                      style: CustomFonts.white22w600.copyWith(
                        fontSize: context.sp(24),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: context.h(4)),
                    Text(
                      "We'll scan your face and create a cool model just for you to enhance your experience!",
                      style: CustomFonts.white22w600.copyWith(
                        fontSize: context.sp(14),
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: context.h(20)),
                    _buildInstructionRow(
                      icon: SvgAssets.eye,
                      text: widget.pose == 'front'
                          ? "Face forward and make sure your eyes are clearly visible."
                          : widget.pose == 'left'
                          ? "Turn your face to the left so your profile is clearly visible."
                          : "Turn your face to the right so your profile is clearly visible.",
                      iconHeight: context.h(24),
                      iconWidth: context.w(26),
                    ),
                    SizedBox(height: context.h(16)),
                    _buildInstructionRow(
                      icon: SvgAssets.profileIcon,
                      text: "Align your face within the frame.",
                      iconHeight: context.h(24),
                      iconWidth: context.w(24),
                      iconColor: CustomColors.purpleColor,
                    ),
                    SizedBox(height: context.h(16)),
                    _buildInstructionRow(
                      icon: SvgAssets.glasses,
                      text:
                          "Remove anything that covers your face eg: Eye glasses, Cap etc",
                      iconHeight: context.h(8),
                      iconWidth: context.w(22),
                    ),
                    SizedBox(height: context.h(16)),
                    // _buildInstructionRow(
                    //   icon: SvgAssets.face,
                    //   text: "Move Your Face Inside The Border",
                    //   iconHeight: context.h(24),
                    //   iconWidth: context.w(22),
                    // ),
                    // SizedBox(height: context.h(16)),
                    _buildInstructionRow(
                      icon: Icons.warning,
                      iconColor: CustomColors.purpleColor,
                      text:
                          "The app is not a medical device. Any results provided are for informational and aesthetic purposes only.",
                      iconHeight: context.h(24),
                      iconWidth: context.w(22),
                    ),
                    SizedBox(height: context.h(30)),
                    _buildCaptureButton(),
                    SizedBox(height: context.h(20)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureButton() {
    if (_isCapturing) {
      return const AppLoader();
    }
    return const SizedBox.shrink();
    // return SizedBox(
    //   width: double.infinity,
    //   child: Container(
    //     decoration: BoxDecoration(
    //       color: _isPoseCorrect ? CustomColors.purpleColor : Colors.grey,
    //       borderRadius: BorderRadius.circular(context.r(12)),
    //     ),
    //     child: Material(
    //       color: Colors.transparent,
    //       child: InkWell(
    //         onTap: (_isCapturing || !_isPoseCorrect)
    //             ? null
    //             : () {
    //                 if (_storedRef != null) {
    //                   _captureAndNavigate(_storedRef!);
    //                 }
    //               },
    //         borderRadius: BorderRadius.circular(context.r(12)),
    //         child: Container(
    //           padding: EdgeInsets.symmetric(vertical: context.h(18)),
    //           alignment: Alignment.center,
    //           child: _isCapturing
    //               ? SizedBox(
    //                   height: context.h(20),
    //                   width: context.w(20),
    //                   child: const CircularProgressIndicator(
    //                     strokeWidth: 2,
    //                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    //                   ),
    //                 )
    //               : Text("Capture", style: CustomFonts.white18w600),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
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
        SizedBox(width: context.w(17)),
        Flexible(
          child: Text(
            text,
            style: CustomFonts.white22w600.copyWith(
              fontSize: context.sp(14),
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
