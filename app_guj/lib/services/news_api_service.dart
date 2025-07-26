// services/news_api_service.dart
// Service to fetch and parse Gujarati news from RSS feed.

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/news_model.dart';

class NewsApiService {
  static const String rssUrl = 'https://www.divyabhaskar.co.in/rss-feeder/';

  Future<List<NewsModel>> fetchNews() async {
    final response = await http.get(Uri.parse(rssUrl));
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
      throw Exception('Failed to load news');
    }
  }
}

