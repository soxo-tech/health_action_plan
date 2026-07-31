import 'package:flutter/material.dart';
import 'package:health_action_plan/features/view/health_action_plan_launcher.dart';

/// The entry point of the application.
///
/// Ensures that plugin services are initialized before running the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Retrieve values from environment variables or native bridge
  const String opno = String.fromEnvironment('OPNO', defaultValue: '');
  const String token = String.fromEnvironment('TOKEN', defaultValue: '');

  runApp(HealthActionPlanApp(opno: opno, token: token, isStandalone: true));
}

/// The root widget of the Health Action Plan application.
class HealthActionPlanApp extends StatelessWidget {
  final String opno;
  final String token;
  final bool isStandalone;

  /// Creates a [HealthActionPlanApp] instance.
  const HealthActionPlanApp({
    super.key,
    required this.opno,
    required this.token,
    this.isStandalone = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HealthActionPlanLauncher(
        opno: opno,
        token: token,
        // baseURL: '', // Added default for testing
        dbPtr: '', // Added default for testing
        isStandalone: isStandalone,
        // You can also pass baseURL and dbPtr here if needed
      ),
    );
  }
}
