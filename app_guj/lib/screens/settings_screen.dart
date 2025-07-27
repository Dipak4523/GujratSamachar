import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tts_service.dart';

class SettingsScreen extends StatelessWidget {
  static const supportedLanguages = [
    {'name': 'Gujarati', 'locale': 'gu-IN'},
    {'name': 'Hindi', 'locale': 'hi-IN'},
    {'name': 'English', 'locale': 'en-US'},
  ];

  @override
  Widget build(BuildContext context) {
    final ttsService = Provider.of<TtsService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select TTS Language:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: ttsService.language,
              items: supportedLanguages.map((lang) {
                return DropdownMenuItem<String>(
                  value: lang['locale'],
                  child: Text(lang['name']!),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ttsService.setLanguage(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

