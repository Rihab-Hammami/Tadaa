class PostModel {
  final String postId;               
  final String content;              
  final List<String> taggedUsers;  
  final List<String> ?likes;   
  final String userId;               
  final DateTime createdAt;          
  final String type;                  

  
  final String? image;              
  
  // Fields for Celebration Post
  final String? eventName;           // For Celebration Post
  final String? eventImage;          // For Celebration Post
  final String? eventIcon;           // For Celebration Post
  
  // Fields for Appreciation Post
  final int? points;                 // For Appreciation Post
  final String? action;              // For Appreciation Post

  PostModel({ 
    required this.postId,
    required this.content,
    required this.taggedUsers,
    required this.userId,
    required this.createdAt,
    required this.type,
    this.image,
    this.eventName,
    this.eventImage,
    this.eventIcon,
    this.points,
    this.action,
    this.likes,
  });

  // Factory constructor to create PostModel from Firestore data
  factory PostModel.fromFirestore(Map<String, dynamic> data) {
    return PostModel(
      postId: data['postId'] ?? '',
      content: data['content'] ?? '',
      taggedUsers: List<String>.from(data['taggedUsers'] ?? []),
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] != null)
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      type: data['type'] ?? 'simple',

      // Optional fields based on post type
      image: data['image'],
      eventName: data['eventName'],
      eventImage: data['eventImage'],
      eventIcon: data['eventIcon'],
      points: data['points'],
      action: data['action'],
      likes: List<String>.from(data['likes'] ?? []),
    );
  }

  // Method to convert PostModel to Firestore-compatible Map
  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'content': content,
      'taggedUsers': taggedUsers,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'type': type,
      'likes':likes,

      // Optional fields
      if (image != null) 'image': image,
      if (eventName != null) 'eventName': eventName,
      if (eventImage != null) 'eventImage': eventImage,
      if (eventIcon != null) 'eventIcon': eventIcon,
      if (points != null) 'points': points,
      if (action != null) 'action': action,
    };
  }

  // Method to create a copy of PostModel with updated fields
  PostModel copyWith({
    String? postId,
    String? content,
    List<String>? taggedUsers,
    List<String>? likes,
    String? userId,
    DateTime? createdAt,
    String? type,
    String? image,
    String? eventName,
    String? eventImage,
    String? eventIcon,
    int? points,
    String? action,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      content: content ?? this.content,
      taggedUsers: taggedUsers ?? this.taggedUsers,
      likes: likes ?? this.likes,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      image: image ?? this.image,
      eventName: eventName ?? this.eventName,
      eventImage: eventImage ?? this.eventImage,
      eventIcon: eventIcon ?? this.eventIcon,
      points: points ?? this.points,
      action: action ?? this.action,
    );
  }
}
