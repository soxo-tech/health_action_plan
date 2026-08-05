/// Route builders for the module's own endpoints.
///
/// Deliberately holds no credentials or base URL — those come from the host
/// via [HealthActionPlanLauncher] and are read from [SharedPreferencesService]
/// where needed (see `secure_fetch.dart` / `secure_headers.dart`).
class Env {
  String healthActionPlanAPI(String opno) {
    return 'appointments/get-yearwise-screening-details/$opno';
  }
  //Refresh Token
  String refreshTokenAPI = 'auth/refresh';
}
