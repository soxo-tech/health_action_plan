import 'package:flutter/material.dart';
import 'package:health_action_plan/features/provider/health_action_plan_provider.dart';
import 'package:health_action_plan/features/services/shared_preferences.dart';
import 'package:health_action_plan/features/view/health_action_plan.dart';
import 'package:provider/provider.dart';

/// A self-contained launcher for the Health Action Plan module.
///
/// This widget acts as the gateway for external applications. It handles:
/// 1. Persisting the [token], [baseURL], and [dbPtr] for API authentication.
/// 2. Initializing the [HealthActionPlanProvider].
/// 3. Displaying the [HealthActionPlan] view for a specific [opno].
class HealthActionPlanLauncher extends StatefulWidget {
  final String opno;
  final String token;
  final String? baseURL;
  final String? dbPtr;
  final bool isStandalone;

  const HealthActionPlanLauncher({
    super.key,
    required this.opno,
    required this.token,
    this.baseURL,
    this.dbPtr,
    this.isStandalone = false,
  });

  @override
  State<HealthActionPlanLauncher> createState() =>
      _HealthActionPlanLauncherState();
}

class _HealthActionPlanLauncherState extends State<HealthActionPlanLauncher> {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initializeModule();
  }

  Future<void> _initializeModule() async {
    // Ensure the token and environment config are saved before the view loads
    await SharedPreferenceController().setInitialControllerValues(
      token: widget.token,
      baseURL: widget.baseURL,
      dbPtr: widget.dbPtr,
    );

    if (mounted) {
      setState(() {
        _isReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HealthActionPlanProvider()),
      ],
      child: HealthActionPlan(
        widget.opno,
        packageName: widget.isStandalone ? null : 'health_action_plan',
      ),
    );
  }
}
