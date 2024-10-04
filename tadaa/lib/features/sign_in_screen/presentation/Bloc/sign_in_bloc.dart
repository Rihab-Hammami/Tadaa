import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tadaa/features/home_page/presentation/widgets/nav_bar.dart';
import 'package:tadaa/features/sign_in_screen/domain/use_cases/authenticate_user_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInBloc {
  final AuthenticateUserUseCase _useCase;

  SignInBloc(this._useCase);

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  Future<void> signIn(BuildContext context, String realm, String username, String password) async {
  try {
    _isLoadingController.add(true); 

    final response = await _useCase.execute(realm, username, password);

    // Save tokens and realm in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', response['access_token']);
    await prefs.setString('refreshToken', response['refresh_token']);
    await prefs.setString('realm', realm);

    // Decode the access token to get user information
    Map<String, dynamic> userData = _decodeAndStoreToken(response['access_token'], prefs);

    // Synchronize with Firebase, pass the password here
    User? firebaseUser = await _syncWithFirebase(userData, password);

    // Save the Firebase user ID in SharedPreferences
    if (firebaseUser != null) {
      await prefs.setString('uid', firebaseUser.uid);
    }

    // Navigate to home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NavBar()),
    );

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Invalid username or password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 243, 169, 71),
      ),
    );
    print('Error signing in: $e');
  } finally {
    _isLoadingController.add(false); // Notify UI that loading finished
  }
}



 Map<String, dynamic> _decodeAndStoreToken(String token, SharedPreferences prefs) {
  try {
    final decodedToken = JwtDecoder.decode(token);
    print('Decoded Token: $decodedToken');

    // Extract user information
    final String retrievedUsername = decodedToken['preferred_username'] ?? 'unknown';
    final String retrievedLastname = decodedToken['family_name'] ?? 'unknown';
    final String retrievedName = decodedToken['name'] ?? 'unknown';
    final String email = decodedToken['email'] ?? 'unknown';
    
    // Extract the first role
   String? role;
    if (decodedToken.containsKey('realm_access')) {
      final realmAccess = decodedToken['realm_access'];
      if (realmAccess is Map<String, dynamic> && realmAccess.containsKey('roles')) {
        final roles = List<String>.from(realmAccess['roles']);
        if (roles.isNotEmpty) {
          role = roles.first;
        }
      }
    }

    // Save user information and the first role in SharedPreferences
    prefs.setString('username', retrievedUsername);
    prefs.setString('lastname', retrievedLastname);
    prefs.setString('name', retrievedName);
    prefs.setString('email', email);
    prefs.setString('role', role ?? 'none');

    print('Username: $retrievedUsername');
    print('Lastname: $retrievedLastname');
    print('Name: $retrievedName');
    print('Email: $email');
    print('Role: $role');

    return {
      'username': retrievedUsername,
      'lastname': retrievedLastname,
      'name': retrievedName,
      'email': email,
      'role': role ?? 'none',
    };
  } catch (e) {
    print('Error decoding token: $e');
    return {};
  }
}

 Future<User?> _syncWithFirebase(Map<String, dynamic> userData, String password) async {
  try {
    User? firebaseUser;
    
    // Check if user already exists in Firebase Authentication
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userData['email'],
        password: password,
      );
      firebaseUser = userCredential.user;
      print("User logged in successfully");
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        // If user doesn't exist, create a new one
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userData['email'],
          password: password,
        );
        firebaseUser = userCredential.user;
        print("User registered successfully");
      } else {
        throw e;
      }
    }
    // Once logged in, check if the user profile exists in Firestore
    if (firebaseUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();

      if (!userDoc.exists) {
  // If user profile doesn't exist, create a new one
  await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
    'username': userData['username'],
    'lastname': userData['lastname'],
    'name': userData['name'],
    'email': userData['email'],
    'role': userData['role'],
    'uid': firebaseUser.uid,
  }).then((_) {
    print('New user data successfully written to Firestore');
  }).catchError((error) {
    print('Failed to write new user data to Firestore: $error');
  });
} else {
  // If user profile already exists, merge updated fields
  await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
    'username': userData['username'],
    'lastname': userData['lastname'],
    'name': userData['name'],
    'email': userData['email'],
    'role': userData['role'],  // Ensure 'role' is being saved
    'uid': firebaseUser.uid,
  }, SetOptions(merge: true)).then((_) {
    print('User data successfully merged to Firestore');
  }).catchError((error) {
    print('Failed to merge user data to Firestore: $error');
  });
}
    }
    return firebaseUser;
  } catch (e) {
    print('Error syncing with Firebase: $e');
    throw Exception('Failed to sync with Firebase');
  }
}

  void dispose() {
    _isLoadingController.close();
  }
}
