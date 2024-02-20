import 'package:eat_me/pages/detail_article_page.dart';
import 'package:eat_me/providers/user_provider.dart';
import 'package:eat_me/services/article_service.dart';
import 'package:eat_me/services/image_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/article_model.dart';
import '../pages/write_article_page.dart';
import '../shared/theme.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({required this.article, super.key});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailArticleUserPage(
              article: article,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: grey.withOpacity(0.1),
              offset: const Offset(
                0,
                2,
              ),
              blurRadius: 1,
              spreadRadius: 0.5,
            ),
          ],
          color: white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            article.thumbnail.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      article.thumbnail,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: SizedBox(
                width: 193,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      article.title,
                      style: darkText.copyWith(
                          fontSize: 12, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.clip,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(article.date.toDate()),
                      style: secondaryColorText.copyWith(fontSize: 10),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      article.author,
                      style: primaryColorText.copyWith(fontSize: 10),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: userProvider.user.role == "penjual",
              child: Container(
                color: white,
                child: Column(
                  children: [
                    Material(
                      color: white,
                      borderRadius: BorderRadius.circular(defaultRadius),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WriteArticlePage(articleModel: article),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(defaultRadius),
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Center(
                            child: Icon(
                              Icons.edit,
                              color: secondaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: white,
                      borderRadius: BorderRadius.circular(defaultRadius),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Confirm', style: primaryColorText),
                                content: Text(
                                  'Delete this article?',
                                  style: darkText,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'NO',
                                      style: darkText,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ArticleService().deleteArticle(article);
                                      ImageTool()
                                          .deleteImage(article.thumbnail);
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              '/main', (route) => false);
                                    },
                                    child: Text(
                                      'YES',
                                      style: darkText,
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(defaultRadius),
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Center(
                            child: Icon(
                              Icons.delete,
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
