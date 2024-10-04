import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadaa/features/addPost_page/data/models/Post.dart';
import 'package:tadaa/features/profile_page/data/models/userModel.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      throw Exception("Error fetching user: $e");
    }
  }


  Future<void> updateUserProfile(UserModel user) async {
  try {
    await _firestore.collection('users').doc(user.uid).set(user.toFirestore(), SetOptions(merge: true));
  } catch (e) {
    throw Exception("Error updating user: $e");
  }
}

 Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Error fetching all users: $e");
    }
  }


}
