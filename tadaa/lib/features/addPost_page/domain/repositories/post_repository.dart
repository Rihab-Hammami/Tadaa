import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadaa/features/addPost_page/data/models/Comment.dart';
import 'package:tadaa/features/addPost_page/data/models/Post.dart';
import 'package:tadaa/features/notification_page/data/notificationModel.dart';
import 'package:tadaa/features/notification_page/domain/notificationRepository.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_bloc.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_event.dart';
import 'package:tadaa/features/wallet_page/domain/repository/walletRepository.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
   final WalletRepository _walletRepository;
  final ProfileBloc _profileBloc;
  final NotificationRepository _notificationRepository;

  PostRepository({
    required WalletRepository walletRepository,
    required ProfileBloc profileBloc,
    required NotificationRepository notificationRepository, // Added NotificationRepository
  })  : _walletRepository = walletRepository,
        _profileBloc = profileBloc,
        _notificationRepository = notificationRepository;

  Future<String> uploadImage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child('postsImages').child(fileName);

    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<String> createPost(PostModel post,String userId) async {
    final postRef = _firestore.collection('posts').doc();
    
    // Setting the post ID for the Firestore document
    final postWithId = post.copyWith(postId: postRef.id);

    await postRef.set(postWithId.toFirestore());
     if (post.type == 'simple' || post.type == 'celebration') {
      await _walletRepository.addPoints(userId, 10, 'Create Post', postRef.id);
      _profileBloc.add(FetchProfile(userId));
      
        
      /*final notification = NotificationModel(
        userId: userId,           // The creator of the post
        actionType: 'new post',   // Action type of the notification
        actionId: postRef.id,     // The ID of the new post
        date: DateTime.now(),     // Timestamp of the notification
        recipientId: userId       // The recipient (user who gets notified)
      );
      
      // Add notification to the repository
      await _notificationRepository.addNotification(notification);*/
    
    }else if (post.type == 'appreciation') {
      // Transfer points to the recipient of the appreciation
      await _walletRepository.transferPoints(post.userId, post.taggedUsers, post.points!, postRef.id);
      _profileBloc.add(FetchProfile(userId));
       final notification = NotificationModel(
      userId: userId,
      actionType: 'Appreciation Post',
      actionId: postRef.id,
      date: DateTime.now(),
      recipientId: userId,
    );
    await _notificationRepository.addNotification(notification);
    }
     if (post.taggedUsers.isNotEmpty) {
    for (String taggedUserId in post.taggedUsers) {
      final taggedUserNotification = NotificationModel(
        userId: userId, // Send notification to the tagged user
        actionType: 'tag',
        actionId: postRef.id,
        date: DateTime.now(),
        recipientId: taggedUserId
      );
      await _notificationRepository.addNotification(taggedUserNotification);
    }
  }

    return postRef.id;
  

  }

  Future<void> updatePost(String postId, PostModel updatedPost) async {
    try {
      await _firestore.collection('posts').doc(postId).update(updatedPost.toFirestore());
    } catch (e) {
      throw Exception('Error updating post: $e');
    }
  }


  Future<List<PostModel>> fetchAllPosts() async {
  final querySnapshot = await _firestore
      .collection('posts')
      .orderBy('createdAt', descending: true)
      .get();

  return querySnapshot.docs
      .map((doc) => PostModel.fromFirestore(doc.data()))
      .toList();
}


 Future<String> likePost(String postId, String uid) async {
  String res = "Some error occurred";
  try {
    DocumentSnapshot postSnapshot = await _firestore.collection('posts').doc(postId).get();
     String postOwnerId = postSnapshot.get('userId');
    // Cast the 'likes' field to List<String>
    List<String> likes = List<String>.from(postSnapshot.get('likes') ?? []);

    if (likes.contains(uid)) {
      // Remove the user from the likes list
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
      await _walletRepository.deductPoints(uid, 2, 'Unlike Post', postId);
      _profileBloc.add(FetchProfile(uid));
    } else {
      // Add the user to the likes list
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
      await _walletRepository.addPoints(uid, 2, 'like Post', postId);
      _profileBloc.add(FetchProfile(uid));

        if (uid != postOwnerId) {
        final notification = NotificationModel(
          userId: uid, // Notify the post owner
          actionType: 'like',
          actionId: postId,
          date: DateTime.now(),
          recipientId: postOwnerId,
        );
        await _notificationRepository.addNotification(notification);
      }
    
    }
    
    res = 'success';
  } catch (err) {
    res = err.toString();
  }
  return res;
}
Future<void> addComment(String postId, CommentModel comment, String uid) async {
    try {
        final postRef = _firestore.collection('posts').doc(postId);
        final postSnapshot = await postRef.get();

        if (!postSnapshot.exists) {
            throw Exception('Post not found');
        }

        final postData = postSnapshot.data();
        final postOwnerId = postData?['userId'];

        // Create a new comment document with automatic ID generation
        final commentRef = _firestore.collection('posts').doc(postId).collection('comments').doc(); // Generates a unique ID

        // Set the new comment document with the provided data
        final newComment = comment.copyWith(id: commentRef.id); // Ensure the comment has the correct ID
        await commentRef.set(newComment.toFirestore());

        await _walletRepository.addPoints(uid, 5, 'Comment Post', postId);
        _profileBloc.add(FetchProfile(uid));

        if (uid != postOwnerId) {
            final notification = NotificationModel(
                userId: uid,
                actionType: 'comment',
                actionId: postId,
                date: DateTime.now(),
                recipientId: postOwnerId,
            );
            await _notificationRepository.addNotification(notification);
        }
    } catch (e) {
        print('Error adding comment: $e');
        throw Exception('Error adding comment');
    }
}

