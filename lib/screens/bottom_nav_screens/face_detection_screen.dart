import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_detection_tflite/face_detection_tflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vibration/vibration.dart';

import '../../utils/color_constant.dart';
import '../../utils/custom_fonts.dart';
import '../../utils/image_utills.dart';
import '../../utils/secure_storage_service.dart';
import '../../utils/tts_utils.dart';
import '../../utils/volume_button_service.dart';
import '../../view_models/treatment_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/bottom_sheets/medical_disclaimer_bottomsheet.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/dialogs/bipa_consent_dialog.dart';

class FaceDetectionScreen extends ConsumerStatefulWidget {
  final String pose;
  const FaceDetectionScreen({super.key, this.pose = 'front'});

  static const String routeName = '/FaceDetectionScreen';

  @override
  ConsumerState<FaceDetectionScreen> createState() =>
      _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends ConsumerState<FaceDetectionScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  XFile? _capturedImage;

  bool _isCapturing = false;
  bool _isConsentAccepted = false;
  bool _isPoseCorrect = false;
  bool _isProcessing = false;
  bool _isSoundOn = true;
  bool _isAutomaticMode = false;

  FaceDetector? _detector;

  final VolumeButtonService _volumeButtonService = VolumeButtonService();

  // Store ref for use in callbacks
  WidgetRef? _storedRef;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _storedRef = ref;
    _initDetector();
    _initCamera(ref);
    _initTts();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _volumeButtonService.enableInterception();
    _volumeButtonService.startListening((event) {
      if (!mounted || _isAutomaticMode) return;
      if (!_isCapturing && _capturedImage == null) {
        _handleCaptureTrigger();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showBipaConsentDialog(
        context: context,
        onAccepted: () {
          _isConsentAccepted = true;
        },
      );

      if (mounted) {
        _showModeSelectionDialog();
      }

      final show = await SecureStorage().getMedicalDisclaimer();
      if (show) {
        MedicalDisclaimerBottomSheet.show(context);
      }
    });
  }

  Future<void> _initTts() async {
    await TtsUtils.init();
  }

  void _speakInstruction() {
    if (!_isSoundOn) return;
    final isFrontCamera =
        _cameraController?.description.lensDirection ==
        CameraLensDirection.front;

    String ttsText = "";
    if (widget.pose == 'front') {
      ttsText = "Please look straight and keep your face inside the circle.";
    } else if (isFrontCamera) {
      if (widget.pose == 'left') {
        ttsText =
            "Please turn your head to the right to capture your left profile.";
      } else {
        ttsText =
            "Please turn your head to the left to capture your right profile.";
      }
    } else {
      if (widget.pose == 'left') {
        ttsText = "Please turn your head to the left.";
      } else {
        ttsText = "Please turn your head to the right.";
      }
    }
    TtsUtils.speak(ttsText);
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

    final oldController = _cameraController;
    setState(() {
      _cameraController = null;
    });

    if (oldController != null) {
      await oldController.dispose();
    }

    if (!mounted) return;

    _initCamera(_storedRef!, description: newDescription);
    _speakInstruction();
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
            (c) => c.lensDirection == CameraLensDirection.front,
            orElse: () => cameras.first,
          );

