import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'base_view_model.dart';

final faceScanProvider = NotifierProvider.autoDispose(() => FaceScanProvider());

class FaceScanProvider extends BaseViewModel<FaceScanState> {
  FaceScanProvider() : super(initialState: FaceScanState());

  Timer? _holdTimer;

  void faceDetected() {
    if (state.progress < 0.3) {
      state = state.copyWith(progress: 0.3);
    }
  }

  void toggleFlash() {
    state = state.copyWith(flash: !state.flash);
  }

  void toggleIsBefore() {
    state = state.copyWith(isBefore: !state.isBefore);
  }

  void faceCentered() {
    state = state.copyWith(progress: 1.0, isFaceCentered: true);
  }

  void reset() {
    _holdTimer?.cancel();
    _holdTimer = null;
    state = state.copyWith(
      progress: 0.0,
      isFaceDetected: false,
      isFaceCentered: false,
      isCapturing: false,
    );
  }

  Future<void> markCaptured(XFile image) async {
    return await runSafely(() async {
      // final flippedImage = await flipXFileHorizontally(image);
      state = state.copyWith(capturedImage: image, isCapturing: true);
    });
  }

  Future<void> setAiimage(XFile image) async {
    // Directly update state to ensure it always updates, even on subsequent calls
    // Create a new state object with the new aiImage
    state = FaceScanState(
      progress: state.progress,
      isFaceDetected: state.isFaceDetected,
      isFaceCentered: state.isFaceCentered,
      isCapturing: false,
      flash: state.flash,
      isBefore: state.isBefore,
      capturedImage: state.capturedImage,
      aiImage: image, // Always set the new image
    );
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }
}

class FaceScanState {
  final double progress;
  final bool isFaceDetected;
  final bool isFaceCentered;
  final bool isCapturing;
  final bool flash;
  final bool isBefore;
  final XFile? capturedImage;
  final XFile? aiImage;

  const FaceScanState({
    this.progress = 0.0,
    this.isFaceDetected = false,
    this.isFaceCentered = false,
    this.flash = false,
    this.isCapturing = false,
    this.isBefore = false,
    this.capturedImage,
    this.aiImage,
  });

  FaceScanState copyWith({
    double? progress,
    bool? isFaceDetected,
    bool? isFaceCentered,
    bool? isCapturing,
    bool? flash,
    bool? isBefore,
    XFile? capturedImage,
    XFile? aiImage,
    bool clearAiImage = false,
  }) {
    return FaceScanState(
      progress: progress ?? this.progress,
      isFaceDetected: isFaceDetected ?? this.isFaceDetected,
      isFaceCentered: isFaceCentered ?? this.isFaceCentered,
      isCapturing: isCapturing ?? this.isCapturing,
      flash: flash ?? this.flash,
      isBefore: isBefore ?? this.isBefore,
      capturedImage: capturedImage ?? this.capturedImage,
      // If aiImage is explicitly provided (not null), use it; otherwise keep current or clear if flag is set
      aiImage: clearAiImage ? null : (aiImage != null ? aiImage : this.aiImage),
    );
  }
}
