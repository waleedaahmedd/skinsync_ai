import 'package:face_detection_tflite/face_detection_tflite.dart';

extension FaceUtils on Face {
  bool isCorrectPose(String pose) {
    final angles = headEulerAngles;
    if (angles == null) return false;

    final double yaw = angles.y;
    final double pitch = angles.x;
    final double roll = angles.z;

    // Constraints for head stability
    if (pitch.abs() > 15 || roll.abs() > 15) return false;

    // Check if face falls within the specified crop dimensions
    // Crop area: center (0.5, 0.42), radius 0.5 of width
    final double imageWidth = originalSize.width;
    final double imageHeight = originalSize.height;

    final double nLeft = boundingBox.left / imageWidth;
    final double nTop = boundingBox.top / imageHeight;
    final double nRight = boundingBox.right / imageWidth;
    final double nBottom = boundingBox.bottom / imageHeight;

    // Specified dimensions boundaries (from cropImageToCircle: center 0.5, 0.42, radius 0.5)
    const double targetLeft = 0.0; // 0.5 - 0.5
    const double targetRight = 1.0; // 0.5 + 0.5
    const double targetTop = -0.08; // 0.42 - 0.5
    const double targetBottom = 0.92; // 0.42 + 0.5

    // Ensure face bounding box is contained within the crop square
    if (nLeft < targetLeft ||
        nRight > targetRight ||
        nTop < targetTop ||
        nBottom > targetBottom) {
      return false;
    }

    // Centering check: Face should be reasonably centered for the best crop
    final double nCenterX = (nLeft + nRight) / 2;
    final double nCenterY = (nTop + nBottom) / 2;
    if ((nCenterX - 0.5).abs() > 0.15 || (nCenterY - 0.42).abs() > 0.15) {
      return false;
    }

    // Size check: Face shouldn't be too small (at least 25% of width)
    if ((nRight - nLeft) < 0.25) return false;

    switch (pose) {
      case 'front':
        return yaw.abs() < 10;
      case 'left':
        // Positive Y is turned to the right of camera (person's left)
        return yaw > 18;
      case 'right':
        // Negative Y is turned to the left of camera (person's right)
        return yaw < -18;
      default:
        return false;
    }
  }
}
