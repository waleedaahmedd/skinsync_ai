import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../utills/image_utills.dart';

class FaceScanProvider extends ChangeNotifier {
  double progress = 0.0;
  bool isFaceDetected = false;
  bool isFaceCentered = false;
  bool isCapturing = false;
  bool flash = false;
  bool isBefore = false;

  Timer? _holdTimer;
  XFile? capturedImage;

  void faceDetected() {
    if (progress < 0.3) {
      progress = 0.3;
      notifyListeners();
    }
  }

  void toggleFlash() {
    flash = !flash;
    notifyListeners();
  }

  void toggleIsBefore() {
    isBefore = !isBefore;
    notifyListeners();
  }

  void faceCentered() {
    isFaceCentered = true;
    progress = 1.0;
    notifyListeners();
  }

  void reset() {
    _holdTimer?.cancel();
    _holdTimer = null;

    isFaceDetected = false;
    isFaceCentered = false;
    isCapturing = false;
    progress = 0.0;

    notifyListeners();
  }

  Future<void> markCaptured(XFile image) async {
    capturedImage = image;
    final flippedImage = await flipXFileHorizontally(image);
    capturedImage = flippedImage;
    isCapturing = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }
}
