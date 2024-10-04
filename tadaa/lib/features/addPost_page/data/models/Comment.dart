class CommentModel {
  final String id;
  final String commentText;
  final String userId;
  final DateTime createdAt;
  final List<String> likes; // Changed to a list of strings

  CommentModel({
    required this.id,
    required this.commentText,
    required this.userId,
    required this.createdAt,
    List<String>? likes, // Initialize likes as an optional parameter
  }) : likes = likes ?? []; // Default to an empty list if not provided

  // Factory constructor to create an instance of CommentModel from Firestore data
  factory CommentModel.fromFirestore(Map<String, dynamic> data) {
    return CommentModel(
      id: data['id'],
      commentText: data['commentText'],
      userId: data['userId'],
      createdAt: DateTime.parse(data['createdAt']),
      likes: List<String>.from(data['likes'] ?? []), // Handle null case
    );
  }

  // Method to convert the CommentModel instance to a Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'commentText': commentText,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes, // Include likes in the Firestore representation
    };
  }

  // Method to create a copy of the CommentModel instance with optional updates
  CommentModel copyWith({
    String? id,
    String? commentText,
    String? userId,
    DateTime? createdAt,
    List<String>? likes, // Allow updating likes
  }) {
    return CommentModel(
      id: id ?? this.id,
      commentText: commentText ?? this.commentText,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes, // Default to current likes if not provided
    );
  }
}
