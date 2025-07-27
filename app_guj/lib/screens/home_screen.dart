// screens/home_screen.dart
// Home screen: List of news headlines, play and mic controls.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/news_api_service.dart';
import '../models/news_model.dart';
import '../services/tts_service.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late Future<List<NewsModel>> _newsFuture;
  late TabController _tabController;
  final List<String> _categories = ['Top News', 'Sports', 'Entertainment', 'Technology', 'YouTube'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _newsFuture = NewsApiService().fetchNews();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ttsService = Provider.of<TtsService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((cat) => Tab(text: cat)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Top News
          _buildNewsList(ttsService),
          // Sports
          _buildNewsList(ttsService),
          // Entertainment
          _buildNewsList(ttsService),
          // Technology
          _buildNewsList(ttsService),
          // YouTube
          _buildYouTubeSection(),
        ],
      ),
    );
  }

  Widget _buildNewsList(TtsService ttsService) {
    return FutureBuilder<List<NewsModel>>(
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
            bool isPlaying = ttsService.isPlaying;
            return ListTile(
              title: Text(news.title),
              subtitle: Text(news.description, maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) => _MediaPlayerDialog(text: news.title + '\n' + news.description),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildYouTubeSection() {
    final List<Map<String, String>> youtubeVideos = [
      {
        'title': 'Times of India Gujarati News Live',
        'url': 'https://www.youtube.com/watch?v=QH2-TGUlwu4',
        'thumbnail': 'https://img.youtube.com/vi/QH2-TGUlwu4/0.jpg',
      },
      // ...add more Times of India or other Gujarati news videos as needed...
    ];
    return ListView.builder(
      itemCount: youtubeVideos.length,
      itemBuilder: (context, index) {
        final video = youtubeVideos[index];
        return ListTile(
          leading: Image.network(video['thumbnail']!, width: 64, height: 48, fit: BoxFit.cover),
          title: Text(video['title']!),
          trailing: const Icon(Icons.play_circle_fill, color: Colors.red),
          onTap: () async {
            showDialog(
              context: context,
              builder: (context) => _YouTubePlayerDialog(videoUrl: video['url']!),
            );
          },
        );
      },
    );
  }
}

class _YouTubePlayerDialog extends StatefulWidget {
  final String videoUrl;
  const _YouTubePlayerDialog({required this.videoUrl});

  @override
  State<_YouTubePlayerDialog> createState() => _YouTubePlayerDialogState();
}

class _YouTubePlayerDialogState extends State<_YouTubePlayerDialog> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Use a sample video for demo, or use a package like youtube_player_flutter for real YouTube playback
    String videoUrl = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double maxWidth = MediaQuery.of(context).size.width * 0.95;
    final double maxHeight = MediaQuery.of(context).size.height * 0.5;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: maxWidth,
              height: maxHeight,
              child: AspectRatio(
                aspectRatio: _isInitialized ? _controller.value.aspectRatio : 16 / 9,
                child: _isInitialized
                    ? VideoPlayer(_controller)
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying ? _controller.pause() : _controller.play();
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// MediaPlayerDialog widget
class _MediaPlayerDialog extends StatefulWidget {
  final String text;
  const _MediaPlayerDialog({Key? key, this.text = "આ સમાચાર વાંચો"}) : super(key: key);

  @override
  State<_MediaPlayerDialog> createState() => _MediaPlayerDialogState();
}

class _MediaPlayerDialogState extends State<_MediaPlayerDialog> {
  late FlutterTts _flutterTts;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage('gu-IN');
    _flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });
  }

  Future<void> _speak() async {
    setState(() {
      isPlaying = true;
    });
    await _flutterTts.speak(widget.text);
  }

  Future<void> _stop() async {
    await _flutterTts.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Text to Speech', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 24),
            Text(widget.text, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow, size: 32, color: Colors.orange),
                  onPressed: () async {
                    if (isPlaying) {
                      await _stop();
                    } else {
                      await _speak();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 32),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
