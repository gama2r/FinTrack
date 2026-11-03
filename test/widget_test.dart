import 'package:fin_track/app.dart';
import 'package:fin_track/widgets/add_sheet.dart';
import 'package:fin_track/widgets/flow_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_fonts.dart';

void main() {
  setUpAll(loadAppFonts);

  Finder tab(String label) =>
      find.descendant(of: find.byType(FlowHeader), matching: find.text(label));

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const FinTrackApp());
    await tester.pumpAndSettle();
  }

  testWidgets('renders the General dashboard by default', (tester) async {
    await pumpApp(tester);

    expect(find.text('NET CASH FLOW'), findsOneWidget);
    expect(find.text('\$8,420.50'), findsOneWidget);
    expect(find.text('Cash Flow Activity'), findsOneWidget);
    expect(find.text('Emergency Fund'), findsOneWidget);
  });

  testWidgets('top menu switches between all three dashboards', (tester) async {
    await pumpApp(tester);

    await tester.tap(tab('Bills'));
    await tester.pumpAndSettle();
    expect(find.text('Total Bills for October'), findsOneWidget);
    expect(find.text('Category Allocation'), findsOneWidget);
    expect(find.text('Due Soon & Urgent'), findsOneWidget);

    await tester.tap(tab('Income'));
    await tester.pumpAndSettle();
    expect(find.text('TOTAL RECEIVED • OCTOBER'), findsOneWidget);
    expect(find.text('Income Streams'), findsOneWidget);
    expect(find.text('Income Trajectory'), findsOneWidget);

    await tester.tap(tab('General'));
    await tester.pumpAndSettle();
    expect(find.text('NET CASH FLOW'), findsOneWidget);
  });

  testWidgets('cash flow filter hides inflows and outflows', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Outflow'));
    await tester.pumpAndSettle();
    expect(find.text('Whole Foods Market'), findsOneWidget);
    expect(find.text('Salary Direct Deposit'), findsNothing);

    await tester.tap(find.text('Inflow'));
    await tester.pumpAndSettle();
    expect(find.text('Salary Direct Deposit'), findsOneWidget);
    expect(find.text('Whole Foods Market'), findsNothing);
  });

  testWidgets('Pay Now settles the rent bill', (tester) async {
    await pumpApp(tester);
    await tester.tap(tab('Bills'));
    await tester.pumpAndSettle();

    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('Pay Now'),
      250,
      scrollable: scrollable,
    );
    await tester.tap(find.text('Pay Now'));
    await tester.pump();
    expect(find.text('Processing...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pump();
    expect(find.text('Luxury Apartment Rent settled.'), findsOneWidget);
    expect(find.text('Paid'), findsWidgets);
    expect(find.text('Paid just now • Bank Transfer'), findsOneWidget);
  });

  testWidgets('FAB opens the log sheet and adds a transaction', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Add transaction'));
    await tester.pumpAndSettle();
    expect(find.text('Log a transaction'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Test Bill');
    await tester.enterText(find.byType(TextField).at(1), '42.50');
    await tester.tap(find.text('Save Bill'));
    await tester.pumpAndSettle();

    expect(find.text('Test Bill added to bills.'), findsOneWidget);
    expect(find.text('Test Bill'), findsOneWidget);
  });

  testWidgets('logging income updates the income dashboard total', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(tab('Income'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log Income'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Retainer');
    await tester.enterText(find.byType(TextField).at(1), '92.50');
    await tester.tap(find.text('Save Income'));
    await tester.pumpAndSettle();

    expect(find.text('Retainer logged as income.'), findsOneWidget);
    expect(find.text('6,942.50'), findsOneWidget);
  });

  testWidgets('general add sheet can log either bills or income', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byTooltip('Add transaction'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AddEntrySheet),
        matching: find.text('Bill'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(AddEntrySheet),
        matching: find.text('Income'),
      ),
      findsOneWidget,
    );
    expect(find.text('Save Bill'), findsOneWidget);
  });

  testWidgets('income dashboard add sheet only accepts income', (tester) async {
    await pumpApp(tester);
    await tester.tap(tab('Income'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log Income'));
    await tester.pumpAndSettle();

    expect(find.text('Save Income'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AddEntrySheet),
        matching: find.text('Bill'),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byType(AddEntrySheet),
        matching: find.text('Income'),
      ),
      findsNothing,
    );
  });

  testWidgets('bills floating add button only accepts bills', (tester) async {
    await pumpApp(tester);
    await tester.tap(tab('Bills'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add transaction'));
    await tester.pumpAndSettle();

    expect(find.text('Save Bill'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AddEntrySheet),
        matching: find.text('Income'),
      ),
      findsNothing,
    );
  });

  testWidgets('income floating add button only accepts income', (tester) async {
    await pumpApp(tester);
    await tester.tap(tab('Income'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add transaction'));
    await tester.pumpAndSettle();

    expect(find.text('Save Income'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AddEntrySheet),
        matching: find.text('Bill'),
      ),
      findsNothing,
    );
  });

  testWidgets('floating add action stays available on every dashboard', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(find.byTooltip('Add transaction'), findsOneWidget);

    await tester.tap(tab('Bills'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Add transaction'), findsOneWidget);

    await tester.tap(tab('Income'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Add transaction'), findsOneWidget);

    await tester.tap(find.byTooltip('Add transaction'));
    await tester.pumpAndSettle();
    expect(find.text('Log a transaction'), findsOneWidget);
  });

  testWidgets('bottom navigation opens transactions, analytics and settings', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Analytics'));
    await tester.pumpAndSettle();
    expect(
      find.text('A six-month view of your money momentum.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('PREFERENCES'), findsOneWidget);

    await tester.tap(find.text('Transactions'));
    await tester.pumpAndSettle();
    expect(
      find.text('Every inflow and outflow in one ledger.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
    expect(find.text('NET CASH FLOW'), findsOneWidget);
  });
}
