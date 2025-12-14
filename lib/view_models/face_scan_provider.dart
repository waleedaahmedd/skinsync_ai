import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FaceScanProvider extends ChangeNotifier {
  double progress = 0.0;
  bool isFaceDetected = false;
  bool isFaceCentered = false;
  bool isCapturing = false;

  Timer? _holdTimer;
  XFile? capturedImage;

  void faceDetected() {
    if (progress < 0.3) {
      progress = 0.3;
      notifyListeners();
    }
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



  void markCaptured(XFile image) {
    capturedImage = image;
    isCapturing = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }
}

