import 'dart:developer';
import 'dart:io';

import 'package:face_detection_tflite/face_detection_tflite.dart';

extension FaceUtils on Face {
  bool isCorrectPose(
    String pose, {
    bool isFrontCamera = true,
    bool previousCorrect = false,
  }) {
    final angles = headEulerAngles;
    if (angles == null) return false;

    final double yaw = angles.y;
    final double pitch = angles.x;
    final double roll = angles.z;

    // Constraints for head stability
    final normalizedRoll = (roll.abs() > 45 && roll.abs() < 135)
        ? (roll.abs() - 90).abs()
        : roll.abs();

    if (pitch.abs() > 30 || normalizedRoll > 30) {
      log(
        'Pose rejected: instability (pitch: ${pitch.toStringAsFixed(1)}, normRoll: ${normalizedRoll.toStringAsFixed(1)})',
      );
      return false;
    }

    // Check if face falls within the specified crop dimensions
    final double imageWidth = originalSize.width;
    final double imageHeight = originalSize.height;

    final double nLeft = boundingBox.left / imageWidth;
    final double nTop = boundingBox.top / imageHeight;
    final double nRight = boundingBox.right / imageWidth;
    final double nBottom = boundingBox.bottom / imageHeight;

    // Centering check (more lenient for side profiles as head turns shift center)
    final double nCenterX = (nLeft + nRight) / 2;
    final double nCenterY = (nTop + nBottom) / 2;

    final double maxCenterXOffset = (pose == 'front') ? 0.28 : 0.38;
    const double maxCenterYOffset = 0.32;

    if ((nCenterX - 0.5).abs() > maxCenterXOffset ||
        (nCenterY - 0.42).abs() > maxCenterYOffset) {
      log(
        'Pose rejected: not centered (centerX: ${nCenterX.toStringAsFixed(2)}, centerY: ${nCenterY.toStringAsFixed(2)})',
      );
      return false;
    }

    // Size check
    if ((nRight - nLeft) < 0.20) {
      log(
        'Pose rejected: face too small (${(nRight - nLeft).toStringAsFixed(2)})',
      );
      return false;
    }

    log('YAW: ${yaw.toStringAsFixed(1)} (Pose: $pose)');

    switch (pose) {
      case 'front':
        final double threshold = previousCorrect ? 16.0 : 12.0;
        final isFront = yaw.abs() < threshold;
        if (!isFront) log('Pose rejected: yaw too high for front');
        return isFront;

      case 'left':
        // User behavior: Look RIGHT to capture Left Profile.
        bool isLeftProfile;
        final double minYaw = previousCorrect ? 14.0 : 18.0;
        if (Platform.isIOS) {
          isLeftProfile = isFrontCamera ? yaw > minYaw : yaw < -minYaw;
        } else {
          isLeftProfile = isFrontCamera ? yaw < -minYaw : yaw > minYaw;
        }
        if (!isLeftProfile) {
          log(
            'Pose rejected: yaw not correct for left profile (current: ${yaw.toStringAsFixed(1)})',
          );
        }
        return isLeftProfile;

      case 'right':
        // User behavior: Look LEFT to capture Right Profile.
        bool isRightProfile;
        final double minYaw = previousCorrect ? 14.0 : 18.0;
        if (Platform.isIOS) {
          isRightProfile = isFrontCamera ? yaw < -minYaw : yaw > minYaw;
        } else {
          isRightProfile = isFrontCamera ? yaw > minYaw : yaw < -minYaw;
        }
        if (!isRightProfile) {
          log(
            'Pose rejected: yaw not correct for right profile (current: ${yaw.toStringAsFixed(1)})',
          );
        }
        return isRightProfile;

      default:
        return false;
    }
  }
}
