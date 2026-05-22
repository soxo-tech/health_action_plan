import 'package:shared_preferences/shared_preferences.dart';

/// Singleton service for managing SharedPreferences.
class SharedPreferencesService {
  // Singleton instance
  static final SharedPreferencesService _instance =
      SharedPreferencesService._internal();

  /// Factory constructor to return the singleton instance.
  factory SharedPreferencesService() {
    return _instance;
  }

  SharedPreferencesService._internal();

  /// A future that completes with the SharedPreferences instance.
  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  /// Initializes the SharedPreferences instance.
  /// This method is not required to be explicitly called as SharedPreferences is initialized lazily.
  Future<void> setPreferences() async {
    await prefs;
  }
}

/// Controller class for managing and accessing shared preferences values.
class SharedPreferenceController {
  /// Sets an initial value for the token.
  ///
  /// [token] The token string to be saved in SharedPreferences.
  Future<void> setInitialControllerValues({
    String? token,
    String? baseURL,
    String? dbPtr,
  }) async {
    final pref = await SharedPreferencesService.prefs;
    if (token != null) {
      await pref.setString("token", token);
    }
    if (baseURL != null) {
      await pref.setString("url", baseURL);
    }
    if (dbPtr != null) {
      await pref.setString("dbptr", dbPtr);
    }
  }
}
