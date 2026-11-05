import 'package:fin_track/app.dart';
import 'package:fin_track/widgets/flow_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_fonts.dart';

void main() {
  setUpAll(loadAppFonts);

  Finder tab(String label) =>
      find.descendant(of: find.byType(FlowHeader), matching: find.text(label));

  Future<void> pumpApp(
    WidgetTester tester, {
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(FinTrackApp(now: DateTime(2026, 11, 5)));
    await tester.pumpAndSettle();
  }

  Future<void> capture(WidgetTester tester, String name) async {
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/$name.png'),
    );
  }

  testWidgets('golden — general dashboard', (tester) async {
    await pumpApp(tester);
    await capture(tester, 'general');
  });

  testWidgets('golden — bills dashboard', (tester) async {
    await pumpApp(tester);
    await tester.tap(tab('Bills'));
    await tester.pumpAndSettle();
    await capture(tester, 'bills');
  });

  testWidgets('golden — income dashboard', (tester) async {
    await pumpApp(tester);
    await tester.tap(tab('Income'));
    await tester.pumpAndSettle();
    await capture(tester, 'income');
  });

  testWidgets('golden — general full page', (tester) async {
    await pumpApp(tester, size: const Size(390, 1900));
    await capture(tester, 'general_full');
  });

  testWidgets('golden — bills full page', (tester) async {
    await pumpApp(tester, size: const Size(390, 1900));
    await tester.tap(tab('Bills'));
    await tester.pumpAndSettle();
    await capture(tester, 'bills_full');
  });

  testWidgets('golden — income full page', (tester) async {
    await pumpApp(tester, size: const Size(390, 1900));
    await tester.tap(tab('Income'));
    await tester.pumpAndSettle();
    await capture(tester, 'income_full');
  });
}
