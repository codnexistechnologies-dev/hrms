import 'package:flutter/foundation.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

/// Checks without blocking navigation or interrupting attendance tracking.
class PatchUpdateController extends ChangeNotifier {
  PatchUpdateController({
    required this.isAvailable,
    required this.checkStatus,
    required this.download,
  });

  factory PatchUpdateController.production() {
    final updater = ShorebirdUpdater();
    return PatchUpdateController(
      isAvailable: () => updater.isAvailable,
      checkStatus: () async {
        // A staged patch can be detected offline, including one downloaded by
        // Shorebird's automatic updater after our previous check completed.
        final current = await updater.readCurrentPatch();
        final next = await updater.readNextPatch();
        if (current?.number != next?.number) {
          return UpdateStatus.restartRequired;
        }
        return updater.checkForUpdate(track: UpdateTrack.stable);
      },
      download: () => updater.update(track: UpdateTrack.stable),
    );
  }

  final bool Function() isAvailable;
  final Future<UpdateStatus> Function() checkStatus;
  final Future<void> Function() download;
  bool restartRequired = false;
  bool _checking = false;
  bool _disposed = false;
  DateTime? _lastCheck;

  Future<void> check({bool force = false}) async {
    if (_disposed || _checking) return;
    if (!isAvailable()) {
      debugPrint(
        '[App update] Shorebird unavailable. Install a Shorebird '
        'release build; ordinary Flutter/debug builds cannot receive patches.',
      );
      return;
    }
    final now = DateTime.now();
    if (!force &&
        _lastCheck != null &&
        now.difference(_lastCheck!) < const Duration(seconds: 10)) {
      return;
    }
    _lastCheck = now;
    _checking = true;
    try {
      var status = await checkStatus();
      debugPrint('[App update] Status: $status');
      if (_disposed) return;
      if (status == UpdateStatus.outdated) {
        await download();
        if (_disposed) return;
        // Another automatic check may have downloaded the patch concurrently.
        // Confirm that a restart is needed rather than assuming update applied.
        status = await checkStatus();
        debugPrint('[App update] Status after download: $status');
      }
      if (_disposed) return;
      final ready = status == UpdateStatus.restartRequired;
      if (restartRequired != ready) {
        restartRequired = ready;
        notifyListeners();
      }
    } catch (error) {
      // Offline/update failures must not block HRMS. Retry on resume/timer.
      debugPrint('[App update] Check/download failed: $error');
    } finally {
      _checking = false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
