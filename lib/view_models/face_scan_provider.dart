import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'base_view_model.dart';

final faceScanProvider = NotifierProvider.autoDispose(() => FaceScanProvider());

class FaceScanProvider extends BaseViewModel<FaceScanState> {
  FaceScanProvider() : super(initialState: FaceScanState());

  @override
  FaceScanState build() {
    // Keep the provider alive to prevent disposal during navigation
    ref.keepAlive();
    return super.build();
  }

  void toggleIsBefore() {
    state = state.copyWith(isBefore: !state.isBefore);
  }



  Future<void> setCapturedImage(XFile image) async {
    return await runSafely(() async {
      state = state.copyWith(capturedImage: image);
    });
  }

  Future<void> setAiImage(XFile image) async {
    state = FaceScanState(
      isBefore: state.isBefore,
      capturedImage: state.capturedImage,
      aiImage: image, // Always set the new image
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class FaceScanState {
  final bool isBefore;
  final XFile? capturedImage;
  final XFile? aiImage;

  const FaceScanState({
    this.isBefore = false,
    this.capturedImage,
    this.aiImage,
  });

  FaceScanState copyWith({
    bool? isBefore,
    XFile? capturedImage,
    XFile? aiImage,
    bool clearAiImage = false,
  }) {
    return FaceScanState(
      isBefore: isBefore ?? this.isBefore,
      capturedImage: capturedImage ?? this.capturedImage,
      aiImage: clearAiImage ? null : (aiImage != null ? aiImage : this.aiImage),
    );
  }
}
