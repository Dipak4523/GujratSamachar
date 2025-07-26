// services/voice_command_service.dart
// Service for handling Gujarati and English voice commands.

import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/material.dart';

class VoiceCommandService extends ChangeNotifier {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  String _lastCommand = '';

  bool get isListening => _isListening;
  String get lastCommand => _lastCommand;

  Future<void> startListening() async {
    _isListening = true;
    notifyListeners();
    await _speech.initialize();
    await _speech.listen(
      onResult: (result) {
        _lastCommand = result.recognizedWords;
        notifyListeners();
      },
      localeId: 'gu_IN',
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
    _isListening = false;
    notifyListeners();
  }

  bool isNextCommand() {
    return _lastCommand.toLowerCase().contains('next') ||
        _lastCommand.contains('આગળ');
  }

  bool isPlayCommand() {
    return _lastCommand.toLowerCase().contains('play') ||
        _lastCommand.contains('ચાલુ');
  }

  bool isStopCommand() {
    return _lastCommand.toLowerCase().contains('stop') ||
        _lastCommand.contains('બંધ');
  }
}

