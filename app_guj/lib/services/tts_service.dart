// services/tts_service.dart
// Service for Gujarati text-to-speech functionality.

import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';

class TtsService extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  String _language = 'gu-IN';

  bool get isPlaying => _isPlaying;
  String get language => _language;

  TtsService() {
    _flutterTts.setLanguage(_language);
    _flutterTts.setCompletionHandler(() {
      _isPlaying = false;
      notifyListeners();
    });
  }

  void setLanguage(String lang) {
    _language = lang;
    _flutterTts.setLanguage(lang);
    notifyListeners();
  }

  Future<void> speak(String text) async {
    debugPrint('TTS: Setting language to "+_language+" and speaking: '+text);
    _isPlaying = true;
    notifyListeners();
    await _flutterTts.setLanguage(_language); // Ensure language is set before speaking
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _isPlaying = false;
    notifyListeners();
  }
}
