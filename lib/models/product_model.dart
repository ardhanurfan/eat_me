import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_me/models/user_model.dart';
import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String title;
  final String desc;
  final String imageUrl;
  final UserModel uploader;
  final Timestamp createdAt;
  final Timestamp expiredDate;
  final int price;

  const ProductModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.imageUrl,
    required this.uploader,
    required this.createdAt,
    required this.expiredDate,
    required this.price,
  });

  factory ProductModel.fromJson(String id, Map<String, dynamic> json) {
    return ProductModel(
        id: id,
        title: json['title'],
        desc: json['desc'],
        imageUrl: json['imageUrl'],
        uploader: json['uploader'],
        createdAt: json['createdAt'],
        expiredDate: json['expiredDate'],
        price: json['price']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': desc,
      'imageUrl': imageUrl,
      'uploaderId': uploader.id,
      'createdAt': createdAt,
      'expiredDate': expiredDate,
      'price': price,
    };
  }

  @override
  List<Object?> get props =>
      [id, title, desc, imageUrl, uploader, createdAt, expiredDate, price];
}
