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
  /// Persists the environment config supplied by the host.
  ///
  /// [token] The token string to be saved in SharedPreferences.
  Future<void> setInitialControllerValues({
    String? token,
    String? baseURL,
    String? dbPtr,
    String? opno,
    bool? apiGatewayEnabled,
    String? clientId,
    String? clientSecret,
    String? env,
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
    // Sent as the `realId` request header on every module API call.
    if (opno != null) {
      await pref.setString("realId", opno);
    }
    if (apiGatewayEnabled != null) {
      await pref.setBool("apiGatewayEnabled", apiGatewayEnabled);
    }
    if (clientId != null) {
      await pref.setString("clientId", clientId);
    }
    if (clientSecret != null) {
      await pref.setString("clientSecret", clientSecret);
    }
    if (env != null) {
      await pref.setString("env", env);
    }
  }
}
