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
      checkStatus: () => updater.checkForUpdate(track: UpdateTrack.stable),
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
    if (_disposed || _checking || !isAvailable()) return;
    final now = DateTime.now();
    if (!force &&
        _lastCheck != null &&
        now.difference(_lastCheck!) < const Duration(minutes: 1)) {
      return;
    }
    _lastCheck = now;
    _checking = true;
    try {
      var status = await checkStatus();
      if (_disposed) return;
      if (status == UpdateStatus.outdated) {
        await download();
        if (_disposed) return;
        // Another automatic check may have downloaded the patch concurrently.
        // Confirm that a restart is needed rather than assuming update applied.
        status = await checkStatus();
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
