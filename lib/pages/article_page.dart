import 'package:eat_me/pages/write_article_page.dart';
import 'package:eat_me/providers/article_provider.dart';
import 'package:eat_me/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/theme.dart';
import '../widgets/article_tile.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

bool isLoading = true;

class _ArticlePageState extends State<ArticlePage> {
  @override
  void initState() {
    getInit();
    super.initState();
  }

  getInit() async {
    isLoading = true;
    ArticleProvider articleProvider =
        Provider.of<ArticleProvider>(context, listen: false);

    await articleProvider.getArticles();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ArticleProvider articleProvider = Provider.of<ArticleProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    Widget articleList() {
      return Column(
        children: articleProvider.articles!.map(
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
      floatingActionButton: Visibility(
        visible: userProvider.user.role == "user",
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
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Visibility(
                    visible: articleProvider.articles!.isNotEmpty,
                    child: articleList()),
          ],
        ),
      ),
    );
  }
}
