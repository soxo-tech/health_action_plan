import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:health_action_plan/features/services/security_service/device.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('getOrCreateDeviceId', () {
    test('generates and persists an id when none is stored', () async {
      SharedPreferences.setMockInitialValues({});

      final id = await getOrCreateDeviceId();

      expect(id, isNotEmpty);

      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString('DEVICE_ID'),
        id,
        reason: 'the generated id must be written back to SharedPreferences',
      );
    });

    test('generated id is a v4 uuid', () async {
      SharedPreferences.setMockInitialValues({});

      final id = await getOrCreateDeviceId();

      expect(
        id,
        matches(
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          ),
        ),
      );
    });

    test('returns the same id across calls', () async {
      SharedPreferences.setMockInitialValues({});

      final first = await getOrCreateDeviceId();
      final second = await getOrCreateDeviceId();

      expect(second, first);
    });

    test('returns the stored id without overwriting it', () async {
      const stored = '11111111-2222-4333-8444-555555555555';
      SharedPreferences.setMockInitialValues({'DEVICE_ID': stored});

      expect(await getOrCreateDeviceId(), stored);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('DEVICE_ID'), stored);
    });
  });

  group('createDeviceFingerprint', () {
    // On the test host neither Platform.isAndroid nor Platform.isIOS holds, so
    // this exercises the getOrCreateDeviceId fallback that secure headers (and
    // therefore login) depend on.
    test('is a sha256 hex digest', () async {
      SharedPreferences.setMockInitialValues({});

      final fingerprint = await createDeviceFingerprint();

      expect(fingerprint, matches(RegExp(r'^[0-9a-f]{64}$')));
    });

    test('is stable across calls on the same device', () async {
      SharedPreferences.setMockInitialValues({});

      final first = await createDeviceFingerprint();
      final second = await createDeviceFingerprint();

      expect(second, first);
    });

    test('differs when the underlying device id differs', () async {
      SharedPreferences.setMockInitialValues({
        'DEVICE_ID': '11111111-2222-4333-8444-555555555555',
      });
      final first = await createDeviceFingerprint();

      SharedPreferences.setMockInitialValues({
        'DEVICE_ID': '66666666-7777-4888-8999-aaaaaaaaaaaa',
      });
      final second = await createDeviceFingerprint();

      expect(second, isNot(first));
    });
  });
}
