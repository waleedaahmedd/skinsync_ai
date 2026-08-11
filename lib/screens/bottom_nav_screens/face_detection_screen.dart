import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:face_detection_tflite/face_detection_tflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_litert/flutter_litert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';
import 'package:volume_controller/volume_controller.dart';

import '../../utills/color_constant.dart';
import '../../utills/custom_fonts.dart';
import '../../utills/face_detection_utils.dart';
import '../../utills/image_utills.dart';
import '../../utills/secure_storage_service.dart';
import '../../utills/tts_utils.dart';
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

class _FaceDetectionScreenState extends ConsumerState<FaceDetectionScreen> with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  XFile? _capturedImage;

  bool _isCapturing = false;
  bool _isPoseCorrect = false;

  int _countdown = 3;
  Timer? _timer;
  bool _isCountingDown = false;

  Timer? _manualCaptureTimer;
  bool _showManualCaptureUI = false;

  // Store ref for use in callbacks
  WidgetRef? _storedRef;

  FaceDetector? _faceDetector;
  bool _isFaceDetectorError = false;
  bool _isProcessingFrame = false;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _storedRef = ref;
    _initFaceDetector();
    _initCamera(ref);
    _initTts();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _startManualCaptureTimer();
    _listenToVolumeButtons();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final show = await SecureStorage().getMedicalDisclaimer();
      if (show) {
        MedicalDisclaimerBottomSheet.show(context);
      }
    });
  }

  Future<void> _initTts() async {
    await TtsUtils.init();
    // Don't speak immediately, wait for camera initialization in _initCamera
  }

  void _speakInstruction() {
    final isFrontCamera = _cameraController?.description.lensDirection == CameraLensDirection.front;
    
    String ttsText = "";
    if (widget.pose == 'front') {
      ttsText = "Please look straight and keep your face inside the circle.";
    } else if (isFrontCamera) {
      // In mirrored selfie mode, turning head to the right shows the left profile
      if (widget.pose == 'left') {
        ttsText = "Please turn your head to the right to capture your left profile.";
      } else {
        ttsText = "Please turn your head to the left to capture your right profile.";
      }
    } else {
      // Rear camera (no mirror)
      if (widget.pose == 'left') {
        ttsText = "Please turn your head to the left.";
      } else {
        ttsText = "Please turn your head to the right.";
      }
    }
    TtsUtils.speak(ttsText);
  }

  Future<void> _initFaceDetector() async {
    setState(() {
      _isFaceDetectorError = false;
    });

    try {
      bool shouldPreferCpu = false;
      
      // Check for legacy iOS devices that don't support L2_NORMALIZATION on GPU
      if (Platform.isIOS) {
        final deviceInfo = DeviceInfoPlugin();
        final iosInfo = await deviceInfo.iosInfo;
        final model = iosInfo.utsname.machine; // e.g., "iPhone9,1"
        
        // iPhone 7 (9,1/9,3), 7 Plus (9,2/9,4), 6s (8,1), 6s Plus (8,2), SE 1st gen (8,4)
        if (model.contains('iPhone8,') || model.contains('iPhone9,')) {
          shouldPreferCpu = true;
        }
      }

      if (shouldPreferCpu) {
        log('Legacy iOS device detected, skipping GPU to avoid errors');
        _faceDetector = await FaceDetector.create(
          minScore: 0.4,
          minFaceSize: 0.1,
          performanceConfig: const PerformanceConfig.xnnpack(),
        );
        log('FaceDetector initialized successfully (XNNPACK)');
      } else {
        // 1. Try GPU acceleration
        _faceDetector = await FaceDetector.create(
          minScore: 0.4,
          minFaceSize: 0.1,
          performanceConfig: const PerformanceConfig.gpu(),
        );
        log('FaceDetector initialized successfully (GPU)');
      }
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      log('Primary initialization failed, trying fallback: $e');
      try {
        // 2. Fallback to CPU-optimized XNNPACK
        _faceDetector = await FaceDetector.create(
          minScore: 0.5,
          minFaceSize: 0.1,
          performanceConfig: const PerformanceConfig.xnnpack(),
        );
        if (mounted) {
          setState(() {});
        }
      } catch (e2) {
        log('Initialization failed completely: $e2');
        if (mounted) {
          setState(() {
            _isFaceDetectorError = true;
          });
        }
      }
    }

    // Safety timeout: if still null after 10 seconds, show manual capture
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _faceDetector == null) {
        setState(() {
          _isFaceDetectorError = true;
        });
      }
    });
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
      final rotation = _getRotation(
        _cameraController!.description.sensorOrientation,
      );
      
      final faces = await _faceDetector!.detectFacesFromCameraImage(
        image,
        rotation: rotation,
      );

      // log('Detected faces: ${faces.length}, Rotation: $rotation');

      bool isPoseCorrect = false;
      if (faces.isNotEmpty) {
        final face = faces.first;
        isPoseCorrect = face.isCorrectPose(widget.pose);
        // log('Pose correct: $isPoseCorrect, Score: ${face.detectionData.score}');
        
        // If a face is detected and pose is becoming correct, we can hide the manual capture message
        if (isPoseCorrect && _showManualCaptureUI) {
          setState(() {
            _showManualCaptureUI = false;
          });
          _startManualCaptureTimer(); // Reset the timer
        }
      }

      if (_isPoseCorrect != isPoseCorrect) {
        setState(() {
          _isPoseCorrect = isPoseCorrect;
        });
        if (_isPoseCorrect) {
          // Use robust HapticFeedback
          try {
            HapticFeedback.vibrate(); // Generic vibration for maximum compatibility
            HapticFeedback.mediumImpact();
          } catch (e) {
            log("Haptic feedback error: $e");
          }
          
          TtsUtils.speak("Hold still");
          // Give TTS time to say "hold still" before starting countdown numbers
          await Future.delayed(const Duration(milliseconds: 1000));
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

    TtsUtils.speak("$_countdown");

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
        TtsUtils.speak("$_countdown");
      } else {
        _stopCountdown();
        if (_isPoseCorrect && _storedRef != null) {
          TtsUtils.speak("Perfect");
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

    // 1. Capture the old controller and set the state controller to null immediately
    final oldController = _cameraController;
    setState(() {
      _cameraController = null;
      _isPoseCorrect = false;
    });

    // 2. Safely stop and dispose the old controller in the background
    if (oldController != null) {
      if (oldController.value.isStreamingImages) {
        await oldController.stopImageStream();
      }
      await oldController.dispose();
    }

    if (!mounted) return;

    // 3. Initialize the new camera
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
        ResolutionPreset.veryHigh, // HD quality
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      // Start face detection stream for automatic capture
      log('Starting image stream. Sensor orientation: ${controller.description.sensorOrientation}');
      controller.startImageStream(_onFrameAvailable);

      setState(() {
        _cameraController = controller;
      });

      _speakInstruction();
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

  void _startManualCaptureTimer() {
    _manualCaptureTimer?.cancel();
    _manualCaptureTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && !_isCountingDown && !_isCapturing && _capturedImage == null) {
        setState(() {
          _showManualCaptureUI = true;
        });
      }
    });
  }

  void _listenToVolumeButtons() {
    VolumeController.instance.addListener((volume) {
      if (mounted && _showManualCaptureUI && !_isCapturing && _capturedImage == null) {
        _captureAndNavigate(_storedRef!);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _manualCaptureTimer?.cancel();
    VolumeController.instance.removeListener();
    _cameraController?.dispose();
    _faceDetector?.dispose();
    _pulseController.dispose();
    TtsUtils.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep the treatment state alive by watching it
    ref.watch(treatmentViewModel.select((s) => s));

    return Scaffold(
      backgroundColor: Colors.black,
      body: _cameraController != null && _cameraController!.value.isInitialized
          ? _buildCameraView()
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildCameraView() {
    // If we have a captured image, show it instead of camera preview
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
          // Top Navigation and Progress
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
                      _buildHeaderButton(
                        icon: Icons.flip_camera_ios_outlined,
                        onTap: _toggleCamera,
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
    );
  }

  Widget _buildHeaderButton({required IconData icon, required VoidCallback onTap}) {
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
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(8)),
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
              color: isCurrent ? CustomColors.purpleColor : Colors.white.withValues(alpha: 0.3),
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
              padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(6)),
              decoration: BoxDecoration(
                color: _isPoseCorrect ? CustomColors.purpleColor.withValues(alpha: 0.2) : Colors.white10,
                borderRadius: BorderRadius.circular(context.r(12)),
                border: Border.all(color: _isPoseCorrect ? CustomColors.purpleColor : Colors.white24),
              ),
              child: Text(
                _isFaceDetectorError || _showManualCaptureUI
                    ? "MANUAL CAPTURE MODE"
                    : (_isPoseCorrect ? "POSE CORRECT" : "ALIGN YOUR FACE"),
                style: TextStyle(
                  color: _isPoseCorrect || _isFaceDetectorError || _showManualCaptureUI
                      ? CustomColors.purpleColor 
                      : Colors.white70,
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
              _isFaceDetectorError || _showManualCaptureUI
                  ? "Position your face and capture"
                  : "Keep your face within the frame for auto-capture",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: context.sp(14),
              ),
            ),
            if (_showManualCaptureUI && !_isFaceDetectorError)
              Padding(
                padding: EdgeInsets.only(top: context.h(8)),
                child: Text(
                  "Tip: You can also press the Volume button to capture",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CustomColors.purpleColor,
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            SizedBox(height: context.h(28)),

            // Professional Tips Section
            _buildProfessionalTips(),

            SizedBox(height: context.h(24)),
            if (_isCapturing)
              const AppLoader()
            else if (_isFaceDetectorError || _showManualCaptureUI)
              Padding(
                padding: EdgeInsets.only(bottom: context.h(20)),
                child: CustomButton(
                  onPressed: () => _captureAndNavigate(_storedRef!),
                  text: "Capture Image",
                ),
              )
            else
              SizedBox(height: context.h(52)), // Fixed height spacer
          ],
        ),
      ),
    );
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
      padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(10)),
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
    final isFrontCamera = _cameraController?.description.lensDirection == CameraLensDirection.front;
    
    if (widget.pose == 'front') return "Look Straight";
    
    if (isFrontCamera) {
      // In mirrored selfie mode, turning head to the right shows the left profile
      return widget.pose == 'left' ? "Turn Right" : "Turn Left";
    } else {
      // Rear camera (no mirror)
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

    // 1. Create a darkened background with a circular hole
    final backgroundPaint = Paint()..color = Colors.black.withValues(alpha: 0.7);
    final cutoutPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: center, radius: centerRadius))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(cutoutPath, backgroundPaint);

    // 2. Draw the main circular guide border
    final guideColor = isPoseCorrect
        ? CustomColors.purpleColor
        : Colors.white.withValues(alpha: 0.6);
    
    final borderPaint = Paint()
      ..color = guideColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    
    canvas.drawCircle(center, centerRadius, borderPaint);

    // 3. Draw a pulsing outer ring if pose is correct
    if (isPoseCorrect) {
      final pulsePaint = Paint()
        ..color = guideColor.withValues(alpha: 0.3 * (1 - pulseValue))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 + (10 * pulseValue);
      
      canvas.drawCircle(center, centerRadius + (20 * pulseValue), pulsePaint);
    }

    // 4. Draw corner brackets for a technical "scanning" look
    final bracketPaint = Paint()
      ..color = guideColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    const bracketPadding = 10.0;
    const bracketWidth = 0.5;
    final r = centerRadius + bracketPadding;

    // Technical brackets (corners of a square inscribed/circumscribed)
    // Top Left
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      3.14159 + 0.2, // 180 deg
      bracketWidth,
      false,
      bracketPaint,
    );
    // Top Right
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      -0.7,
      bracketWidth,
      false,
      bracketPaint,
    );
    // Bottom Left
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      3.14159 / 2 + 0.2,
      bracketWidth,
      false,
      bracketPaint,
    );
    // Bottom Right
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
