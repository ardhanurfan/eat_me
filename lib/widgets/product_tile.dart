import 'package:eat_me/services/image_service.dart';
import 'package:eat_me/services/product_service.dart';
import 'package:eat_me/widgets/product_popup.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/product_model.dart';
import '../shared/theme.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({required this.product, Key? key}) : super(key: key);
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final message = ScaffoldMessenger.of(context);
    ImageTool imageTool = ImageTool();

    handleDelete() async {
      try {
        await imageTool.deleteImage(product.imageUrl);
        await ProductService().deleteProduct(product);
        message.removeCurrentSnackBar();
        message.showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Add Product Success",
              textAlign: TextAlign.center,
            ),
          ),
        );
        navigator.pop();
      } catch (e) {
        message.removeCurrentSnackBar();
        message.showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Add Product Failed",
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }

    Widget popUp() {
      return AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(secondaryColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Close',
              style: whiteText,
            ),
          ),
        ],
        title: Column(
          children: [
            Text(
              product.title,
              style: primaryColorText.copyWith(fontSize: 20, fontWeight: bold),
              textAlign: TextAlign.center,
            ),
            Text(
              "By ${product.uploader.name}",
              style: greyText.copyWith(
                fontSize: 12,
                fontWeight: semibold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Expired Date",
              style: darkText.copyWith(
                fontSize: 16,
                fontWeight: bold,
              ),
            ),
            Text(
              DateFormat('dd-MMMM-yyyy').format(product.expiredDate.toDate()),
              style: darkText.copyWith(
                fontSize: 16,
                fontWeight: bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Deskripsi",
              style: darkText.copyWith(fontSize: 14, fontWeight: bold),
            ),
            Text(
              product.desc,
              style: darkText.copyWith(fontSize: 10),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return popUp();
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: white,
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
            ]),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: darkText.copyWith(
                      fontSize: 16,
                      fontWeight: bold,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Rp${product.price.toString()}",
                    style: primaryColorText.copyWith(
                      fontWeight: semibold,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    product.uploader.name,
                    style: greyText.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expired Date:',
                  style: greyText.copyWith(fontSize: 10),
                ),
                Text(DateFormat('dd-MM-yyyy')
                    .format(product.expiredDate.toDate())),
              ],
            ),
            const SizedBox(width: 4),
            Container(
              color: white,
              child: Column(
                children: [
                  Material(
                    color: white,
                    borderRadius: BorderRadius.circular(defaultRadius),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ProductPopUp(
                              productModel: product,
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
                                  onPressed: handleDelete,
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
                      child: const SizedBox(
                        height: 30,
                        width: 30,
                        child: Center(
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
