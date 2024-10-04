import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tadaa/features/marketPlace_page/data/models/productModel.dart';
import 'package:tadaa/features/marketPlace_page/presentation/blocs/product_bloc.dart';
import 'package:tadaa/features/marketPlace_page/presentation/blocs/product_event.dart';
import 'package:tadaa/features/marketPlace_page/presentation/blocs/product_state.dart';
import 'package:tadaa/features/marketPlace_page/presentation/blocs/cart_bloc.dart'; // Import CartBloc
import 'package:tadaa/features/marketPlace_page/presentation/blocs/cart_event.dart'; // Import CartEvent
import 'package:tadaa/features/marketPlace_page/presentation/pages/detailsPage.dart';

class ProductCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProductBloc>(context).add(FetchProductsEvent());
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProductError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is ProductLoaded) {
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 6.0,
              mainAxisSpacing: 10.0,
              mainAxisExtent: 300,
            ),
            itemCount: state.products.length,
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () {
                  navigateToDetailsPage(context, state.products[index]);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                          child: Image.network(
                            state.products[index].image,
                            height: 170,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.products[index].title,
                                style: Theme.of(context).textTheme.subtitle1!.merge(
                                      const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/icons/coins.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                      Text(
                                        '${state.products[index].points} ',
                                        style: Theme.of(context).textTheme.subtitle2!.merge(
                                              const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(FontAwesomeIcons.cartPlus, size: 20),
                                    onPressed: () {
                                      // Add the product to the cart
                                      BlocProvider.of<CartBloc>(context)
                                          .add(AddProductToCart(state.products[index]));
                                      Fluttertoast.showToast(
                                        msg: "Product added to cart",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black54,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Center(child: Text('No products available.'));
      },
    );
  }

  void navigateToDetailsPage(BuildContext context, ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(product: product),
      ),
    );
  }
}
