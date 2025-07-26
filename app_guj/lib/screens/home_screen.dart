// screens/home_screen.dart
// Home screen: List of news headlines, play and mic controls.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/news_api_service.dart';
import '../models/news_model.dart';
import '../services/tts_service.dart';
import '../services/voice_command_service.dart';
import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<NewsModel>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = NewsApiService().fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    final ttsService = Provider.of<TtsService>(context);
    final voiceService = Provider.of<VoiceCommandService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gujarati Samachar'),
        actions: [
          IconButton(
            icon: Icon(voiceService.isListening ? Icons.mic : Icons.mic_none),
            onPressed: () {
              if (voiceService.isListening) {
                voiceService.stopListening();
              } else {
                voiceService.startListening();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<NewsModel>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No news available.'));
          }
          final newsList = snapshot.data!;
          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final news = newsList[index];
              return ListTile(
                title: Text(news.title),
                subtitle: Text(news.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlayerScreen(newsList: newsList, initialIndex: index),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

