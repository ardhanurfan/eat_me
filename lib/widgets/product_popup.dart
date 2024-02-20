import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_me/models/product_model.dart';
import 'package:eat_me/services/image_service.dart';
import 'package:eat_me/services/product_service.dart';
import 'package:eat_me/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'custom_button.dart';
import 'custom_text_form_field.dart';

class ProductPopUp extends StatefulWidget {
  const ProductPopUp({
    super.key,
    this.productModel,
  });

  final ProductModel? productModel;

  @override
  State<ProductPopUp> createState() => _ProductPopUpState();
}

class _ProductPopUpState extends State<ProductPopUp> {
  bool isLoading = false;
  bool isEdit = false;
  TextEditingController titleController = TextEditingController(text: '');
  TextEditingController priceController = TextEditingController(text: '');
  TextEditingController descController = TextEditingController(text: '');
  TextEditingController expiredController = TextEditingController(text: '');

  ImageTool imageTool = ImageTool();
  File? imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.productModel != null) {
      titleController.text = widget.productModel!.title;
      priceController.text = widget.productModel!.price.toString();
      descController.text = widget.productModel!.desc;
      expiredController.text = DateFormat('dd-MM-yyyy')
          .format(widget.productModel!.expiredDate.toDate());
      isEdit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final navigator = Navigator.of(context);
    final message = ScaffoldMessenger.of(context);

    handleSave() async {
      setState(() {
        isLoading = true;
      });
      try {
        if (isEdit) {
          String imageUrl = '';
          if (imageFile != null) {
            imageUrl = await imageTool.uploadImage(imageFile!, 'products');
            await imageTool.deleteImage(widget.productModel!.imageUrl);
          }

          await ProductService().updateProduct(
            ProductModel(
              id: widget.productModel!.id,
              title: titleController.text,
              desc: descController.text,
              imageUrl:
                  imageUrl.isEmpty ? widget.productModel!.imageUrl : imageUrl,
              uploader: userProvider.user,
              createdAt: Timestamp.now(),
              expiredDate: Timestamp.fromDate(DateTime.parse(
                  DateFormat('dd-MM-yyyy')
                      .parse(expiredController.text)
                      .toString())),
              price: priceController.text.isEmpty
                  ? 0
                  : int.parse(priceController.text),
            ),
          );
          message.removeCurrentSnackBar();
          message.showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "Edit Product Success",
                textAlign: TextAlign.center,
              ),
            ),
          );
          navigator.pop();
        } else {
          if (imageFile != null) {
            String imageUrl =
                await imageTool.uploadImage(imageFile!, "products");
            await ProductService().addProduct(
              ProductModel(
                id: 'id',
                title: titleController.text,
                desc: descController.text,
                imageUrl: imageUrl,
                uploader: userProvider.user,
                createdAt: Timestamp.now(),
                expiredDate: Timestamp.fromDate(DateTime.parse(
                    DateFormat('dd-MM-yyyy')
                        .parse(expiredController.text)
                        .toString())),
                price: priceController.text.isEmpty
                    ? 0
                    : int.parse(priceController.text),
              ),
            );
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
          } else {
            message.removeCurrentSnackBar();
            message.showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  "Image not found",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        }
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
      setState(() {
        isLoading = false;
      });
    }

    return AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        actions: [
          Visibility(
            visible: !isLoading,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancle',
                style: greyText,
              ),
            ),
          ),
          Visibility(
            visible: !isLoading,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(secondaryColor),
              ),
              onPressed: () async {
                if (formKey.currentState?.validate() == true) {
                  await handleSave();
                }
              },
              child: Text(
                'Save',
                style: whiteText,
              ),
            ),
          )
        ],
        title: Text(
          "Upload Your Product",
          style: primaryColorText.copyWith(fontSize: 16, fontWeight: bold),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: titleController,
                hintText: 'Product Name',
                radiusBorder: defaultRadius,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: priceController,
                hintText: 'Price',
                radiusBorder: defaultRadius,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: descController,
                hintText: 'Desctiption',
                radiusBorder: defaultRadius,
              ),
              const SizedBox(height: 12),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null; // Return null if the field is valid
                },
                controller: expiredController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                    icon: Icon(Icons.calendar_today),
                    labelText: "Enter Expired"),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(pickedDate);

                    setState(() {
                      expiredController.text =
                          formattedDate; //set output date to TextField value.
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              imageFile != null
                  ? Image.file(
                      imageFile!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : (widget.productModel != null)
                      ? Image.network(
                          widget.productModel!.imageUrl,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox(),
              const SizedBox(height: 12),
              CustomButton(
                radiusButton: defaultRadius,
                buttonColor: primaryColor,
                buttonText: isEdit ? "Edit Image" : "Add Image",
                widthButton: double.infinity,
                isLoading: isLoading,
                onPressed: () async {
                  await imageTool.pickImage();
                  setState(() {
                    imageFile = imageTool.croppedImageFile;
                  });
                },
                heightButton: 50,
              )
            ],
          ),
        ));
  }
}
