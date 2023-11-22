import 'package:eat_me/models/article_model.dart';
import 'package:eat_me/services/article_service.dart';
import 'package:flutter/material.dart';

class ArticleProvider extends ChangeNotifier {
  String _errorMessage = '';
  List<ArticleModel>? _articles;

  String get errorMessage => _errorMessage;
  List<ArticleModel>? get articles => _articles;

  Future<bool> getArticles() async {
    try {
      _articles = await ArticleService().fetchArticles();
      print(_articles);
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
    return true;
  }
}
