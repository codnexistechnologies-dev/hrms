import 'dart:async';

import 'package:aeon_hrms/Utility/patch_update_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

void main() {
  test('debug/unavailable builds never check or download', () async {
    final controller = PatchUpdateController(
      isAvailable: () => false,
      checkStatus: () => throw StateError('Must not check'),
      download: () => throw StateError('Must not download'),
    );
    await controller.check();
    expect(controller.restartRequired, isFalse);
    controller.dispose();
  });

  test(
    'downloads before reporting restart and handles a later rollback',
    () async {
      var status = UpdateStatus.outdated;
      var downloads = 0;
      final controller = PatchUpdateController(
        isAvailable: () => true,
        checkStatus: () async => status,
        download: () async {
          downloads++;
          status = UpdateStatus.restartRequired;
        },
      );
      await controller.check();
      expect(downloads, 1);
      expect(controller.restartRequired, isTrue);
      status = UpdateStatus.upToDate;
      await controller.check(force: true);
      expect(controller.restartRequired, isFalse);
      controller.dispose();
    },
  );

  test(
    'concurrent checks do not duplicate downloads; offline retry works',
    () async {
      final pending = Completer<UpdateStatus>();
      var checks = 0;
      final controller = PatchUpdateController(
        isAvailable: () => true,
        checkStatus: () {
          checks++;
          return checks == 1
              ? pending.future
              : Future.value(UpdateStatus.restartRequired);
        },
        download: () async {},
      );
      final first = controller.check();
      await controller.check(force: true);
      expect(checks, 1);
      pending.completeError(StateError('Offline'));
      await first;
      expect(controller.restartRequired, isFalse);
      await controller.check(force: true);
      expect(controller.restartRequired, isTrue);
      controller.dispose();
    },
  );

  test(
    'finishing after disposal does not notify or start a download',
    () async {
      final pending = Completer<UpdateStatus>();
      final controller = PatchUpdateController(
        isAvailable: () => true,
        checkStatus: () => pending.future,
        download: () => throw StateError('Must not download after disposal'),
      );
      final check = controller.check();
      controller.dispose();
      pending.complete(UpdateStatus.outdated);
      await check;
    },
  );
}
