import 'dart:async';

import 'package:aeon_hrms/component/patch_update_notice.dart';
import 'package:aeon_hrms/Utility/patch_update_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

void main() {
  testWidgets(
    'download completion opens one mandatory sheet above the navigator',
    (tester) async {
      final download = Completer<void>();
      var status = UpdateStatus.outdated;
      final controller = PatchUpdateController(
        isAvailable: () => true,
        checkStatus: () async => status,
        download: () async {
          await download.future;
          status = UpdateStatus.restartRequired;
        },
      );
      final navigatorKey = GlobalKey<NavigatorState>();
      tester.binding.handleAppLifecycleStateChanged(
        AppLifecycleState.resumed,
      );
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          builder: (_, child) => PatchUpdateNotice(
            navigatorKey: navigatorKey,
            controller: controller,
            restart: () async {},
            child: child!,
          ),
          home: const Scaffold(body: Text('Home')),
        ),
      );
      await tester.pump();
      expect(find.text('New update available'), findsNothing);
      download.complete();
      await tester.pumpAndSettle();
      expect(find.text('New update available'), findsOneWidget);
      expect(find.text('Restart now'), findsOneWidget);
      expect(find.text('Later'), findsNothing);
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('New update available'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      controller.dispose();
    },
  );

  testWidgets('only restart is offered and back cannot dismiss the sheet', (
    tester,
  ) async {
    var restarts = 0;
    final pending = Completer<void>();
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isDismissible: false,
                    enableDrag: false,
                    builder: (_) => PatchRestartSheet(
                      onRestart: () {
                        restarts++;
                        return pending.future;
                      },
                    ),
                  );
                },
                child: const Text('Show'),
              ),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();
    expect(find.text('Later'), findsNothing);
    expect(find.text('Restart now'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('New update available'), findsOneWidget);
    await tester.tap(find.text('Restart now'));
    await tester.pump();
    expect(restarts, 1);
    expect(find.text('Restarting...'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    pending.complete();
    await tester.pumpAndSettle();
  });

  testWidgets(
    'restart failure allows retry instead of leaving a disabled button',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PatchRestartSheet(
              onRestart: () async => throw StateError('Unavailable'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Restart now'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Unable to restart automatically'),
        findsOneWidget,
      );
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
    },
  );
}
