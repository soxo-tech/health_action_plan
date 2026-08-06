import 'dart:convert';
import 'package:health_action_plan/features/services/security_service/secure_headers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> handle401() async {
  final prefs = await SharedPreferences.getInstance();
  final baseUrl = prefs.getString('url') ?? '';
  final refreshToken = prefs.getString('refreshToken');

  if (baseUrl.isEmpty || refreshToken == null) return null;

  final endpoint = '/auth/refresh';

  final secure = await createSecureHeaders(
    endpoint: endpoint,
    method: 'POST',
    body: {"refreshToken": refreshToken},
    gatewayEnabled: prefs.getBool('apiGatewayEnabled') ?? true,
    clientId: prefs.getString('clientId'),
    clientSecret: prefs.getString('clientSecret'),
    env: prefs.getString('env'),
  );

  final res = await http.post(
    Uri.parse(baseUrl + secure.canonicalEndpoint),
    headers: secure.headers,
    body: secure.rawBody,
  );

  if (res.statusCode != 200) {
    await prefs.clear();
    return null;
  }

  final data = jsonDecode(res.body);

  await prefs.setString('accessToken', data['access_token']);

  if (data['refresh_token'] != null) {
    await prefs.setString('refreshToken', data['refresh_token']);
  }

  return data['access_token'];
}
