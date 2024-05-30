import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tadaa/Providers/cartProvider.dart';

class CartDetailsPage extends StatelessWidget {
  double userPoints = 1000;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Details', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartProvider.cartItems[index];
                    return ListTile(
                      leading: Image.network(product.image),
                      title: Text(product.title),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'), // Convert double to string
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              cartProvider.decrementProductQuantity(product);
                            },
                          ),
                          Text('${cartProvider.getProductQuantity(product)}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              cartProvider.incrementProductQuantity(product);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 10,
        decoration: const BoxDecoration(
          color: Color(0xffe8eaed),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [              
                Text(
                  '\$${cartProvider.getTotalAmount().toStringAsFixed(2)}', 
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0F1245)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
              onPressed: () {  
                 double totalAmount = cartProvider.getTotalAmount(); 
                        if (userPoints >= totalAmount) {
                  // Allow purchase
                  Fluttertoast.showToast(
                    msg: "Purchase successful!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  // Proceed with purchase logic here
                } else {
                  // Disallow purchase
                  Fluttertoast.showToast(
                    msg: "Insufficient points to buy these items!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }   
                Navigator.pop(context);  
              },
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 25,
              ),
              label: const Text(
                "Buy",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ],
            );
          },
        ),
      ),
    );
  }
}
