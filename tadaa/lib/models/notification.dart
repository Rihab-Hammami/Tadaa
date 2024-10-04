

class NotificationModel {
  //final String id;
   //final User user;
  //final String userName; 
  final String message;
  final String type; // Type of notification ( reaction, comment, follow)
  final String postId; // ID of the associated post 
  final String commentId; // ID of the associated comment 
  final DateTime createdAt;
  
  NotificationModel({
  //required this.id,
  // required this.user,
  //required this.userName,
  required this.message,
  required this.type,
  required this.postId,
  required this.commentId,
  required this.createdAt,

  });
}
