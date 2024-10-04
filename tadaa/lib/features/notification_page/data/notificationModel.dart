import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String userId;          
  final String actionType;      
  final String actionId;        
  final DateTime date;         
  final String recipientId;
  NotificationModel({
    required this.userId,
    required this.actionType,
    required this.actionId,
    required this.date,
    required this.recipientId,
  });

 
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'actionType': actionType,
      'actionId': actionId,
      'date': date,
      'recipientId':recipientId,
    };
  }

  static NotificationModel fromFirestore(Map<String, dynamic> data) {
    return NotificationModel(
      userId: data['userId'],
      actionType: data['actionType'],
      actionId: data['actionId'],
      date: (data['date'] as Timestamp).toDate(), 
      recipientId: data['recipientId'],
    );
  }
  
}
