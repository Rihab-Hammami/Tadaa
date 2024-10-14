// cart_state.dart

import 'package:tadaa/features/marketPlace_page/data/models/productModel.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<ProductModel> cartItems;
  final Map<ProductModel, int> productQuantities;

  CartLoaded({required this.cartItems, required this.productQuantities});
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}
class PurchaseSuccess extends CartState {
  final String message;

  PurchaseSuccess({this.message = "Purchase successful!"});
}

class PurchaseFailure extends CartState {
  final String message;

  PurchaseFailure({this.message = "Insufficient points!"});
}
class RewardInitial extends CartState {}

class RewardLoading extends CartState {}
class RewardLoaded extends CartState {
  final List<Map<String, dynamic>> purchases;

  RewardLoaded(this.purchases);
}