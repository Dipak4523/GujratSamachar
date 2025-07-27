// services/news_api_service.dart
// Service to fetch and parse Gujarati news from RSS feed.

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/news_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NewsApiService {
  static const String rssUrl = 'https://www.nasa.gov/rss/dyn/breaking_news.rss';
  static const String allOriginsProxy = 'https://api.allorigins.win/raw?url=';

  Future<List<NewsModel>> fetchNews() async {
    final url = kIsWeb ? allOriginsProxy + rssUrl : rssUrl;
    try {
      final headers = {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final items = document.findAllElements('item');
        return items.map((item) {
          return NewsModel(
            title: item.getElement('title')?.text ?? '',
            description: item.getElement('description')?.text ?? '',
            link: item.getElement('link')?.text ?? '',
            pubDate: DateTime.tryParse(item.getElement('pubDate')?.text ?? '') ?? DateTime.now(),
          );
        }).toList();
      } else {
        throw Exception('Failed to load news: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG: Failed to load news: $e');
      throw Exception('Failed to load news: $e');
    }
  }
}
