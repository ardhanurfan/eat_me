import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_me/models/article_model.dart';
import 'package:eat_me/pages/write_article_page.dart';
import 'package:flutter/material.dart';

import '../shared/theme.dart';
import '../widgets/article_tile.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<ArticleModel> articles = [
      ArticleModel(
        id: 'id',
        title: 'title',
        content: 'content',
        author: 'author',
        thumbnail:
            'https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg',
        date: Timestamp.now(),
      ),
      ArticleModel(
        id: 'id',
        title: 'title',
        content: 'content',
        author: 'author',
        thumbnail:
            'https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg',
        date: Timestamp.now(),
      ),
      ArticleModel(
        id: 'id',
        title: 'title',
        content: 'content',
        author: 'author',
        thumbnail:
            'https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg',
        date: Timestamp.now(),
      ),
      ArticleModel(
        id: 'id',
        title: 'title',
        content: 'content',
        author: 'author',
        thumbnail:
            'https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg',
        date: Timestamp.now(),
      ),
      ArticleModel(
        id: 'id',
        title: 'title',
        content: 'content',
        author: 'author',
        thumbnail:
            'https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg',
        date: Timestamp.now(),
      ),
      ArticleModel(
        id: 'id',
        title: 'title',
        content: 'content',
        author: 'author',
        thumbnail:
            'https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg',
        date: Timestamp.now(),
      ),
    ];

    Widget articleList() {
      return Column(
        children: articles.map(
          (e) {
            return ArticleTile(
              article: e,
            );
          },
        ).toList(),
      );
    }

    Widget header() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Articles',
            style: primaryColorText.copyWith(
              fontSize: 18,
              fontWeight: semibold,
            ),
          ),
          const SizedBox(height: 12),
        ],
      );
    }

    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WriteArticlePage(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(
            right: defaultMargin,
            left: defaultMargin,
            top: defaultMargin,
            bottom: 160,
          ),
          children: [
            header(),
            articleList(),
          ],
        ),
      ),
    );
  }
}
