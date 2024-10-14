import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; 
import 'package:tadaa/features/marketPlace_page/presentation/blocs/cart_bloc.dart';
import 'package:tadaa/features/marketPlace_page/presentation/blocs/cart_event.dart';
import 'package:tadaa/features/marketPlace_page/presentation/blocs/cart_state.dart';
import 'package:tadaa/features/user/userInfo.dart';

class RewardsWidget extends StatefulWidget {
  @override
  _RewardsWidgetState createState() => _RewardsWidgetState();
}

class _RewardsWidgetState extends State<RewardsWidget> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchUserId(); 
  }

  Future<void> _fetchUserId() async {
    final id = await UserInfo.getUserId();
    setState(() {
      userId = id;
    });

    // Ensure that userId is not null before dispatching FetchPurchases event
    if (userId != null) {
      BlocProvider.of<CartBloc>(context).add(FetchPurchases(userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is RewardLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is RewardLoaded) {
          if (state.purchases.isEmpty) {
            return Center(child: Text('No purchases yet.'));
          }

          // Display list of purchases
          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: state.purchases.length,
            itemBuilder: (context, index) {
              final purchase = state.purchases[index];

              // Assume each purchase contains a list of products with details
              final products = purchase['products'] as List<dynamic>;
              final quantities = purchase['quantities'] as Map<String, dynamic>;
              final DateTime? purchasedAt = (purchase['purchasedAt'] as Timestamp?)?.toDate();

              return Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the purchase date (if needed)
                         Align(
                          alignment: Alignment.topRight,
                           child: Text(
                             ' ${purchasedAt != null ? DateFormat('yyyy-MM-dd').format(purchasedAt) : 'Unknown date'}',
                             style: TextStyle(
                             fontSize: 16,
                             color: Colors.blue,
                            ),
                                                   ),
                         ),
                        const SizedBox(height: 3),

                        // Display each product in the purchase
                        Column(
                          children: products.map<Widget>((product) {
                            final String productId = product['id'];  // Assuming `id` field exists
                            final String title = product['title'] ?? 'Unknown';
                            final String imageUrl = product['image'] ?? '';
                            final int points = product['points'] ?? 0;
                            final int quantity = quantities[productId] ?? 1;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      height: 80, // Set a fixed height for the image container
                                      width: 80, // Set a fixed width for the image container
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover, // Fill the height of the card
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Product Title and Points
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/icons/coins.png",
                                              height: 20,
                                              width: 20,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '$points',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Quantity: $quantity',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Total Points for the product (only if quantity > 1)
                                  if (quantity > 1)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Total: ${points * quantity}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is CartError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return Center(child: Text('No purchases yet.'));
        }
      },
    );
  }
}
