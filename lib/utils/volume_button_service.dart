import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum VolumeButtonEvent { up, down }

class VolumeButtonService {
  static const EventChannel _eventChannel =
      EventChannel('com.skinsyncai/volume_buttons');
  static const MethodChannel _methodChannel =
      MethodChannel('com.skinsyncai/volume_buttons_method');

  StreamSubscription? _subscription;
  final _controller = StreamController<VolumeButtonEvent>.broadcast();

  Stream<VolumeButtonEvent> get onVolumeButtonPressed => _controller.stream;

  Future<void> enableInterception() async {
    try {
      await _methodChannel.invokeMethod('enableInterception');
    } catch (e) {
      debugPrint("Error enabling volume interception: $e");
    }
  }

  Future<void> disableInterception() async {
    try {
      await _methodChannel.invokeMethod('disableInterception');
    } catch (e) {
      debugPrint("Error disabling volume interception: $e");
    }
  }

  void startListening(void Function(VolumeButtonEvent event) onEvent) {
    _subscription?.cancel();
    _subscription = _eventChannel.receiveBroadcastStream().listen((event) {
      if (event == 'volumeUp') {
        onEvent(VolumeButtonEvent.up);
        _controller.add(VolumeButtonEvent.up);
      } else if (event == 'volumeDown') {
        onEvent(VolumeButtonEvent.down);
        _controller.add(VolumeButtonEvent.down);
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  void dispose() {
    stopListening();
    disableInterception();
    _controller.close();
  }
}
