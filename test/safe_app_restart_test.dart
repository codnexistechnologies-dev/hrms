import 'dart:async';

import 'package:aeon_hrms/Utility/safe_app_restart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('native restart waits for pending location persistence', () async {
    final saved = Completer<void>();
    var restarted = false;
    final operation = restartAfterLocationSaved(
      prepare: () => saved.future,
      restart: () async => restarted = true,
      restore: () async => fail('No recovery needed'),
    );
    await Future<void>.delayed(Duration.zero);
    expect(restarted, isFalse);
    saved.complete();
    await operation;
    expect(restarted, isTrue);
  });

  test(
    'failed location preparation aborts restart and restores tracking',
    () async {
      var restored = false;
      await expectLater(
        restartAfterLocationSaved(
          prepare: () async =>
              throw TimeoutException('No service acknowledgment'),
          restart: () async =>
              fail('Must not kill process before location is safe'),
          restore: () async => restored = true,
        ),
        throwsA(isA<TimeoutException>()),
      );
      expect(restored, isTrue);
    },
  );

  test(
    'native restart failure restores tracking before returning the error',
    () async {
      final events = <String>[];
      await expectLater(
        restartAfterLocationSaved(
          prepare: () async => events.add('saved'),
          restart: () async {
            events.add('restart');
            throw StateError('Native bridge unavailable');
          },
          restore: () async => events.add('resumed'),
        ),
        throwsStateError,
      );
      expect(events, ['saved', 'restart', 'resumed']);
    },
  );
}
