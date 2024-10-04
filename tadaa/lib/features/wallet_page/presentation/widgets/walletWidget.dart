import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:tadaa/features/wallet_page/data/model/walletModel.dart';


class WalletCard extends StatelessWidget {
  final WalletModel wallet;

  WalletCard({required this.wallet});

  @override
  Widget build(BuildContext context) {
    // Formatting date and time
    String formattedTime = DateFormat('HH:mm').format(wallet.timestamp);
    String formattedDate = DateFormat('dd MMM yyyy', 'fr_FR').format(wallet.timestamp);

    return GestureDetector(
       onTap: () {
        // Navigate to the action detail page, passing actionId
        
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
       
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // The image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/icons/coins.png'), // Your asset image here
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // The main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
        wallet.actionType, 
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 2),
      // Conditionally display points with different colors and signs
      Text(
        '${(wallet.actionType == 'like Post' ||
        wallet.actionType == 'like Comment' || 
        wallet.actionType == 'Create Post' || 
        wallet.actionType == 'Comment Post'|| 
        wallet.actionType == 'Create Story'|| 
        wallet.actionType == 'Appreciation Post Received') ? '+' : ''}${wallet.nbPoints} Points', 
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          // Conditionally change color based on actionType
          color: (wallet.actionType == 'like Post' || 
                  wallet.actionType == 'Create Post' || 
                  wallet.actionType == 'Comment Post'|| 
                  wallet.actionType == 'Create Story'|| 
                  wallet.actionType == 'Appreciation Post Received'|| 
                  wallet.actionType == 'like Comment'
                  )
              ? Colors.green  
              : Colors.red,   
        ),
      ),
                    
                  ],
                ),
              ),
              // Time and Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formattedTime, // Time (e.g., 08:00)
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate, // Date (e.g., 10 Juillet 2023)
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
