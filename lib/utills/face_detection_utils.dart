import 'dart:developer';

import 'package:face_detection_tflite/face_detection_tflite.dart';

extension FaceUtils on Face {
  bool isCorrectPose(String pose) {
    final angles = headEulerAngles;
    if (angles == null) return false;

    final double yaw = angles.y;
    final double pitch = angles.x;
    final double roll = angles.z;

    // Constraints for head stability
    // Increased leniency for roll as some devices report 90-degree offsets in portrait
    final normalizedRoll = (roll.abs() > 45 && roll.abs() < 135) ? (roll.abs() - 90).abs() : roll.abs();
    
    if (pitch.abs() > 25 || normalizedRoll > 25) {
      log('Pose rejected: instability (pitch: ${pitch.toStringAsFixed(1)}, roll: ${roll.toStringAsFixed(1)}, normRoll: ${normalizedRoll.toStringAsFixed(1)})');
      return false;
    }

    // Check if face falls within the specified crop dimensions
    final double imageWidth = originalSize.width;
    final double imageHeight = originalSize.height;

    final double nLeft = boundingBox.left / imageWidth;
    final double nTop = boundingBox.top / imageHeight;
    final double nRight = boundingBox.right / imageWidth;
    final double nBottom = boundingBox.bottom / imageHeight;

    // Centering check
    final double nCenterX = (nLeft + nRight) / 2;
    final double nCenterY = (nTop + nBottom) / 2;
    
    if ((nCenterX - 0.5).abs() > 0.25 || (nCenterY - 0.42).abs() > 0.25) {
      log('Pose rejected: not centered (centerX: ${nCenterX.toStringAsFixed(2)}, centerY: ${nCenterY.toStringAsFixed(2)})');
      return false;
    }

    // Size check
    if ((nRight - nLeft) < 0.25) {
      log('Pose rejected: face too small (${(nRight - nLeft).toStringAsFixed(2)})');
      return false;
    }

    log('YAW: ${yaw.toStringAsFixed(1)}');

    switch (pose) {
      case 'front':
        final isFront = yaw.abs() < 12;
        if (!isFront) log('Pose rejected: yaw too high for front');
        return isFront;
      case 'left':
        final isLeft = yaw < -30;
        if (!isLeft) log('Pose rejected: yaw not far enough left');
        return isLeft;
      case 'right':
        final isRight = yaw > 30;
        if (!isRight) log('Pose rejected: yaw not far enough right');
        return isRight;
      default:
        return false;
    }
  }
}
