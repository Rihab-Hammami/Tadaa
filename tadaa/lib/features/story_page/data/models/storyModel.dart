import 'package:cloud_firestore/cloud_firestore.dart';

enum MediaType { text,image, video }

class StoryModel {
  final String storyId;
  final String userId;
  final String mediaUrl;
  final MediaType mediaType;
  final DateTime createdAt;
  final DateTime expiresAt;
  final List<String> views;
  final String type;  
  final String caption;

  StoryModel({
    required this.storyId,
    required this.userId,
    required this.mediaUrl,
    required this.mediaType,
    required this.createdAt,
    required this.expiresAt,
    required this.views,
    required this.type,
    required this.caption,
  });

  // Factory method to create a StoryModel from Firestore DocumentSnapshot
  factory StoryModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return StoryModel(
      storyId: doc.id,
      userId: data['userId'],
      mediaUrl: data['mediaUrl'],
      mediaType: MediaType.values[data['mediaType']], 
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      views:List<String>.from(data['views'] ?? []),
      type: data['type'] ?? '',
      caption: data['caption']??'',
     
    );
  }

  // Convert a StoryModel to Firestore-compatible format
  Map<String, Object?> toFirestore() {
    return {
      'userId': userId,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType.index, 
      'createdAt': createdAt,
      'expiresAt': expiresAt,
      'views': views,
      'type': type, 
      'caption':caption,
    };
  }

  // Add copyWith method to allow copying the object with new values for certain fields
  StoryModel copyWith({
    String? storyId,
    String? userId,
    String? mediaUrl,
    MediaType? mediaType,
    DateTime? createdAt,
    DateTime? expiresAt,
     List<String>? views,
    String? type,
    String? caption
  }) {
    return StoryModel(
      storyId: storyId ?? this.storyId,
      userId: userId ?? this.userId,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      views: views ?? this.views,
      type: type ?? this.type,
      caption:caption?? this.caption,
    );
  }
}
