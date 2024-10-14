import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/marketPlace_page/domain/repositories/cartRepository.dart';
import 'package:tadaa/features/profile_page/data/models/userModel.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_bloc.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_event.dart';
import 'package:tadaa/features/user/userInfo.dart';
import 'package:tadaa/features/wallet_page/domain/repository/walletRepository.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import 'package:tadaa/features/marketPlace_page/data/models/productModel.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository; // Assuming you may want to use it later
  final ProfileRepository _profileRepository;
  final ProfileBloc _profileBloc;
  final WalletRepository _walletRepository;
  List<ProductModel> _cartItems = [];
  Map<ProductModel, int> _productQuantities = {};
  
  CartBloc(this._cartRepository, this._profileRepository,this._profileBloc,this._walletRepository) : super(CartInitial()) {
    on<AddProductToCart>(_onAddProductToCart);
    on<RemoveProductFromCart>(_onRemoveProductFromCart);
    on<IncrementProductQuantity>(_onIncrementProductQuantity);
    on<DecrementProductQuantity>(_onDecrementProductQuantity);
    on<LoadCart>(_onLoadCart);
    on<PurchaseProducts>(_onPurchaseProducts);
    on<FetchPurchases>(_onFetchPurchases);
  }

 Future<void> _onAddProductToCart(AddProductToCart event, Emitter<CartState> emit) async { 
  if (_productQuantities.containsKey(event.product)) {
    _productQuantities[event.product] = (_productQuantities[event.product]=1);
  } else {
    // If it doesn't exist, add the product to the cart and set its quantity to 1
    _cartItems.add(event.product);
    _productQuantities[event.product] = 1;
  }

  // Emit the updated CartLoaded state with new cartItems and productQuantities
  emit(CartLoaded(cartItems: _cartItems, productQuantities: _productQuantities));
}

  Future<void> _onRemoveProductFromCart(RemoveProductFromCart event, Emitter<CartState> emit) async {
    _cartItems.remove(event.product);
    _productQuantities.remove(event.product);
    emit(CartLoaded(cartItems: _cartItems, productQuantities: _productQuantities));
  }

  Future<void> _onIncrementProductQuantity(IncrementProductQuantity event, Emitter<CartState> emit) async {
    _productQuantities[event.product] = (_productQuantities[event.product] ?? 0) + 1;
    emit(CartLoaded(cartItems: _cartItems, productQuantities: _productQuantities));
  }

  Future<void> _onDecrementProductQuantity(DecrementProductQuantity event, Emitter<CartState> emit) async {
    if (_productQuantities[event.product]! > 1) {
      _productQuantities[event.product] = _productQuantities[event.product]! - 1;
    } else {
      _cartItems.remove(event.product);
      _productQuantities.remove(event.product);
    }
    emit(CartLoaded(cartItems: _cartItems, productQuantities: _productQuantities));
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoaded(cartItems: _cartItems, productQuantities: _productQuantities));
  }

Future<void> _onPurchaseProducts(PurchaseProducts event, Emitter<CartState> emit) async {
  // Retrieve user ID from Shared Preferences
  String? userId = await UserInfo.getUserId(); // Get user ID

  if (userId == null) {
    emit(PurchaseFailure(message: "User is not logged in."));
    return;
  }

  try {
    // Reference to the user's document in Firestore
    DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    // Retrieve user profile to get current points
    DocumentSnapshot userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      emit(PurchaseFailure(message: "User not found."));
      return;
    }

    // Access the current points from Firestore
    int userPoints = (userSnapshot.data() as Map<String, dynamic>)['points'];

    if (userPoints >= event.totalAmount) {
      //int updatedPoints = userPoints - event.totalAmount;

    for (var product in _cartItems) {
        // Assuming each product has an 'id' property
        String actionId = product.id;
     await _walletRepository.deductPoints(userId, event.totalAmount, 'Purchase Product from MarketPlace',actionId );
    }    
      //await userDoc.update({'points': updatedPoints});
      
      
      await _cartRepository.savePurchasedProducts(_cartItems, _productQuantities, userId);
      // Emit PurchaseSuccess state
      emit(PurchaseSuccess(message: "Purchase successful!"));
      _profileBloc.add(FetchProfile(userId)); 
      _cartItems.clear();
      _productQuantities.clear();
    } else {
      emit(PurchaseFailure(message: "Insufficient points to complete the purchase."));
    }
  } catch (error) {
    emit(PurchaseFailure(message: "Error processing purchase: ${error.toString()}"));
  }
}

Future<void> _onFetchPurchases(FetchPurchases event, Emitter<CartState> emit) async {
    emit(RewardLoading());
    try {
      // Fetch the user's purchases using the repository method
      final purchases = await _cartRepository.fetchPurchases(event.userId);

      // Emit CartLoaded state with fetched purchases
      emit(RewardLoaded(purchases));
    } catch (e) {
      // Emit CartError state in case of failure
      emit(CartError('Failed to fetch purchases: $e'));
    }
  }

}



