import 'dart:convert';
import 'package:health_action_plan/features/core/env.dart';

import 'secure_crypto.dart';
import 'device.dart';
import 'package:uuid/uuid.dart';

class SecureHeaderResult {
  final String canonicalEndpoint;
  final String rawBody;
  final Map<String, String> headers;

  SecureHeaderResult({
    required this.canonicalEndpoint,
    required this.rawBody,
    required this.headers,
  });
}

Future<SecureHeaderResult> createSecureHeaders({
  required String endpoint,
  required String method,
  dynamic body,
}) async {
  final CLIENT_ID = Env().CLIENT_ID;
  final CLIENT_SECRET = Env().CLIENT_SECRET;
  final env = Env().env;

  final httpMethod = method.toUpperCase();

  final rawBody = (httpMethod == 'GET' || httpMethod == 'DELETE')
      ? ''
      : (body == null ? '' : (body is String ? body : jsonEncode(body)));

  final canonicalEndpoint = cleanNullParams(endpoint);
  final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  final nonce = const Uuid().v4();

  final deviceId = await getOrCreateDeviceId();
  final fingerprint = await createDeviceFingerprint();

  final bodyHash = await sha256Hex(rawBody);

  final canonical =
      '$httpMethod\n$canonicalEndpoint\n$timestamp\n$nonce\n$bodyHash';
  final certToken = hmacSha256Base64Url(CLIENT_SECRET, canonical);

  return SecureHeaderResult(
    canonicalEndpoint: canonicalEndpoint,
    rawBody: rawBody,
    headers: {
      'X-Client-Id': CLIENT_ID,
      'X-Client-Secret': CLIENT_SECRET,
      'X-Cert-Token': certToken,
      'X-Timestamp': timestamp,
      'X-Nonce': nonce,
      'X-Device-Id': deviceId,
      'X-Fingerprint': fingerprint,
      if (httpMethod != 'GET' && httpMethod != 'DELETE')
        'Content-Type': 'application/json',
      'X-env': env
    },
  );
}

String cleanNullParams(String url) {
  final uri = Uri.parse(url);

  final params = Map.fromEntries(
    uri.queryParameters.entries.where(
      (e) => e.value != null && e.value != "null" && e.value!.isNotEmpty,
    ),
  );

  final sortedKeys = params.keys.toList()..sort();

  final query = sortedKeys
      .map((k) => '$k=${Uri.encodeQueryComponent(params[k]!)}')
      .join('&');

  final path = uri.path.startsWith('/') ? uri.path : '/${uri.path}';

  return query.isEmpty ? path : '$path?$query';
}
