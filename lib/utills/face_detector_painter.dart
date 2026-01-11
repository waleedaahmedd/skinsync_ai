import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:skinsync_ai/utills/color_constant.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter({
    required this.faces,
    required this.imageSize,
    required this.rotation,
    required this.cameraLensDirection,
    this.previewSize,
  });

  final List<Face> faces;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;
  final Size? previewSize; // Actual camera preview size

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = CustomColors.purpleColor // Use app theme color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Use preview size if available, otherwise use canvas size
    final targetSize = previewSize ?? size;
    
    for (final face in faces) {
      final boundingBox = face.boundingBox;
      
      final left = _translateX(
        boundingBox.left,
        size,
        targetSize,
        rotation,
        cameraLensDirection,
      );
      final top = _translateY(
        boundingBox.top,
        size,
        targetSize,
        rotation,
        cameraLensDirection,
      );
      final right = _translateX(
        boundingBox.right,
        size,
        targetSize,
        rotation,
        cameraLensDirection,
      );
      final bottom = _translateY(
        boundingBox.bottom,
        size,
        targetSize,
        rotation,
        cameraLensDirection,
      );

      // Ensure coordinates are within bounds
      final rect = Rect.fromLTRB(
        left.clamp(0.0, size.width),
        top.clamp(0.0, size.height),
        right.clamp(0.0, size.width),
        bottom.clamp(0.0, size.height),
      );

      canvas.drawRect(rect, paint);
    }
  }

  double _translateX(
    double x,
    Size canvasSize,
    Size imageSize,
    InputImageRotation rotation,
    CameraLensDirection cameraLensDirection,
  ) {
    switch (rotation) {
      case InputImageRotation.rotation0deg:
        if (cameraLensDirection == CameraLensDirection.front) {
          return canvasSize.width - (x * canvasSize.width / imageSize.width);
        }
        return x * canvasSize.width / imageSize.width;
      case InputImageRotation.rotation90deg:
        return x * canvasSize.height / imageSize.width;
      case InputImageRotation.rotation270deg:
        return canvasSize.width - (x * canvasSize.height / imageSize.width);
      default:
        return x * canvasSize.width / imageSize.width;
    }
  }

  double _translateY(
    double y,
    Size canvasSize,
    Size imageSize,
    InputImageRotation rotation,
    CameraLensDirection cameraLensDirection,
  ) {
    switch (rotation) {
      case InputImageRotation.rotation0deg:
        return y * canvasSize.height / imageSize.height;
      case InputImageRotation.rotation90deg:
        if (cameraLensDirection == CameraLensDirection.front) {
          return canvasSize.height - (y * canvasSize.width / imageSize.height);
        }
        return y * canvasSize.width / imageSize.height;
      case InputImageRotation.rotation270deg:
        if (cameraLensDirection == CameraLensDirection.front) {
          return y * canvasSize.width / imageSize.height;
        }
        return canvasSize.height - (y * canvasSize.width / imageSize.height);
      default:
        return y * canvasSize.height / imageSize.height;
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}

