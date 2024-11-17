import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tadaa/features/notification_page/data/notificationModel.dart';
import 'package:tadaa/features/notification_page/domain/notificationRepository.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_bloc.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_event.dart';
import 'package:tadaa/features/story_page/data/models/storyModel.dart';
import 'dart:io';

import 'package:tadaa/features/wallet_page/domain/repository/walletRepository.dart';

class StoryRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;
  final WalletRepository _walletRepository;
  final ProfileBloc _profileBloc;
  final NotificationRepository _notificationRepository;

  StoryRepository({
    required WalletRepository walletRepository,
    required NotificationRepository notificationRepository,
    required ProfileBloc profileBloc,
    FirebaseFirestore? firebaseFirestore,
    FirebaseStorage? firebaseStorage,
  })  : _walletRepository = walletRepository,
        _notificationRepository = notificationRepository,
        _profileBloc = profileBloc,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  // Upload image to Firebase Storage and return the URL
  Future<String> uploadImage(File imageFile, String storyId) async {
    try {
      // Create a reference in Firebase Storage
      final storageRef = _firebaseStorage.ref().child('stories/$storyId/${imageFile.uri.pathSegments.last}');
      
      // Upload the image file to Firebase Storage
      final uploadTask = await storageRef.putFile(imageFile);
      
      // Get the download URL once upload is complete
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  // Add a new story to Firebase
  Future<void> addStory(StoryModel story, File? imageFile) async {
    try {
      // If there's an image, upload it to Firebase Storage
      if (imageFile != null) {
        final imageUrl = await uploadImage(imageFile, story.storyId);
        story = story.copyWith(mediaUrl: imageUrl);  // Update the mediaUrl with the uploaded image URL
      }
      
      // Add story to Firestore with the updated mediaUrl
      await _firebaseFirestore
          .collection('stories')
          .doc(story.storyId)
          .set(story.toFirestore()); 

      await _walletRepository.addPoints(story.userId, 10, 'Create Story', story.storyId);     
      _profileBloc.add(FetchProfile(story.userId));    
      /*final notification = NotificationModel(
      userId: story.userId,
      actionType: 'new story',
      actionId: story.storyId,
      date: DateTime.now(),
      recipientId: story.userId
    );
    await _notificationRepository.addNotification(notification);*/
    } catch (e) {
      throw Exception('Error adding story: $e');
    }
  }
  Future<List<StoryModel>> fetchAllStories() async {
  try {
    // Get all stories from the 'stories' collection
    final snapshot = await _firebaseFirestore
        .collection('stories')
        .orderBy('createdAt', descending: true)
        .get();

    // Map the documents to StoryModel instances
    final stories = snapshot.docs
        .map((doc) => StoryModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();

    return stories;
  } catch (e) {
    throw Exception('Failed to fetch all stories: $e');
  }
}

   Future<List<StoryModel>> fetchStoriesByType(String type) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('stories')
          .where('type', isEqualTo: type)
          .orderBy('createdAt', descending: true)
          .get();

      final stories = snapshot.docs
          .map((doc) => StoryModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();

      return stories;
    } catch (e) {
      throw Exception('Failed to fetch stories: $e');
    }
  }

  // Fetch stories by storyId (for a specific user's stories)
  /*Future<List<StoryModel>> fetchStoriesByStoryId(String storyId) async {
  try {
    final snapshot = await _firebaseFirestore
        .collection('stories')
        .where('storyId', isEqualTo: storyId)
        .orderBy('createdAt', descending: true)
        .get();

    final stories = snapshot.docs
        .map((doc) => StoryModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();

    if (stories.isEmpty) {
      throw Exception('No stories found for the given storyId.$storyId');
    }

    return stories;
  } catch (e) {
    throw Exception('Failed to fetch stories: $e');
  }
}*/
 Future<void> viewStory(String storyId, String userId) async {
    try {
      // Reference the specific story document
      final storyDocRef = _firebaseFirestore.collection('stories').doc(storyId);
      
      // Run a transaction to ensure atomicity
      await _firebaseFirestore.runTransaction((transaction) async {
        // Get the current story document
        final storySnapshot = await transaction.get(storyDocRef);

        if (!storySnapshot.exists) {
          throw Exception('Story does not exist');
        }

        // Get the current views
        List<String> currentViews = List<String>.from(storySnapshot.data()?['views'] ?? []);
        
        // Check if the user has already viewed the story
        if (!currentViews.contains(userId)) {
          // Add the user ID to the views
          currentViews.add(userId);
          
          // Update the story document with the new views list
          transaction.update(storyDocRef, {'views': currentViews});
        }
      });
    } catch (e) {
      throw Exception('Error viewing story: $e');
    }
  }

 Future<void> likeStory(String storyId, String userId) async {
    try {
      // Reference the specific story document
      final storyDocRef = _firebaseFirestore.collection('stories').doc(storyId);

      // Run a transaction to ensure atomicity
      await _firebaseFirestore.runTransaction((transaction) async {
        // Get the current story document
        final storySnapshot = await transaction.get(storyDocRef);

        if (!storySnapshot.exists) {
          throw Exception('Story does not exist');
        }

        // Get the current likes
        List<String> currentLikes = List<String>.from(storySnapshot.data()?['likes'] ?? []);

        // Check if the user has already liked the story
        if (!currentLikes.contains(userId)) {
          // Add the user ID to the likes list
          currentLikes.add(userId);
          await _walletRepository.addPoints(userId, 2, 'like Story', storyId);     
          _profileBloc.add(FetchProfile(userId));    
          // Update the story document with the new likes list
          transaction.update(storyDocRef, {'likes': currentLikes});
        } else {
          throw Exception('User has already liked this story');
        }
      });
    } catch (e) {
      throw Exception('Error liking story: $e');
    }
  }

  Future<void> expireStories() async {
    try {
      // Get the current time
      DateTime now = DateTime.now();

      // Query all stories where the createdAt timestamp is older than 24 hours
      QuerySnapshot expiredStories = await _firebaseFirestore
          .collection('stories')
          .where('createdAt', isLessThan: now.subtract(Duration(hours: 24)))
          .get();

      // Loop through each story and delete it
      for (var doc in expiredStories.docs) {
        await _firebaseFirestore..collection('stories').doc(doc.id).delete();
      }

      print('Expired stories successfully deleted.');
    } catch (e) {
      print('Error deleting expired stories: $e');
    }
  }

  Future<void> deleteStory(String storyId, String? mediaUrl) async {
  try {
    // Delete story document from Firestore
    await _firebaseFirestore.collection('stories').doc(storyId).delete();

    // If the story has media (an image), delete it from Firebase Storage
    if (mediaUrl != null && mediaUrl.isNotEmpty) {
      final storageRef = _firebaseStorage.refFromURL(mediaUrl);
      await storageRef.delete();
    }
  } catch (e) {
    throw Exception('Error deleting story: $e');
  }
}
 
 



}
  

