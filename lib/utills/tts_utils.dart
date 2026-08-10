import 'package:flutter_tts/flutter_tts.dart';

class TtsUtils {
  static final FlutterTts _flutterTts = FlutterTts();

  static Future<void> init() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
  }

  static Future<void> speak(String text) async {
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  static Future<void> stop() async {
    await _flutterTts.stop();
  }
}
