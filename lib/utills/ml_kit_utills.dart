  import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

InputImageRotation rotationFromCamera(CameraDescription camera) {
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

    InputImage inputImageFromCameraImage(
    CameraImage image,
    CameraDescription camera,
  ) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final rotation = rotationFromCamera(camera);

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