import 'dart:io';

import 'package:flutter/material.dart';

import '../services/image_service.dart';
import '../shared/theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';

class WriteArticlePage extends StatefulWidget {
  const WriteArticlePage({super.key});

  @override
  State<WriteArticlePage> createState() => _WriteArticlePageState();
}

class _WriteArticlePageState extends State<WriteArticlePage> {
  ImageTool imageTool = ImageTool();
  File? imageFile;
  bool isLoading = false;
  bool isEdit = false;

  TextEditingController titleController = TextEditingController(text: '');
  TextEditingController contentController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Write Article',
            style: primaryColorText.copyWith(
              fontSize: 18,
              fontWeight: semibold,
            ),
          ),
          const SizedBox(height: 12),
        ],
      );
    }

    Widget inputBody() {
      return Column(
        children: [
          imageFile != null
              ? Image.file(
                  imageFile!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                )
              // : (widget.productModel != null)
              //     ? Image.network(
              //         widget.productModel!.imageUrl,
              //         height: 200,
              //         width: 200,
              //         fit: BoxFit.cover,
              //       )
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
          ),
          const SizedBox(height: 12),
          Text("Title",
              style: darkText.copyWith(fontSize: 16, fontWeight: medium)),
          const SizedBox(height: 4),
          CustomTextFormField(
            controller: titleController,
            hintText: 'Title',
            radiusBorder: defaultRadius,
          ),
          const SizedBox(height: 12),
          Text("Content",
              style: darkText.copyWith(fontSize: 16, fontWeight: medium)),
          const SizedBox(height: 4),
          TextFormField(
            cursorColor: primaryColor,
            controller: contentController,
            keyboardType: TextInputType.multiline,
            minLines: 15,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(defaultRadius),
                    borderSide: BorderSide(color: primaryColor)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
                fillColor: Colors.white,
                filled: true),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Content is Required!';
              }
              return null;
            },
          )
        ],
      );
    }

    return Scaffold(
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
            inputBody(),
          ],
        ),
      ),
    );
  }
}
