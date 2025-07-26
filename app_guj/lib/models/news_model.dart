// models/news_model.dart
// Model for Gujarati news item.

class NewsModel {
  final String title;
  final String description;
  final String link;
  final DateTime pubDate;

  NewsModel({
    required this.title,
    required this.description,
    required this.link,
    required this.pubDate,
  });
}

