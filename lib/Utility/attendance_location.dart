import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Coordinates and their resolved address must always travel together.
class AttendanceLocation {
  const AttendanceLocation(this.position, this.address);

  final Position position;
  final String address;

  static const maxAge = Duration(seconds: 30);
  static const maxAccuracyMeters = 50.0;

  static Future<Position> waitForFix(
    Stream<Position> positions,
    DateTime requestedAt, {
    Duration timeout = const Duration(seconds: 25),
  }) async {
    final result = Completer<Position>();
    final timer = Timer(timeout, () {
      if (!result.isCompleted) {
        result.completeError(TimeoutException('No accurate fresh GPS fix'));
      }
    });
    final subscription = positions.listen(
      (position) {
        if (!result.isCompleted &&
            !position.timestamp.isBefore(requestedAt) &&
            isUsable(position, DateTime.now())) {
          result.complete(position);
        }
      },
      onError: (Object error, StackTrace stack) {
        if (!result.isCompleted) result.completeError(error, stack);
      },
      onDone: () {
        if (!result.isCompleted) {
          result.completeError(
            StateError('Location unavailable. Please retry.'),
          );
        }
      },
    );
    try {
      return await result.future;
    } finally {
      timer.cancel();
      await subscription.cancel();
    }
  }

  static bool isUsable(Position position, DateTime now) {
    final age = now.difference(position.timestamp);
    return position.latitude.isFinite &&
        position.longitude.isFinite &&
        position.latitude.abs() <= 90 &&
        position.longitude.abs() <= 180 &&
        position.accuracy.isFinite &&
        position.accuracy > 0 &&
        position.accuracy <= maxAccuracyMeters &&
        !position.isMocked &&
        !age.isNegative &&
        age <= maxAge;
  }

  static String formatAddress(List<Placemark> places) {
    // A country/district alone is not a usable current street/area address.
    for (final place in places) {
      final area = [
        place.street,
        place.thoroughfare,
        place.subLocality,
        place.locality,
      ].any((part) => part?.trim().isNotEmpty ?? false);
      if (!area) continue;
      final parts = <String>[];
      for (final part in [
        place.street,
        place.thoroughfare,
        place.subLocality,
        place.locality,
        place.subAdministrativeArea,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ]) {
        final value = part?.trim() ?? '';
        if (value.isNotEmpty &&
            !parts.any((p) => p.toLowerCase() == value.toLowerCase())) {
          parts.add(value);
        }
      }
      if (parts.isNotEmpty) return parts.join(', ');
    }
    throw StateError('Current address unavailable. Please retry.');
  }
}
