import 'package:eat_me/pages/qr_generator_page.dart';
import 'package:eat_me/pages/setting_page.dart';
import 'package:eat_me/providers/user_provider.dart';
import 'package:eat_me/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/page_provider.dart';
import '../widgets/navigation_items.dart';
import 'article_page.dart';
import 'home_page.dart';
import 'qr_code_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of<PageProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    // NavBar
    Widget customBottomNavigation() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 60,
          width: double.infinity,
          margin: EdgeInsets.only(
              bottom: 30, right: defaultMargin, left: defaultMargin),
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(defaultRadius),
              boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.1),
                  offset: const Offset(
                    0,
                    0,
                  ),
                  blurRadius: 2,
                  spreadRadius: 1,
                ),
              ]),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavigationItems(index: 0, icon: Icons.home_rounded),
              NavigationItems(index: 1, icon: Icons.qr_code),
              NavigationItems(index: 2, icon: Icons.article),
              NavigationItems(index: 3, icon: Icons.settings_rounded),
            ],
          ),
        ),
      );
    }

    Widget buildContent() {
      switch (pageProvider.currPage) {
        case 0:
          {
            return const HomePage();
          }
        case 1:
          {
            return userProvider.user.role == "user"
                ? const QRCodePage()
                : const QRGenerator();
          }
        case 2:
          {
            return const ArticlePage();
          }
        case 3:
          {
            return const SettingPage();
          }
        default:
          {
            return const HomePage();
          }
      }
    }

    return Scaffold(
      backgroundColor: white2,
      body: Stack(
        children: [
          buildContent(),
          customBottomNavigation(),
        ],
      ),
    );
  }
}
