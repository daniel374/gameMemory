import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoicePlayer {
  static final FlutterTts _tts = FlutterTts();

  static bool _enabled = true;

  static bool get enabled => _enabled;

  static Future<void> toggle() async {
    _enabled = !_enabled;
    if (!_enabled) {
      await _tts.stop();
    }
  }

  static Future<void> speak(String text) async {
    try {
      if (!_enabled) return;
      await _tts.setLanguage('es-ES'); // letras / números 'en-US'
      await _tts.setSpeechRate(0.45); // más lento para niños
      await _tts.setPitch(1.2); // voz amigable
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS error: $e');
    }
  }
}
