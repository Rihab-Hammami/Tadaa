import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthenticationRepository {
  Future<Map<String, dynamic>> signIn(String realm, String username, String password) async {
    try {
      final Map<String, dynamic> requestBody = {
        'client_id': 'back',
        'client_secret': 'gwvIopPjoe6Dipn9Qd5VkmeH5PRO5Yrs',
        'username': username,
        'password': password,
        'grant_type': 'password',
      };

      final response = await http.post(
        Uri.parse('https://auth.preprod.tadaa.work/realms/$realm/protocol/openid-connect/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: requestBody.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&'),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to sign in');
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }
}