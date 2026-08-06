import 'package:flutter/material.dart';
import 'package:health_action_plan/features/provider/health_action_plan_provider.dart';
import 'package:health_action_plan/features/services/security_service/secure_fetch.dart'
    as secure_fetch;
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

  /// Whether calls to the health-action-plan backend should be signed for
  /// the host's API gateway. When true, [clientId]/[clientSecret]/[env] are
  /// used to HMAC-sign every request. When false, requests are sent as
  /// plain calls (still to [baseURL]) with no signature headers.
  final bool apiGatewayEnabled;

  /// API gateway client id, supplied by the host when [apiGatewayEnabled].
  final String? clientId;

  /// API gateway client secret, supplied by the host when [apiGatewayEnabled].
  final String? clientSecret;

  /// API gateway environment tag (e.g. "prod"/"dev"), supplied by the host
  /// when [apiGatewayEnabled].
  final String? env;

  /// Called when one of the module's own API calls comes back 401 and stays
  /// 401 after the built-in refresh-and-retry attempt — i.e. this module's
  /// short-lived session can't be recovered on its own. The host should
  /// treat this as its own auth session being invalid too (e.g. force a full
  /// app logout), since the same access token underlies both.
  final VoidCallback? onUnauthorized;

  const HealthActionPlanLauncher({
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
    this.onUnauthorized,
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

  @override
  void didUpdateWidget(covariant HealthActionPlanLauncher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onUnauthorized != oldWidget.onUnauthorized) {
      secure_fetch.onUnauthorized = widget.onUnauthorized;
    }
  }

  Future<void> _initializeModule() async {
    secure_fetch.onUnauthorized = widget.onUnauthorized;

    // Ensure the token and environment config are saved before the view loads
    await SharedPreferenceController().setInitialControllerValues(
      token: widget.token,
      baseURL: widget.baseURL,
      dbPtr: widget.dbPtr,
      opno: widget.opno,
      apiGatewayEnabled: widget.apiGatewayEnabled,
      clientId: widget.clientId,
      clientSecret: widget.clientSecret,
      env: widget.env,
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
