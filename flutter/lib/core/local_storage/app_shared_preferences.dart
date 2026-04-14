import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _fcmTokenKey = 'fcm_token';

  static Future<String> get getAccessToken async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey) ?? '';
  }

  static Future<void> setAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  static Future<String> get getRefreshToken async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey) ?? '';
  }

  static Future<void> setRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  static Future<String> get getFcmToken async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fcmTokenKey) ?? '';
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
