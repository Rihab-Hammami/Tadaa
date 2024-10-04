import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;          // Unique identifier for the product
  final String description; // Description of the product
  final String image;       // URL or path to the product image
  final int points;         // Points required to purchase or earn the product
  final String title;       // Title of the product

  ProductModel({
    required this.id,
    required this.description,
    required this.image,
    required this.points,
    required this.title,
  });

  // Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'description': description,
      'image': image,
      'points': points,
      'title': title,
    };
  }

  // Create from Firestore
  static ProductModel fromFirestore(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'],
      description: data['description'],
      image: data['image'].replaceFirst('gs://', 'https://storage.googleapis.com/'),
      points: data['points'] is String ? int.tryParse(data['points']) ?? 0 : data['points'] as int,
      title: data['title'],
    );
  }
}
