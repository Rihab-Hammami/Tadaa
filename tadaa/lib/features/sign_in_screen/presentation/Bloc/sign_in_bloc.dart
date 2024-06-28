import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tadaa/features/home_page/presentation/widgets/nav_bar.dart';
import 'package:tadaa/features/sign_in_screen/domain/use_cases/authenticate_user_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInBloc {
  final AuthenticateUserUseCase _useCase;

  SignInBloc(this._useCase);

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  Future<void> signIn(BuildContext context, String realm, String username, String password) async {
    try {
      _isLoadingController.add(true); // Notify UI that loading started

      final response = await _useCase.execute(realm, username, password);

      // Save tokens and realm in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', response['access_token']);
      await prefs.setString('refreshToken', response['refresh_token']);
      await prefs.setString('realm', realm);

      // Navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavBar()),
      );

      // Print access token and refresh token
      print('Access Token: ${response['access_token']}');
      print('Refresh Token: ${response['refresh_token']}');
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

  void dispose() {
    _isLoadingController.close();
  }
}
