import 'package:flutter/material.dart';
import 'package:tadaa/features/logout/data/logout_service.dart';
import 'package:tadaa/features/sign_in_screen/presentation/pages/sign_in_screen.dart';

Future<void> logout(BuildContext context, String realm, String refreshToken) async {
  final logoutService = LogoutService();
  final success = await logoutService.logout(realm, refreshToken);

  if (success) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen(realm: realm)),
      (route) => false,
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logout failed. Please try again.')),
    );
  }
}
