// lib/user_info.dart
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<String?> getLastname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastname');
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }
}
