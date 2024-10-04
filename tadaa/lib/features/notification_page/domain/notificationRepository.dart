import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadaa/features/notification_page/data/notificationModel.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore;

  NotificationRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> addNotification(NotificationModel notification) async {
    try {
      await _firestore.collection('notifications').add(notification.toFirestore());
    } catch (e) {
      throw Exception('Failed to add notification: $e');
    }
  }
  

Future<List<NotificationModel>> fetchNotifications(String recipientId) async {
    try {
      // Query Firestore to get notifications for the specific recipientId
      QuerySnapshot querySnapshot = await _firestore
          .collection('notifications')
          .where('recipientId', isEqualTo: recipientId)  // Filter by recipientId
          .orderBy('date', descending: true)  // Order by date, most recent first
          .get();

      // Map the fetched documents to NotificationModel
      return querySnapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }
   /*Future<List<NotificationModel>> fetchNotifications(String userId) async {
    try {
      // Query Firestore to get notifications for the specific user
      QuerySnapshot querySnapshot = await _firestore
          .collection('notifications')
          .where('userId', isNotEqualTo: userId)
          .orderBy('userId')
          .orderBy('date', descending: true) // Ordering by date (most recent first)
          .get();

      // Map the fetched documents to NotificationModel
      return querySnapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }*/

}
