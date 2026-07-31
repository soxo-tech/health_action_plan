class Env {
  String healthActionPlanAPI(String opno) {
    return 'appointments/get-yearwise-screening-details/$opno';
  }
  //Refresh Token
  String refreshTokenAPI = 'auth/refresh';
  String CLIENT_ID = "4fc75940-790a-4ae7-82e8-70eee30a4dfb";
  String CLIENT_SECRET = "SrIl1TrkO9QZiHB0MlKueYppw4uL9uwz_TGc54gIwVg";
  String env = "dev";
  String baseURL = "https://ahad6dk2xe.execute-api.ap-south-1.amazonaws.com/dev/";
}
