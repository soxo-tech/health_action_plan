// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:health_action_plan/main.dart';
import 'package:health_action_plan/features/view/health_action_plan_launcher.dart';

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const HealthActionPlanApp(
        opno: 'TEST123',
        token: 'mock_token',
        isStandalone: true,
      ),
    );

    // Verify that the Launcher starts in a loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Since Firebase and SharedPreferences are initialized in main/initState,
    // further testing here would require mocking those plugins.
  });
}
