import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadaa/features/wallet_page/data/model/walletModel.dart';

class WalletRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //  add points
  Future<void> addPoints(String userId, int points, String actionType, String actionId) async {
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    DocumentSnapshot userDoc = await userRef.get();

    if (userDoc.exists) {
      int currentPoints = userDoc['points'];
      int newPoints = currentPoints + points;

      await userRef.update({'points': newPoints});
      // Log the transaction in the wallets collection
      WalletModel wallet = WalletModel(
        userId: userId,
        actionType: actionType,
        actionId: actionId,
        nbPoints: points,
        timestamp: DateTime.now(),
      );
      await _firestore.collection('wallet').add(wallet.toFirestore());
    }
  }

  // deduct points
  Future<void> deductPoints(String userId, int points, String actionType, String actionId) async {
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    DocumentSnapshot userDoc = await userRef.get();

    if (userDoc.exists) {
      int currentPoints = userDoc['points'];
      int newPoints = currentPoints - points;

      if (newPoints >= 0) {
        await userRef.update({'points': newPoints});

        // Log the transaction in the wallets collection
        WalletModel wallet = WalletModel(
          userId: userId,
          actionType: actionType,
          actionId: actionId,
          nbPoints: -points,
          timestamp: DateTime.now(),
        );
        await _firestore.collection('wallet').add(wallet.toFirestore());
      } else {
        throw Exception("Insufficient points");
      }
    }
  }
 
Future<void> transferPoints(String fromUserId, List<String> toUserIds, int points, String actionId) async {
  // Deduct points from the user who is creating the appreciation post
  await deductPoints(fromUserId, points, 'Appreciation Post', actionId);

  // Add points to each recipient (tagged user)
  for (String toUserId in toUserIds) {
    await addPoints(toUserId, points, 'Appreciation Post Received', actionId);
  }
}
////getWallets
 Future<List<WalletModel>> getWallets(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('wallet')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true) // Optional, to order by timestamp
          .get();

      // Map the documents to WalletModel objects
      List<WalletModel> wallets = snapshot.docs.map((doc) {
        return WalletModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();

      return wallets;
    } catch (e) {
      throw Exception('Failed to load wallet transactions: $e');
    }
  }






}


