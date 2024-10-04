import 'package:cloud_firestore/cloud_firestore.dart';

class WalletModel {
  final String userId;
  final String actionType; // createPost, like, comment, appreciationPost, etc.
  final String actionId;   // Reference to the action (postId, commentId, etc.)
  final int nbPoints;      // Number of points earned or spent
  final DateTime timestamp;

  WalletModel({
    required this.userId,
    required this.actionType,
    required this.actionId,
    required this.nbPoints,
    required this.timestamp,
  });

  // Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'actionType': actionType,
      'actionId': actionId,
      'nbPoints': nbPoints,
      'timestamp': timestamp,
    };
  }

  // Create from Firestore
  static WalletModel fromFirestore(Map<String, dynamic> data) {
    return WalletModel(
      userId: data['userId'],
      actionType: data['actionType'],
      actionId: data['actionId'],
      nbPoints: data['nbPoints'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
