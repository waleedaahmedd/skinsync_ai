import 'dart:io';
import 'dart:ui';

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

/// Crop rect that fits width: full width, height = min(height, width), centered vertically.
Rect _fitWidthCropRect(CameraImage image) {
  final w = image.width.toDouble();
  final h = image.height.toDouble();
  final cropHeight = h < w ? h : w;
  final top = (h - cropHeight) / 2;
  return Rect.fromLTWH(0, top, w, cropHeight);
}

InputImage inputImageFromCameraImage(
    CameraImage image,
    CameraDescription camera, {
    Rect? cropRect,
  }) {
    final effectiveCrop = cropRect ?? _fitWidthCropRect(image);
    final WriteBuffer allBytes = WriteBuffer();
    _cropCameraImage(image, effectiveCrop, allBytes);
    final bytes = allBytes.done().buffer.asUint8List();

    final rotation = rotationFromCamera(camera);
    final format = Platform.isIOS
        ? InputImageFormat.bgra8888
        : InputImageFormat.nv21;
    final imageSize = Size(effectiveCrop.width, effectiveCrop.height);

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: imageSize,
        rotation: rotation,
        format: format,
        bytesPerRow: effectiveCrop.width.toInt() * (Platform.isIOS ? 4 : 1),
      ),
    );
  }

  void _cropCameraImage(CameraImage image, Rect cropRect, WriteBuffer buffer) {
    final x = cropRect.left.toInt();
    final y = cropRect.top.toInt();
    final width = cropRect.width.toInt();
    final height = cropRect.height.toInt();

    if (Platform.isIOS) {
      // BGRA8888 format: 4 bytes per pixel
      final bytesPerRow = image.planes.first.bytesPerRow;
      final bytesPerPixel = 4;
      
      for (int row = y; row < y + height; row++) {
        final startIndex = (row * bytesPerRow) + (x * bytesPerPixel);
        final endIndex = startIndex + (width * bytesPerPixel);
        final rowBytes = image.planes.first.bytes.sublist(startIndex, endIndex);
        buffer.putUint8List(rowBytes);
      }
    } else {
      // NV21 format: Y plane + interleaved UV plane
      final yPlane = image.planes[0];
      final uvPlane = image.planes.length > 1 ? image.planes[1] : null;
      
      // Crop Y plane
      final yBytesPerRow = yPlane.bytesPerRow;
      for (int row = y; row < y + height; row++) {
        final startIndex = (row * yBytesPerRow) + x;
        final endIndex = startIndex + width;
        final rowBytes = yPlane.bytes.sublist(startIndex, endIndex);
        buffer.putUint8List(rowBytes);
      }
      
      // Crop UV plane (interleaved VU, subsampled by 2)
      if (uvPlane != null) {
        final uvX = x ~/ 2;
        final uvY = y ~/ 2;
        final uvWidth = width ~/ 2;
        final uvHeight = height ~/ 2;
        final uvBytesPerRow = uvPlane.bytesPerRow;
        
        // NV21 has interleaved VU pairs (2 bytes per UV sample)
        for (int row = uvY; row < uvY + uvHeight; row++) {
          final startIndex = (row * uvBytesPerRow) + (uvX * 2);
          final endIndex = startIndex + (uvWidth * 2);
          final uvRowBytes = uvPlane.bytes.sublist(startIndex, endIndex);
          buffer.putUint8List(uvRowBytes);
        }
      }
    }
  }