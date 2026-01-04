import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:http/http.dart' as http;
import 'package:skinsync_ai/utills/image_utills.dart';

import '../../utills/custom_fonts.dart';
import '../../view_models/face_scan_provider.dart';
import '../../widgets/face_scan_radial_widget.dart';
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

  InputImageRotation _rotationFromCamera(CameraDescription camera) {
    // iOS front camera typically has 270 degree rotation
    // Android front camera typically has 90 degree rotation
    if (Platform.isIOS) {
      switch (camera.sensorOrientation) {
        case 0:
          return InputImageRotation.rotation0deg;
        case 90:
          return InputImageRotation.rotation90deg;
        case 180:
          return InputImageRotation.rotation180deg;
        case 270:
          return InputImageRotation.rotation270deg;
        default:
          return InputImageRotation
              .rotation270deg; // Default for iOS front camera
      }
    } else {
      switch (camera.sensorOrientation) {
        case 0:
          return InputImageRotation.rotation0deg;
        case 90:
          return InputImageRotation.rotation90deg;
        case 180:
          return InputImageRotation.rotation180deg;
        case 270:
          return InputImageRotation.rotation270deg;
        default:
          return InputImageRotation
              .rotation90deg; // Default for Android front camera
      }
    }
  }

  InputImage _inputImageFromCameraImage(
    CameraImage image,
    CameraDescription camera,
  ) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final rotation = _rotationFromCamera(camera);

    // iOS uses bgra8888, Android uses nv21
    final format = Platform.isIOS
        ? InputImageFormat.bgra8888
        : InputImageFormat.nv21;

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  Future<void> _process(WidgetRef ref, CameraImage image) async {
    final provider = ref.read(faceScanProvider.notifier);

    final inputImage = _inputImageFromCameraImage(
      image,
      _cameraController!.description,
    );

    final faces = await _faceDetector.processImage(inputImage);

    if (faces.isEmpty) {
      provider.reset();
      return;
    }

    provider.faceDetected();

    final face = faces.first;
    final previewSize = _cameraController!.value.previewSize!;

    final faceCenter = face.boundingBox.center;
    final previewCenter = Offset(previewSize.width / 2, previewSize.height / 2);

    final distance = (faceCenter - previewCenter).distance;
    final allowedRadius = previewSize.width * 0.3;

    if (distance <= allowedRadius) {
      provider.faceCentered();
    }
  }

  Future<Map<String, dynamic>?> uploadCapturedImage({
    required XFile image,
    required String apiUrl,
    String? token, // optional auth token
  }) async {
    try {
      final uri = Uri.parse(apiUrl);
      final request = http.MultipartRequest('POST', uri);

      // Optional headers
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Attach image
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          filename: image.name,
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);

      // Check if server returned an error response
      if (responseData['success'] == false) {
        final errorMessage = responseData['message'] ?? 'Upload failed';
        throw Exception(errorMessage);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Image uploaded successfully');
        return responseData;
      } else {
        print('❌ Upload failed: ${response.statusCode}');
        final errorMessage = responseData['message'] ?? 'Upload failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> _captureAndNavigate(WidgetRef ref) async {
    final state = ref.read(faceScanProvider);
    if (_cameraController == null || state.isCapturing) return;

    // Stop the image stream first
    await _cameraController!.stopImageStream();

    // Turn off flash
    await _cameraController!.setFlashMode(FlashMode.off);
    if (state.flash) {
      ref.read(faceScanProvider.notifier).toggleFlash();
    }

    // Capture the image
    final image = await _cameraController!.takePicture();

    // Flip the image if using front camera (to match the mirrored preview)
    XFile finalImage = image;
    if (_cameraController!.description.lensDirection ==
        CameraLensDirection.front) {
      finalImage = await flipXFileHorizontally(image);
    }

    // Store captured image and set processing state
    setState(() {
      _capturedImage = finalImage;
    });

    // Mark as capturing in provider
    ref.read(faceScanProvider.notifier).markCaptured(finalImage);

    if (!mounted) return;

    ref.read(faceScanProvider.notifier).reset();
    setState(() {
      _capturedImage = null;
    });

    Navigator.pushReplacementNamed(
      context,
      // ArFaceModelPreviewScreen.routeName
      ServiceSelectionScreen.routeName,
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(faceScanProvider, (prev, next) {
      if (next.progress == 1.0) {
        _captureAndNavigate(ref);
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_cameraController != null) _buildCameraView(),
          Consumer(
            builder: (_, ref, _) {
              final isCapturing = ref.watch(
                faceScanProvider.select((state) => state.isCapturing),
              );
              if (isCapturing) return const SizedBox.shrink();

              return Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 40.h, right: 20.w),
                  child: GestureDetector(
                    onTap: () {
                      ref.read(faceScanProvider.notifier).toggleFlash();
                      if (_cameraController != null) {
                        _cameraController!.setFlashMode(
                          ref.read(faceScanProvider).flash
                              ? FlashMode.torch
                              : FlashMode.off,
                        );
                      }
                    },
                    child: Consumer(
                      builder: (_, ref, child) {
                        final flash = ref.watch(
                          faceScanProvider.select((state) => state.flash),
                        );
                        return Icon(
                          flash ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                          size: 30.sp,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),

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
                child: Consumer(
                  builder: (_, ref, _) {
                    final state = ref.watch(faceScanProvider);
                    final progress = state.progress;
                    final isCapturing = state.isCapturing;

                    String message;
                    if (isCapturing) {
                      message = "Please wait";
                    } else if (progress == 1.0) {
                      message = "Hold still...";
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
          child: CameraPreview(
            _cameraController!,
            child: Center(
              child: Consumer(
                builder: (_, ref, _) {
                  final progress = ref.watch(
                    faceScanProvider.select((state) => state.progress),
                  );
                  return CustomPaint(
                    painter: FaceScanPainter(progress: progress),
                    child: const SizedBox(width: 300, height: 300),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
