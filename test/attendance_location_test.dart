import 'dart:async';

import 'package:aeon_hrms/Utility/attendance_location.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Position fix(DateTime timestamp, {double accuracy = 10, bool mocked = false}) =>
    Position(
      latitude: 28.61,
      longitude: 77.20,
      timestamp: timestamp,
      accuracy: accuracy,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
      isMocked: mocked,
    );

void main() {
  test('rejects stale, future, coarse, invalid accuracy and mocked fixes', () {
    final now = DateTime.now();
    expect(AttendanceLocation.isUsable(fix(now), now), isTrue);
    for (final position in [
      fix(now.subtract(const Duration(seconds: 31))),
      fix(now.add(const Duration(seconds: 1))),
      fix(now, accuracy: 51),
      fix(now, accuracy: 0),
      fix(now, accuracy: double.nan),
      fix(now, mocked: true),
    ]) {
      expect(AttendanceLocation.isUsable(position, now), isFalse);
    }
  });

  test('waits past cached/coarse fixes and cancels after valid fix', () async {
    var cancelled = false;
    final stream = StreamController<Position>(onCancel: () => cancelled = true);
    final requested = DateTime.now().subtract(const Duration(seconds: 1));
    final result = AttendanceLocation.waitForFix(stream.stream, requested);
    stream.add(fix(requested.subtract(const Duration(seconds: 1))));
    stream.add(fix(DateTime.now(), accuracy: 500));
    final accurate = fix(DateTime.now());
    stream.add(accurate);
    expect(await result, same(accurate));
    expect(cancelled, isTrue);
    await stream.close();
  });

  test('GPS timeout cancels native stream subscription', () async {
    var cancelled = false;
    final stream = StreamController<Position>(onCancel: () => cancelled = true);
    await expectLater(
      AttendanceLocation.waitForFix(
        stream.stream,
        DateTime.now(),
        timeout: const Duration(milliseconds: 10),
      ),
      throwsA(isA<TimeoutException>()),
    );
    expect(cancelled, isTrue);
    await stream.close();
  });

  test('rejects empty or district-only addresses', () {
    expect(() => AttendanceLocation.formatAddress([]), throwsStateError);
    expect(
      () => AttendanceLocation.formatAddress([
        const Placemark(country: 'India', administrativeArea: 'Delhi'),
      ]),
      throwsStateError,
    );
  });

  test('handles absent fields and skips incomplete placemarks', () {
    expect(
      AttendanceLocation.formatAddress([
        const Placemark(country: 'India'),
        const Placemark(
          street: ' Main Road ',
          locality: 'Delhi',
          administrativeArea: 'Delhi',
          country: 'India',
        ),
      ]),
      'Main Road, Delhi, India',
    );
  });
}
