import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/marketPlace_page/data/models/productModel.dart';
import 'package:tadaa/features/marketPlace_page/domain/repositories/productRepository.dart';
import 'package:tadaa/features/marketPlace_page/presentation/blocs/product_event.dart';
import 'package:tadaa/features/marketPlace_page/presentation/blocs/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc(this._productRepository) : super(ProductInitial()) {
    on<FetchProductsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        List<ProductModel> products = await _productRepository.getProducts();
        emit(ProductLoaded(products));
        print("Products loaded: ${products.length}"); 
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
