import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static void saveLastLogin(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_login', userId);
  }

  static Future<String> loadLastLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString('last_login'));
  }

  static void saveQuote(String quote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('quote', quote);
  }

  static Future<String> loadQuote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString('quote'));
  }
}