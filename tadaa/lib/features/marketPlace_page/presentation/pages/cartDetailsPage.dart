import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/marketPlace_page/presentation/blocs/cart_bloc.dart';
import 'package:tadaa/features/marketPlace_page/presentation/blocs/cart_event.dart';
import 'package:tadaa/features/marketPlace_page/presentation/blocs/cart_state.dart';
import 'package:awesome_dialog/awesome_dialog.dart'; // Import AwesomeDialog

class CartDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Details', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          // Check the state and show a toast message or dialog based on the outcome of the purchase
          if (state is PurchaseSuccess) {
           AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            title: 'Purchase Successful',
            desc: state.message,
            btnOkOnPress: () {},
            customHeader: Icon(Icons.check_circle, color: Colors.green, size: 48), // Custom icon
          ).show();
          } else if (state is PurchaseFailure) {
          AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.scale,
    title: 'Purchase Failed',
    desc: state.message, // Use the error message from the state
    btnOkOnPress: () {
      Navigator.pop(context);
    },
    btnOkColor: Colors.red, // Set the button color to red
    headerAnimationLoop: false,
    showCloseIcon: true, // Show close icon
    closeIcon: const Icon(Icons.close),
    customHeader: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Icon(
            Icons.error_outline, // Custom error icon
            color: Colors.red,
            size: 40, // Customize the icon size
          ),
          const SizedBox(height: 10), // Space between the icon and the title
        ],
      ),
    ),
  ).show();
          }
        },
        builder: (context, state) {
          if (state is CartInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            return Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.cartItems.length,
                      itemBuilder: (context, index) {
                        final product = state.cartItems[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.image,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              product.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/coins.png",
                                  height: 20,
                                  width: 20,
                                ),
                                Text(
                                  '${product.points}',
                                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    context.read<CartBloc>().add(DecrementProductQuantity(product));
                                  },
                                ),
                                Text('${state.productQuantities[product]}'),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    context.read<CartBloc>().add(IncrementProductQuantity(product));
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10), // Add some space before the bottom sheet
                  _buildBottomSheet(context, state),
                ],
              ),
            );
          }
          return const Center(child: Text('No items in the cart.'));
        },
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context, CartLoaded state) {
    int totalAmount = state.cartItems.fold(
      0,
      (total, product) => total + product.points * (state.productQuantities[product] ?? 1),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Display total amount of points
          Row(
            children: [
              Image.asset(
                "assets/icons/coins.png",
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 8),
              Text(
                '$totalAmount', // Show total points
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          // Buy button
          ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            onPressed: () {
              // Dispatch PurchaseProducts event to CartBloc
              context.read<CartBloc>().add(PurchaseProducts(totalAmount: totalAmount));

              // Optionally show a loading indicator or a toast for the purchase action
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 25,
            ),
            label: const Text(
              "Buy Now",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
