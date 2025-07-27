// screens/player_screen.dart
// Player screen: Show current news, TTS controls (Play, Stop, Next).

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news_model.dart';
import '../services/tts_service.dart';

class PlayerScreen extends StatefulWidget {
  final List<NewsModel> newsList;
  final int initialIndex;
  const PlayerScreen({Key? key, required this.newsList, required this.initialIndex}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playCurrentNews();
    });
  }

  void _playCurrentNews() {
    final ttsService = Provider.of<TtsService>(context, listen: false);
    // Always set the language before speaking
   // ttsService.setLanguage(ttsService.language);
    ttsService.setLanguage("gu-IN");
    ttsService.speak(widget.newsList[_currentIndex].description);
  }

  void _stopTts() {
    final ttsService = Provider.of<TtsService>(context, listen: false);
    ttsService.stop();
  }

  void _nextNews() {
    if (_currentIndex < widget.newsList.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _playCurrentNews();
    }
  }

  @override
  Widget build(BuildContext context) {
    final news = widget.newsList[_currentIndex];
    final ttsService = Provider.of<TtsService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(news.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Expanded(child: SingleChildScrollView(child: Text(news.description))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: _stopTts,
                ),
                IconButton(
                  icon: Icon(ttsService.isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: _playCurrentNews,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: _nextNews,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
