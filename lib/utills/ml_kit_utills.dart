  import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
    CameraDescription camera, {
    Rect? cropRect,
  }) {
    final WriteBuffer allBytes = WriteBuffer();
    
    if (cropRect != null) {
      // Crop the image to the specified rectangle
      _cropCameraImage(image, cropRect, allBytes);
    } else {
      // Use full image
      for (final plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
    }
    
    final bytes = allBytes.done().buffer.asUint8List();

    final rotation = rotationFromCamera(camera);

    // iOS uses bgra8888, Android uses nv21
    final format = Platform.isIOS
        ? InputImageFormat.bgra8888
        : InputImageFormat.nv21;

    final imageSize = cropRect != null
        ? Size(cropRect.width, cropRect.height)
        : Size(image.width.toDouble(), image.height.toDouble());

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: imageSize,
        rotation: rotation,
        format: format,
        bytesPerRow: cropRect != null
            ? (cropRect.width.toInt() * (Platform.isIOS ? 4 : 1))
            : image.planes.first.bytesPerRow,
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