import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  static const _userIdKey = 'user_id';
  static const _emailKey = 'user_email';
  static const _tokenKey = 'auth_token';


  Future<void> saveUser(String id, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, id);
    await prefs.setString(_emailKey, email);
  }

  Future<Map<String, String>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_userIdKey);
    final email = prefs.getString(_emailKey);

    if (id != null && email != null) {
      return {'id': id, 'email': email};
    }
    return null;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_emailKey);
  }
  
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
}
