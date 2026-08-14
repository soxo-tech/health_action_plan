import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:health_action_plan/features/services/api_services.dart';

/// Captures the outgoing [RequestOptions] and answers with a canned 200 so the
/// tests never touch the network.
class _RecordingAdapter implements HttpClientAdapter {
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      '{"status":"ok"}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _RecordingAdapter adapter;

  setUp(() {
    adapter = _RecordingAdapter();
    ApiService.dio.httpClientAdapter = adapter;
  });

  group('apiMethodSetup base URL guard', () {
    test('returns null and sends nothing when no base URL is available', () async {
      SharedPreferences.setMockInitialValues({});

      final response = await ApiService.apiMethodSetup(
        method: ApiMethod.get,
        url: '/plans',
      );

      expect(response, isNull);
      expect(
        adapter.lastRequest,
        isNull,
        reason: 'no request may be issued without a base URL',
      );
    });

    test('returns null when other prefs exist but the url key does not', () async {
      SharedPreferences.setMockInitialValues({
        'dbptr': 'db1',
        'realId': 'NURA-1',
        'token': 'a-token',
      });

      final response = await ApiService.apiMethodSetup(
        method: ApiMethod.get,
        url: '/plans',
      );

      expect(response, isNull);
      expect(adapter.lastRequest, isNull);
    });
  });

  group('apiMethodSetup request configuration', () {
    test('uses the stored base URL when no override is passed', () async {
      SharedPreferences.setMockInitialValues({
        'url': 'https://stored.example.com',
      });

      final response = await ApiService.apiMethodSetup(
        method: ApiMethod.get,
        url: '/plans',
      );

      expect(response?.statusCode, 200);
      expect(
        adapter.lastRequest?.uri.toString(),
        'https://stored.example.com/plans',
      );
    });

    test('bUrl overrides the stored base URL', () async {
      SharedPreferences.setMockInitialValues({
        'url': 'https://stored.example.com',
      });

      await ApiService.apiMethodSetup(
        method: ApiMethod.get,
        url: '/plans',
        bUrl: 'https://override.example.com',
      );

      expect(
        adapter.lastRequest?.uri.toString(),
        'https://override.example.com/plans',
      );
    });

    test('succeeds with only bUrl and nothing in prefs', () async {
      SharedPreferences.setMockInitialValues({});

      final response = await ApiService.apiMethodSetup(
        method: ApiMethod.get,
        url: '/plans',
        bUrl: 'https://override.example.com',
      );

      expect(response?.statusCode, 200);
      expect(
        adapter.lastRequest?.uri.toString(),
        'https://override.example.com/plans',
      );
    });

    test('sends db_ptr and realId headers from prefs', () async {
      SharedPreferences.setMockInitialValues({
        'url': 'https://stored.example.com',
        'dbptr': 'db-from-prefs',
        'realId': 'NURA-42',
      });

      await ApiService.apiMethodSetup(method: ApiMethod.get, url: '/plans');

      expect(adapter.lastRequest?.headers['db_ptr'], 'db-from-prefs');
      expect(adapter.lastRequest?.headers['realId'], 'NURA-42');
    });

    test('dbPtr argument overrides the stored dbptr', () async {
      SharedPreferences.setMockInitialValues({
        'url': 'https://stored.example.com',
        'dbptr': 'db-from-prefs',
      });

      await ApiService.apiMethodSetup(
        method: ApiMethod.get,
        url: '/plans',
        dbPtr: 'db-from-arg',
      );

      expect(adapter.lastRequest?.headers['db_ptr'], 'db-from-arg');
    });

    test('omits the realId header when no realId is stored', () async {
      SharedPreferences.setMockInitialValues({
        'url': 'https://stored.example.com',
      });

      await ApiService.apiMethodSetup(method: ApiMethod.get, url: '/plans');

      expect(adapter.lastRequest?.headers.containsKey('realId'), isFalse);
    });
  });
}
