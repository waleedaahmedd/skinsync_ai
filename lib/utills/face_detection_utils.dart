import 'dart:developer';
import 'dart:io';

import 'package:face_detection_tflite/face_detection_tflite.dart';

extension FaceUtils on Face {
  bool isCorrectPose(String pose, {bool isFrontCamera = true}) {
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

    // Size check: Lowered threshold from 0.25 to 0.15 to allow detection from further away
    if ((nRight - nLeft) < 0.15) {
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
        // User behavior: Look RIGHT to capture Left Profile.
        bool isLeftProfile;
        if (Platform.isIOS) {
          // iOS Selfie Right turn = Positive, iOS Back Right turn = Negative
          isLeftProfile = isFrontCamera ? yaw > 30 : yaw < -30;
        } else {
          // Android Selfie Right turn = Negative, Android Back Right turn = Positive
          // (Exactly opposite to iOS behavior)
          isLeftProfile = isFrontCamera ? yaw < -30 : yaw > 30;
        }
        
        if (!isLeftProfile) log('Pose rejected: yaw not correct for left profile (current: ${yaw.toStringAsFixed(1)})');
        return isLeftProfile;
      case 'right':
        // User behavior: Look LEFT to capture Right Profile.
        bool isRightProfile;
        if (Platform.isIOS) {
          // iOS Selfie Left turn = Negative, iOS Back Left turn = Positive
          isRightProfile = isFrontCamera ? yaw < -30 : yaw > 30;
        } else {
          // Android Selfie Left turn = Positive, Android Back Left turn = Negative
          // (Exactly opposite to iOS behavior)
          isRightProfile = isFrontCamera ? yaw > 30 : yaw < -30;
        }
        
        if (!isRightProfile) log('Pose rejected: yaw not correct for right profile (current: ${yaw.toStringAsFixed(1)})');
        return isRightProfile;
      default:
        return false;
    }
  }
}
