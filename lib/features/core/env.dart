class Env {
  String healthActionPlanAPI(String opno) {
    return 'appointments/get-yearwise-screening-details/$opno';
  }
  //Refresh Token
  String refreshTokenAPI = 'auth/refresh';
}
