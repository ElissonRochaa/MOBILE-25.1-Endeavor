import 'package:shared_preferences/shared_preferences.dart';

class AuthStorageService{
  static const _token = 'token';
  static const _userId = 'userId';

  Future<void> saveAuthData(String userId, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_token, token);
    await prefs.setString(_userId, userId);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_token);
  }

  Future<String?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userId);
  }

  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_token);
    await prefs.remove(_userId);
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_userId);
    final token = prefs.getString(_token);
    if (userId == null || token == null) {
      return false;
    }

    return true;
  }
}

