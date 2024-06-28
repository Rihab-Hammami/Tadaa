import 'dart:convert';
import 'package:http/http.dart' as http;

class RealmApi {
  final String baseUrl;
  final http.Client client;

  RealmApi({required this.baseUrl, required this.client});

  Future<bool> verifyRealm(String realm) async {
    final response = await client.get(
      Uri.parse('$baseUrl/realms/$realm/.well-known/openid-configuration'),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
