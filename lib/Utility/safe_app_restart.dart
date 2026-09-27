/// Wait for location persistence; restore tracking if preparation/restart fails.
Future<void> restartAfterLocationSaved({
  required Future<void> Function() prepare,
  required Future<void> Function() restart,
  required Future<void> Function() restore,
}) async {
  try {
    await prepare();
    await restart();
  } catch (_) {
    await restore();
    rethrow;
  }
}
