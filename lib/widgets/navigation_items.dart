import 'package:eat_me/providers/page_provider.dart';
import 'package:eat_me/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationItems extends StatelessWidget {
  const NavigationItems({Key? key, required this.icon, required this.index})
      : super(key: key);

  final IconData icon;
  final int index;

  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    return SizedBox(
      width: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          IconButton(
              onPressed: () {
                pageProvider.setCurrPage = index;
              },
              icon: Icon(
                icon,
                color: pageProvider.currPage == index ? primaryColor : grey,
              )),
          Container(
            height: 2,
            width: 30,
            decoration: BoxDecoration(
              color: pageProvider.currPage == index
                  ? primaryColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
          )
        ],
      ),
    );
  }
}
