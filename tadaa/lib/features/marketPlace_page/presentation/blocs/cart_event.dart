// cart_event.dart

import 'package:tadaa/features/marketPlace_page/data/models/productModel.dart';

abstract class CartEvent {}

class AddProductToCart extends CartEvent {
  final ProductModel product;

  AddProductToCart(this.product);
}

class RemoveProductFromCart extends CartEvent {
  final ProductModel product;

  RemoveProductFromCart(this.product);
}

class IncrementProductQuantity extends CartEvent {
  final ProductModel product;

  IncrementProductQuantity(this.product);
}

class DecrementProductQuantity extends CartEvent {
  final ProductModel product;

  DecrementProductQuantity(this.product);
}

class LoadCart extends CartEvent {}
class PurchaseProducts extends CartEvent {
  final int totalAmount;
  

  PurchaseProducts({required this.totalAmount,});
}
class FetchPurchases extends CartEvent {
  final String userId;

  FetchPurchases(this.userId);
}