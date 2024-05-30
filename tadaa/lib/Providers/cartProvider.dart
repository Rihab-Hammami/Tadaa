
import 'package:flutter/foundation.dart';
import 'package:tadaa/features/home_page/presentation/pages/home_screen.dart';
import 'package:tadaa/models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _cartItems = [];
  final Map<Product, int> _productQuantities = {};

  List<Product> get cartItems => _cartItems;

  void addProductToCart(Product product) {
    if (_cartItems.contains(product)) {
      _productQuantities[product] = (_productQuantities[product] ?? 0) + 1;
    } else {
      _cartItems.add(product);
      _productQuantities[product] = 1;
    }
    notifyListeners();
  }

  void incrementProductQuantity(Product product) {
    if (_productQuantities.containsKey(product)) {
      _productQuantities[product] = (_productQuantities[product] ?? 0) + 1;
    }
    notifyListeners();
  }

  void decrementProductQuantity(Product product) {
    if (_productQuantities.containsKey(product) && _productQuantities[product]! > 1) {
      _productQuantities[product] = (_productQuantities[product] ?? 0) - 1;
    } else {
      _cartItems.remove(product);
      _productQuantities.remove(product);
    }
    notifyListeners();
  }

  int getProductQuantity(Product product) {
    return _productQuantities[product] ?? 0;
  }

  double getTotalAmount() {
    double total = 0.0;
    for (var product in _cartItems) {
      total += product.price * (_productQuantities[product] ?? 1);
    }
    return total;
  }
  bool canBuy(double userPoints) {
    return getTotalAmount() <= userPoints;
  }
}
