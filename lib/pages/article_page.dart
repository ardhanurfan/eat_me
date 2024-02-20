import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_me/pages/write_article_page.dart';
import 'package:eat_me/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/article_model.dart';
import '../shared/theme.dart';
import '../widgets/article_tile.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    Widget articleList() {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('articles').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            List<ArticleModel> articles = [];
            // var articles = snapshot.data!.docs.map((e) {
            //   ArticleModel.fromJson(e.id, e.data());
            // }).toList();
            for (var element in snapshot.data!.docs) {
              articles.add(ArticleModel.fromJson(element.id, element.data()));
            }
            return Column(
              children: articles.map(
                (e) {
                  return ArticleTile(
                    article: e,
                  );
                },
              ).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
        },
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
      floatingActionButton: Visibility(
        visible: userProvider.user.role == "penjual",
        child: Container(
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
