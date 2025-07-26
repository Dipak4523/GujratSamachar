// services/tts_service.dart
// Service for Gujarati text-to-speech functionality.

import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';

class TtsService extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  TtsService() {
    _flutterTts.setLanguage('gu-IN');
    _flutterTts.setCompletionHandler(() {
      _isPlaying = false;
      notifyListeners();
    });
  }

  Future<void> speak(String text) async {
    _isPlaying = true;
    notifyListeners();
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _isPlaying = false;
    notifyListeners();
  }
}

