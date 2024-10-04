import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadaa/features/marketPlace_page/data/models/productModel.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();

      // Map the documents to ProductModel objects
      List<ProductModel> products = snapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
      print(products);
      return products;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
