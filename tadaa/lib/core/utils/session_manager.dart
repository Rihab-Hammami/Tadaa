import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  Future<void> setRealm(String realm) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('realm', realm);
  }

  Future<String?> getRealm() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('realm');
  }

  Future<void> setAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
  }

  /*Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }*/

  Future<void> setRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refreshToken', refreshToken);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
   // await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('realm');
  }
}
