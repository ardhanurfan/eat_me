import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_me/models/article_model.dart';
import 'package:eat_me/providers/user_provider.dart';
import 'package:eat_me/services/article_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/image_service.dart';
import '../shared/theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';

class WriteArticlePage extends StatefulWidget {
  const WriteArticlePage({super.key, this.articleModel});

  final ArticleModel? articleModel;

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
  void initState() {
    super.initState();
    if (widget.articleModel != null) {
      titleController.text = widget.articleModel!.title;
      contentController.text = widget.articleModel!.content;
      isEdit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final message = ScaffoldMessenger.of(context);
    handleSave() async {
      setState(() {
        isLoading = true;
      });
      try {
        if (isEdit) {
          String imageUrl = '';
          if (imageFile != null) {
            imageUrl = await imageTool.uploadImage(imageFile!, 'articles');
            await imageTool.deleteImage(widget.articleModel!.thumbnail);
          }

          await ArticleService().updateArticle(
            ArticleModel(
                id: widget.articleModel!.id,
                title: titleController.text,
                author: widget.articleModel!.author,
                content: contentController.text,
                date: Timestamp.now(),
                thumbnail: imageUrl.isEmpty
                    ? widget.articleModel!.thumbnail
                    : imageUrl),
          );
          message.removeCurrentSnackBar();
          message.showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "Edit Article Success",
                textAlign: TextAlign.center,
              ),
            ),
          );
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        } else {
          if (imageFile != null) {
            String imageUrl =
                await imageTool.uploadImage(imageFile!, "articles");
            await ArticleService().addArticle(
              ArticleModel(
                  id: "id",
                  title: titleController.text,
                  content: contentController.text,
                  author: userProvider.user.name,
                  thumbnail: imageUrl,
                  date: Timestamp.now()),
            );
            message.removeCurrentSnackBar();
            message.showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  "Add Article Success",
                  textAlign: TextAlign.center,
                ),
              ),
            );
            // ignore: use_build_context_synchronously
            Navigator.pushNamedAndRemoveUntil(
                context, '/main', (route) => false);
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
              "Add Article Failed",
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    }

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
              : (widget.articleModel != null)
                  ? Image.network(
                      widget.articleModel!.thumbnail,
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
            maxLines: null,
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
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: CustomButton(
                  isLoading: isLoading,
                  radiusButton: defaultRadius,
                  buttonColor: primaryColor,
                  buttonText: "Save",
                  widthButton: double.infinity,
                  onPressed: () async {
                    await handleSave();
                    // ignore: use_build_context_synchronously
                  },
                  heightButton: 50),
            )
          ],
        ),
      ),
    );
  }
}
