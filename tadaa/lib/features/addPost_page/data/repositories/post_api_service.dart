import 'dart:convert';
import 'package:http/http.dart' as http;

class PostApiService {
  final http.Client client;

  PostApiService(this.client);

  Future<http.Response> createSimplePost(Map<String, dynamic> postData) async {
    final url = Uri.parse('http://localhost:8080/posts/simple');
    return await client.post(url, body: jsonEncode(postData), headers: {'Content-Type': 'application/json'});
  }

  Future<http.Response> createAppreciationPost(Map<String, dynamic> postData) async {
    final url = Uri.parse('http://localhost:8080/posts/appreciation');
    return await client.post(url, body: jsonEncode(postData), headers: {'Content-Type': 'application/json'});
  }

  Future<http.Response> createCelebrationPost(Map<String, dynamic> postData) async {
    final url = Uri.parse('http://localhost:8080/posts/celebration');
    return await client.post(url, body: jsonEncode(postData), headers: {'Content-Type': 'application/json'});
  }
  Future<http.Response> fetchPosts() async {
    final url = Uri.parse('http://localhost:8080/posts/all');
    return await client.get(url);
  }
  
}