      final controller = CameraController(
        target,
        ResolutionPreset.veryHigh,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
      });

      // Start image stream for face detection
      await controller.startImageStream((image) {
        _processCameraImage(image);
      });

      _speakInstruction();
    } catch (e) {
      if (mounted) {
        _showError('Failed to initialize camera: $e');
      }
    }
  }

  Future<void> _initDetector() async {
    try {
      _detector = await FaceDetector.create(
        model: FaceDetectionModel.frontCamera,
        minScore: 0.4,
      );
    } catch (e) {
      log("Error initializing face detector: $e");
    }
  }

  void _showModeSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(context.w(20)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.r(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose Capture Mode",
                style: CustomFonts.black22w600,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.h(10)),
              Text(
                "Select how you want to capture your photos",
                style: TextStyle(color: Colors.grey, fontSize: context.sp(14)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.h(24)),
              _buildModeOption(
                icon: Iconsax.magicpen,
                title: "Automatic Capture",
                subtitle: "Captures automatically when aligned",
                isSelected: _isAutomaticMode,
                onTap: () {
                  setState(() => _isAutomaticMode = true);
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: context.h(12)),
              _buildModeOption(
                icon: Iconsax.camera,
                title: "Manual Capture",
                subtitle: "You control the capture button",
                isSelected: !_isAutomaticMode,
                onTap: () {
                  setState(() => _isAutomaticMode = false);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.w(16)),
        decoration: BoxDecoration(
          color: isSelected
              ? CustomColors.purpleColor.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(context.r(16)),
          border: Border.all(
            color: isSelected ? CustomColors.purpleColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? CustomColors.purpleColor : Colors.grey,
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: CustomFonts.black16w600.copyWith(
                      color: isSelected
                          ? CustomColors.purpleColor
                          : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: context.sp(12),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: CustomColors.purpleColor),
          ],
        ),
      ),
    );
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_detector == null ||
        _isProcessing ||
        _isCapturing ||
        _capturedImage != null) {
      return;
    }

    _isProcessing = true;

    try {
      final faces = await _detector!.detectFacesFromCameraImage(
        image,
        mode: FaceDetectionMode.standard,
      );

      if (!mounted) return;

      if (faces.isEmpty) {
        if (_isPoseCorrect) {
          setState(() => _isPoseCorrect = false);
        }
        return;
      }

      final face = faces.first;
      final yaw = face.headEulerAngleY ?? 0;
      final pitch = face.headEulerAngleX ?? 0;

      bool isCorrect = false;

      // Basic orientation checks
      if (pitch.abs() < 20) {
        if (widget.pose == 'front') {
          isCorrect = yaw.abs() < 12;
        } else if (widget.pose == 'left') {
          // Adjust based on typical front camera mirroring
          // headEulerAngleY: positive turns face toward right side of image.
          // In front camera (mirrored), turning head left (user's POV) makes face look toward right of image?
          // Let's stick with the previously logic and adjust if needed.
          isCorrect = yaw > 18;
        } else if (widget.pose == 'right') {
          isCorrect = yaw < -18;
        }
      }

      if (_isPoseCorrect != isCorrect) {
        setState(() => _isPoseCorrect = isCorrect);
        if (isCorrect) {
          Vibration.vibrate(duration: 100);
          if (_isAutomaticMode && !_isCapturing && _capturedImage == null) {
            _handleCaptureTrigger();
          }
        }
      }
    } catch (e) {
      log("Face detection error: $e");
    } finally {
      _isProcessing = false;
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

    if (_isSoundOn) {
      TtsUtils.speak("Perfect");
    }

    setState(() {
      _isCapturing = true;
    });

    if (!mounted || _cameraController == null) return;

    try {
      final image = await _cameraController!.takePicture();

      final finalImage = await cropImageToCircle(
        image,
        centerXPercent: 0.5,
        centerYPercent: 0.42,
        radiusPercent: 0.5,
        flipHorizontally:
            _cameraController!.description.lensDirection ==
            CameraLensDirection.front,
      );

      if (!mounted) return;

      setState(() {
        _capturedImage = finalImage;
        _isCapturing = false;
      });

      if (mounted) {
        _showImageVerificationDialog(ref, finalImage);
      }
    } catch (e) {
      log("Capture error: $e");
      setState(() {
        _isCapturing = false;
      });
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
              Padding(
                padding: EdgeInsets.all(context.w(20)),
                child: Text(
                  "Verify your image",
                  style: CustomFonts.black24w600,
                  textAlign: TextAlign.center,
                ),
              ),
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
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(20),
                  vertical: context.h(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        isBorder: true,
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _capturedImage = null;
                            _isCapturing = false;
                          });
                        },
                        text: "Recapture",
                      ),
                    ),
                    SizedBox(width: context.w(16)),
                    Expanded(
                      child: CustomButton(
                        onPressed: () async {
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
    _detector?.dispose();
    _volumeButtonService.dispose();
    _cameraController?.dispose();
    _pulseController.dispose();
    TtsUtils.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(treatmentViewModel.select((s) => s));

    return Scaffold(
      backgroundColor: Colors.black,
      body: _cameraController != null && _cameraController!.value.isInitialized
          ? _buildCameraView()
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildCameraView() {
    if (_capturedImage != null) {
      return SizedBox.expand(
        child: Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
      );
    }

    final previewSize = _cameraController?.value.previewSize;
    if (previewSize == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final aspectRatio = previewSize.height / previewSize.width;
    const circleRadiusPercent = 0.42;
    const circleCenterYPercent = 0.42;

    return GestureDetector(
      onTap: () {
        if (!_isCapturing && _capturedImage == null) {
          _handleCaptureTrigger();
        }
      },
      child: SizedBox.expand(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final canvasWidth = constraints.maxWidth;
                    final canvasHeight = constraints.maxHeight;
                    final circleRadius = canvasWidth * circleRadiusPercent;
                    final circleCenterY = canvasHeight * circleCenterYPercent;
                    return Stack(
                      children: [
                        CameraPreview(_cameraController!),
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: TintOverlayPainter(
                                centerRadius: circleRadius,
                                centerY: circleCenterY,
                                isPoseCorrect: _isPoseCorrect,
                                pulseValue: _pulseController.value,
                              ),
                              child: const SizedBox.expand(),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + context.h(10),
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildHeaderButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                        _buildPoseIndicator(),
                        Row(
                          children: [
                            _buildHeaderButton(
                              icon: _isSoundOn
                                  ? Iconsax.volume_high
                                  : Iconsax.volume_cross,
                              onTap: () {
                                setState(() => _isSoundOn = !_isSoundOn);
                                if (!_isSoundOn) {
                                  TtsUtils.stop();
                                } else {
                                  _speakInstruction();
                                }
                              },
                            ),
                            SizedBox(width: context.w(10)),
                            _buildHeaderButton(
                              icon: Icons.flip_camera_ios_outlined,
                              onTap: _toggleCamera,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildInstructionOverlay(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.w(10)),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: context.sp(20)),
      ),
    );
  }

  Widget _buildPoseIndicator() {
    final poses = ['front', 'left', 'right'];
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(8),
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(context.r(20)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: poses.map((p) {
          final isCurrent = widget.pose == p;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: context.w(4)),
            width: context.w(8),
            height: context.w(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrent
                  ? CustomColors.purpleColor
                  : Colors.white.withValues(alpha: 0.3),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInstructionOverlay() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(24),
          vertical: context.h(24),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.0),
              Colors.black.withValues(alpha: 0.9),
              Colors.black,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(16),
                vertical: context.h(6),
              ),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(context.r(12)),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                "${_isAutomaticMode ? "AUTOMATIC" : "MANUAL"} CAPTURE MODE",
                style: TextStyle(
                  color: CustomColors.purpleColor,
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            SizedBox(height: context.h(16)),
            Text(
              _getInstructionText(),
              style: CustomFonts.white22w600.copyWith(fontSize: context.sp(26)),
            ),
            SizedBox(height: context.h(8)),
            Text(
              _isAutomaticMode
                  ? "Hold steady when aligned to capture"
                  : "Position your face and capture",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: context.sp(14)),
            ),
            Padding(
              padding: EdgeInsets.only(top: context.h(8)),
              child: Text(
                _isAutomaticMode
                    ? "Tip: Keep still for a second once the guide turns purple"
                    : "Tip: You can also tap anywhere or press the Volume button to capture",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomColors.purpleColor,
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: context.h(28)),
            _buildProfessionalTips(),
            SizedBox(height: context.h(24)),
            if (_isCapturing)
              const AppLoader()
            else
              Padding(
                padding: EdgeInsets.only(bottom: context.h(20)),
                child: Column(
                  children: [
                    if (!_isAutomaticMode) ...[
                      CustomButton(
                        onPressed: _isPoseCorrect
                            ? _handleCaptureTrigger
                            : null,
                        text: _isPoseCorrect
                            ? "Capture Image"
                            : "Align Face to Capture",
                      ),
                      SizedBox(height: context.h(16)),
                    ],
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isAutomaticMode = !_isAutomaticMode;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Switched to ${_isAutomaticMode ? "Automatic" : "Manual"} Mode",
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Text(
                        "Switch to ${_isAutomaticMode ? "Manual" : "Automatic"} Mode",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: context.sp(14),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleCaptureTrigger() {
    if (_isConsentAccepted) {
      _captureAndNavigate(_storedRef!);
    } else {
      showBipaConsentDialog(
        context: context,
        onAccepted: () {
          _isConsentAccepted = true;
          _captureAndNavigate(_storedRef!);
        },
      );
    }
  }

  Widget _buildProfessionalTips() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildSmallTip(Iconsax.camera, "Clean lens")),
            SizedBox(width: context.w(12)),
            Expanded(child: _buildSmallTip(Iconsax.flash, "Bright light")),
          ],
        ),
        SizedBox(height: context.h(12)),
        Row(
          children: [
            Expanded(child: _buildSmallTip(Iconsax.frame_1, "Steady hand")),
            SizedBox(width: context.w(12)),
            Expanded(child: _buildSmallTip(Iconsax.user_square, "Clear face")),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallTip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(12),
        vertical: context.h(10),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: context.sp(16), color: CustomColors.purpleColor),
          SizedBox(width: context.w(8)),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: context.sp(12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getInstructionText() {
    final isFrontCamera =
        _cameraController?.description.lensDirection ==
        CameraLensDirection.front;

    if (widget.pose == 'front') return "Look Straight";

    if (isFrontCamera) {
      return widget.pose == 'left' ? "Turn Right" : "Turn Left";
    } else {
      return widget.pose == 'left' ? "Turn Left" : "Turn Right";
    }
  }
}

class TintOverlayPainter extends CustomPainter {
  final double centerRadius;
  final double? centerY;
  final bool isPoseCorrect;
  final double pulseValue;

  TintOverlayPainter({
    required this.centerRadius,
    this.centerY,
    required this.isPoseCorrect,
    this.pulseValue = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, centerY ?? size.height / 2);

    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.7);
    final cutoutPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: center, radius: centerRadius))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(cutoutPath, backgroundPaint);

    final guideColor = isPoseCorrect
        ? CustomColors.purpleColor
        : Colors.white.withValues(alpha: 0.6);

    final borderPaint = Paint()
      ..color = guideColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawCircle(center, centerRadius, borderPaint);

    if (isPoseCorrect) {
      final pulsePaint = Paint()
        ..color = guideColor.withValues(alpha: 0.3 * (1 - pulseValue))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 + (10 * pulseValue);

      canvas.drawCircle(center, centerRadius + (20 * pulseValue), pulsePaint);
    }

    final bracketPaint = Paint()
      ..color = guideColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    const bracketPadding = 10.0;
    const bracketWidth = 0.5;
    final r = centerRadius + bracketPadding;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      3.14159 + 0.2,
      bracketWidth,
      false,
      bracketPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      -0.7,
      bracketWidth,
      false,
      bracketPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      3.14159 / 2 + 0.2,
      bracketWidth,
      false,
      bracketPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      0.2,
      bracketWidth,
      false,
      bracketPaint,
    );
  }

  @override
  bool shouldRepaint(TintOverlayPainter oldDelegate) {
    return oldDelegate.centerRadius != centerRadius ||
        oldDelegate.centerY != centerY ||
        oldDelegate.isPoseCorrect != isPoseCorrect ||
        oldDelegate.pulseValue != pulseValue;
  }
}
