import 'package:flutter/material.dart';
import 'package:health_action_plan/features/view/health_action_plan_launcher.dart';

/// The entry point of the application.
///
/// Ensures that plugin services are initialized before running the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Retrieve values from environment variables (--dart-define) or native
  // bridge. When this module is embedded in the host app, these all come
  // from the host via HealthActionPlanLauncher's constructor params instead.
  // Standalone runs pass real values via --dart-define; nothing is
  // hardcoded here.
  const String opno = String.fromEnvironment('OPNO', defaultValue: '');
  const String token = String.fromEnvironment('TOKEN', defaultValue: '');
  const String baseURL = String.fromEnvironment('BASE_URL', defaultValue: '');
  const String dbPtr = String.fromEnvironment('DB_PTR', defaultValue: '');
  const bool apiGatewayEnabled = bool.fromEnvironment(
    'API_GATEWAY_ENABLED',
    defaultValue: true,
  );
  const String clientId = String.fromEnvironment('CLIENT_ID', defaultValue: '');
  const String clientSecret =
      String.fromEnvironment('CLIENT_SECRET', defaultValue: '');
  const String env = String.fromEnvironment('ENV', defaultValue: '');

  runApp(HealthActionPlanApp(
    opno: opno,
    token: token,
    baseURL: baseURL,
    dbPtr: dbPtr,
    isStandalone: true,
    apiGatewayEnabled: apiGatewayEnabled,
    clientId: clientId,
    clientSecret: clientSecret,
    env: env,
  ));
}

/// The root widget of the Health Action Plan application.
class HealthActionPlanApp extends StatelessWidget {
  final String opno;
  final String token;
  final String? baseURL;
  final String? dbPtr;
  final bool isStandalone;
  final bool apiGatewayEnabled;
  final String? clientId;
  final String? clientSecret;
  final String? env;

  /// Creates a [HealthActionPlanApp] instance.
  const HealthActionPlanApp({
    super.key,
    required this.opno,
    required this.token,
    this.baseURL,
    this.dbPtr,
    this.isStandalone = false,
    this.apiGatewayEnabled = true,
    this.clientId,
    this.clientSecret,
    this.env,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HealthActionPlanLauncher(
        opno: opno,
        token: token,
        baseURL: baseURL,
        dbPtr: dbPtr,
        isStandalone: isStandalone,
        apiGatewayEnabled: apiGatewayEnabled,
        clientId: clientId,
        clientSecret: clientSecret,
        env: env,
      ),
    );
  }
}
