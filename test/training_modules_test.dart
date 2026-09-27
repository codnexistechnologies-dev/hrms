import 'package:aeon_hrms/Screens/Training Modules/view/training_modules_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('training library filters files and opens sample details', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TrainingModulesScreen()));
    expect(find.text('6 files • Newest first'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'PDF'));
    await tester.pumpAndSettle();
    expect(find.text('2 files • Newest first'), findsOneWidget);
    expect(find.text('23 Sep 2026'), findsOneWidget);
    expect(find.text('Field Visit Checklist'), findsNothing);
    await tester.tap(find.text('Product Knowledge Guide'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Sample file only.'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Sample file only.'), findsNothing);
  });

  testWidgets('empty training library displays an empty state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: TrainingModulesScreen(modules: [])),
    );
    expect(
      find.text('No training files found for this selection.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
