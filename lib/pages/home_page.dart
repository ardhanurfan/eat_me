import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_me/models/product_model.dart';
import 'package:eat_me/models/user_model.dart';
import 'package:eat_me/widgets/product_popup.dart';
import 'package:eat_me/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../providers/user_provider.dart';
import '../shared/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    Stream<List<ProductModel>> streamProducts = Rx.combineLatest2(
      FirebaseFirestore.instance.collection('products').snapshots(),
      FirebaseFirestore.instance.collection('users').snapshots(),
      (QuerySnapshot productsSnapshot, QuerySnapshot usersSnapshot) {
        List<ProductModel> products = [];

        for (var productData in productsSnapshot.docs) {
          var userId = productData['uploaderId'];
          var userData =
              usersSnapshot.docs.firstWhere((userDoc) => userDoc.id == userId);
          var product = ProductModel.fromJson(productData.id, {
            ...{
              'uploader':
                  UserModel.fromJson(userData.data() as Map<String, dynamic>)
            },
            ...productData.data() as Map<String, dynamic>,
          });

          products.add(product);
        }

        return products;
      },
    );

    Widget header() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${userProvider.user.name}',
                    style:
                        darkText.copyWith(fontSize: 24, fontWeight: semibold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'How are you today?',
                    style: greyText.copyWith(
                      fontSize: 16,
                      fontWeight: light,
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                  'https://ui-avatars.com/api/?name=${userProvider.user.name}+&color=673AB7&background=EBF4FF'),
            )
            // const SizedBox(height: 6),
          ],
        ),
      );
    }

    Widget products() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Products',
            style: primaryColorText.copyWith(
              fontSize: 18,
              fontWeight: semibold,
            ),
          ),
          const SizedBox(height: 12),
          StreamBuilder<List<ProductModel>>(
            stream: streamProducts,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Column(
                  children: (snapshot.data as List<ProductModel>)
                      .map(
                        (product) => ProductTile(product: product),
                      )
                      .toList(),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
            },
          ),
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
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const ProductPopUp();
                },
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
          products(),
        ],
      )),
    );
  }
}
