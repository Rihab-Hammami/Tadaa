import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogoutService {
  Future<bool> logout(String realm, String refreshToken) async {
    final String logoutUrl = 'https://auth.preprod.tadaa.work/realms/$realm/protocol/openid-connect/logout';
    final String clientId = 'back';
    final String clientSecret = 'gwvIopPjoe6Dipn9Qd5VkmeH5PRO5Yrs'; // Your client secret

    final response = await http.post(
      Uri.parse(logoutUrl),
      body: {
        'client_id': clientId,
        'client_secret': clientSecret, // Add the client secret
        'refresh_token': refreshToken,
      },
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    // Log response details for debugging
    print('Logout request sent to: $logoutUrl');
    print('Request body: client_id=$clientId, client_secret=$clientSecret, refresh_token=$refreshToken');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 204) {
      // Successfully logged out
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      await prefs.remove('realm');
      return true;
    } else {
      // Logout failed, log the error
      print('Logout failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }
}
