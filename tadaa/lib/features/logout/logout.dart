import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tadaa/features/sign_in_screen/presentation/sign_in_screen.dart';

class LogoutWidget extends StatelessWidget {
  final String realm;
  final String accessToken;

  const LogoutWidget({Key? key, required this.realm, required this.accessToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await _logout(context);
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    final response = await http.post(
      Uri.parse('https://auth.preprod.tadaa.work/auth/realms/$realm/protocol/openid-connect/logout'), // Using passed realm
      headers: {'Authorization': 'Bearer $accessToken'}, // Using passed accessToken
    );

    if (response.statusCode == 204) {
      // Logout successful
      // Navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen(realm: realm)), // Using passed realm
      );
    } else {
      // Logout failed
      // Display an error message or handle it as per your application's requirements
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
