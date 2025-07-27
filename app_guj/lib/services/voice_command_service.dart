// services/voice_command_service.dart
// Service for handling Gujarati and English voice commands.

import 'package:flutter/material.dart';

class VoiceCommandService extends ChangeNotifier {
  // Dummy implementation to avoid errors
  bool _isListening = false;
  String _lastCommand = '';

  bool get isListening => _isListening;
  String get lastCommand => _lastCommand;

  Future<void> startListening() async {
    // No-op
    _isListening = true;
    notifyListeners();
  }

  Future<void> stopListening() async {
    // No-op
    _isListening = false;
    notifyListeners();
  }

  void processCommand(String command) {
    // No-op: Dummy method for web compatibility
    _lastCommand = command;
    notifyListeners();
  }

  bool isNextCommand() {
    return false;
  }

  bool isPlayCommand() {
    return false;
  }

  bool isStopCommand() {
    return false;
  }
}
