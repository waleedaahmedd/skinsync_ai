import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';
import 'package:skinsync_ai/utills/custom_fonts.dart';

import '../../route_generator.dart';
import '../../view_models/face_scan_provider.dart';
import '../../widgets/face_scan_radial_widget.dart';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key});

  @override
  State<FaceDetectionScreen> createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  CameraController? _cameraController;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(enableClassification: true),
    );
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      front,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    _cameraController!.startImageStream((image) {
      if (_isDetecting) return;
      _isDetecting = true;

      _process(image).whenComplete(() {
        _isDetecting = false;
      });
    });

    setState(() {});
  }
  InputImageRotation _rotationFromCamera(CameraDescription camera) {
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
      return InputImageRotation.rotation0deg;
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

  return InputImage.fromBytes(
    bytes: bytes,
    metadata: InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      format: InputImageFormat.nv21, // ✅ Android
      bytesPerRow: image.planes.first.bytesPerRow,
    ),
  );
}


Future<void> _process(CameraImage image) async {
  final provider = context.read<FaceScanProvider>();

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
  final previewCenter =
      Offset(previewSize.width / 2, previewSize.height / 2);

  final distance = (faceCenter - previewCenter).distance;
  final allowedRadius = previewSize.width * 0.3;

  if (distance <= allowedRadius) {
    provider.faceCentered();
  }
}


  Future<void> _captureAndNavigate() async {
    final provider = context.read<FaceScanProvider>();
    if (_cameraController == null || provider.isCapturing) return;
    await Future.delayed( Duration(milliseconds: 500));
    final image = await _cameraController!.takePicture();
    await _cameraController!.stopImageStream();
    

    provider.markCaptured(image);

    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      faceScanningCompleteScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FaceScanProvider>(
      builder: (_, provider, __) {
        if (provider.progress == 1.0) {
          _captureAndNavigate();
        }
    
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              if (_cameraController != null)
                SizedBox(
                  height: 1.sh,
                  child: CameraPreview(_cameraController!)),
    
              Center(
                child: CustomPaint(
                  painter: FaceScanPainter(progress: provider.progress),
                  child: const SizedBox(width: 300, height: 300),
                ),
              ),
    
              Positioned(
                top: 10.h,
                left: 20.w,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 18.w),
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
                  padding:  EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 34.h, horizontal: 52.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      provider.progress == 1.0
                          ? "Hold still..."
                          : "Align your face",
                      textAlign: TextAlign.center,
                      style: CustomFonts.black28w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
