import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_action_plan/features/widgets/svg_image.dart';

void main() {
  testWidgets('SvgImage renders correctly with provided path', (
    WidgetTester tester,
  ) async {
    const testPath = 'bookmark';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SvgImage(
            svgPath: testPath,
            svgHeight: 50,
            svgWidth: 50,
            packageName: 'health_action_plan',
          ),
        ),
      ),
    );

    // Find the SvgPicture widget
    final svgFinder = find.byType(SvgPicture);
    expect(svgFinder, findsOneWidget);

    // Verify properties
    final SvgPicture svgWidget = tester.widget(svgFinder);

    // SvgPicture.asset internal logic uses SvgAssetLoader in version 2.x
    // We check if the loader has the correct asset name
    final loader = svgWidget.bytesLoader as SvgAssetLoader;
    expect(loader.assetName, 'assets/svg/$testPath.svg');
    expect(svgWidget.height, 50);
    expect(svgWidget.width, 50);

    // Verify package name is passed correctly
    expect(loader.packageName, 'health_action_plan');
  });
}
