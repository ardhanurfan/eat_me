import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_me/models/product_model.dart';

class ProductService {
  final CollectionReference<Map<String, dynamic>> _productReference =
      FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(ProductModel product) async {
    try {
      await _productReference.add(product.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _productReference.doc(product.id).update(product.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    try {
      await _productReference.doc(product.id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