/*Future<void> addComment(String postId, CommentModel comment,String uid) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
    
    // Fetch the post document
    final postSnapshot = await postRef.get();

    // Check if the post exists and retrieve the userId of the post owner
    if (!postSnapshot.exists) {
      throw Exception('Post not found');
    }
    
    final postData = postSnapshot.data();
    final postOwnerId = postData?['userId'];
      // Get a reference to the post's "comments" subcollection
      final commentRef = _firestore.collection('posts').doc(postId).collection('comments').doc();

      // Set the new comment document with the provided data
      await commentRef.set(comment.toFirestore());
      await _walletRepository.addPoints(uid, 5, 'Comment Post', postId);
      _profileBloc.add(FetchProfile(uid));
         if (uid != postOwnerId) {
      final notification = NotificationModel(
        userId: uid, // Notify the post owner
        actionType: 'comment',
        actionId: postId,
        date: DateTime.now(),
        recipientId: postOwnerId,
      );
      await _notificationRepository.addNotification(notification);}
    } catch (e) {
      print('Error adding comment: $e');
      throw Exception('Error adding comment');
    }
  }*/

 Future<List<CommentModel>> fetchComments(String postId) async {
    try {
      final querySnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CommentModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }
  Future<int> getCommentCount(String postId) async {
  List<CommentModel> comments = await fetchComments(postId);
  return comments.length;
}
  
 Future<void> updateComment(String postId, String commentId, String newContent) async {
  try {
    final commentRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId);

    // Update the content of the comment
    await commentRef.update({
      'commentText': newContent,
      'updatedAt': FieldValue.serverTimestamp(), // Optional: to keep track of when the comment was updated
    });
  } catch (e) {
    print('Error updating comment: $e');
    throw Exception('Failed to update comment: $e');
  }
}
Future<void> deleteComment(String postId, String commentId) async {
  try {
    await _firestore.collection('posts').doc(postId)
        .collection('comments').doc(commentId).delete();
  } catch (e) {
    throw Exception('Failed to delete comment: $e');
  }
}

Future<String> likeComment(String postId, String commentId, String uid) async {
  String res = "Some error occurred";
  try {
    DocumentSnapshot commentSnapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .get();

    // Cast the 'likes' field to List<String>
    List<String> likes = List<String>.from(commentSnapshot.get('likes') ?? []);

    if (likes.contains(uid)) {
      // Remove the user from the likes list
      await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
      await _walletRepository.deductPoints(uid, 3, 'UnLike Comment', postId);
        _profileBloc.add(FetchProfile(uid));
    } else {
      // Add the user to the likes list
      await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
      await _walletRepository.addPoints(uid, 3, 'like Comment', postId);
        _profileBloc.add(FetchProfile(uid));
    }
    res = 'success';
  } catch (err) {
    res = err.toString();
  }
  return res;
}

Future<void> deletePost(String postId) async {
  try {
    // Delete comments subcollection
    final commentsSnapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get();

    for (var doc in commentsSnapshot.docs) {
      await doc.reference.delete();
    }

    // Get the post document and check for existence
    final postSnapshot = await _firestore.collection('posts').doc(postId).get();
    
    // Ensure the post exists and data is not null before proceeding
    final postData = postSnapshot.data();
    if (postData == null || !postData.containsKey('image')) {
      print('No image field in the post or the post does not exist.');
    } else {
      final imageUrl = postData['image'] as String?;

      // Check and print the imageUrl to debug its value
      print('Image URL: $imageUrl');

      if (imageUrl != null && (imageUrl.startsWith('https://') || imageUrl.startsWith('gs://'))) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(imageUrl);
          await ref.delete();
          print('Image deleted successfully from Firebase Storage.');
        } catch (storageError) {
          print('Error deleting image from Firebase Storage: $storageError');
        }
      } else {
        print('Image URL is either a local asset, invalid, or not provided. Skipping image deletion.');
      }
    }

    // Finally, delete the post itself
    await _firestore.collection('posts').doc(postId).delete();
    print('Post deleted successfully.');
  } catch (e) {
    print('Failed to delete post: $e');
    throw Exception('Failed to delete post: $e');
  }
}

Future<List<PostModel>> fetchPostsByUserId(String userId) async {
  final querySnapshot = await _firestore
      .collection('posts')
      .where('userId', isEqualTo: userId) 
      .orderBy('createdAt', descending: true)
      .get();
  return querySnapshot.docs
      .map((doc) => PostModel.fromFirestore(doc.data()))
      .toList();
}

}
