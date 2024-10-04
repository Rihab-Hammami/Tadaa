import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadaa/features/marketPlace_page/data/models/productModel.dart';

class CartRepository {
  // This is where you would normally handle data persistence, e.g. with Firestore.
  final List<ProductModel> _cartItems = [];
  final Map<ProductModel, int> _productQuantities = {};

  List<ProductModel> get cartItems => _cartItems;

  Map<ProductModel, int> get productQuantities => _productQuantities;

  void addProduct(ProductModel product) {
    if (_cartItems.contains(product)) {
      _productQuantities[product] = (_productQuantities[product] ?? 0) + 1;
    } else {
      _cartItems.add(product);
      _productQuantities[product] = 1;
    }
  }

  void incrementProduct(ProductModel product) {
    if (_productQuantities.containsKey(product)) {
      _productQuantities[product] = (_productQuantities[product] ?? 0) + 1;
    }
  }

  void decrementProduct(ProductModel product) {
    if (_productQuantities.containsKey(product) && _productQuantities[product]! > 1) {
      _productQuantities[product] = (_productQuantities[product] ?? 0) - 1;
    } else {
      _cartItems.remove(product);
      _productQuantities.remove(product);
    }
  }

  int getTotalAmount() {
    int total = 0;
    for (var product in _cartItems) {
      total += product.points * (_productQuantities[product] ?? 1);
    }
    return total;
  }

  bool canBuy(int userPoints) {
    return getTotalAmount() <= userPoints;
  }
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> savePurchasedProducts(
    List<ProductModel> products, Map<ProductModel, int> quantities, String userId) async {
  try {
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    await userRef.collection('purchases').add({
      'products': products.map((product) => product.toFirestore()).toList(),
      'quantities': quantities.map((product, quantity) => MapEntry(product.id, quantity)),
      'purchasedAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    throw Exception("Error saving purchased products: $e");
  }
}

}
