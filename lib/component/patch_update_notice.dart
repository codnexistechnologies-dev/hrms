import 'dart:async';
import 'dart:io';

import 'package:aeon_hrms/Utility/patch_update_controller.dart';
import 'package:aeon_hrms/Utility/safe_app_restart.dart';
import 'package:aeon_hrms/background_service/background_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PatchUpdateNotice extends StatefulWidget {
  const PatchUpdateNotice({
    required this.child,
    required this.navigatorKey,
    this.controller,
    this.restart,
    super.key,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  final PatchUpdateController? controller;
  final Future<void> Function()? restart;

  @override
  State<PatchUpdateNotice> createState() => _PatchUpdateNoticeState();
}

class _PatchUpdateNoticeState extends State<PatchUpdateNotice>
    with WidgetsBindingObserver {
  late final PatchUpdateController _updates;
  Timer? _timer;
  Timer? _promptRetry;
  bool _sheetOpen = false;
  bool _prompted = false;

  @override
  void initState() {
    super.initState();
    _updates = widget.controller ?? PatchUpdateController.production();
    _updates.addListener(_onUpdate);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_check());
    });
    _timer = Timer.periodic(const Duration(minutes: 15), (_) {
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        unawaited(_check());
      }
    });
  }

  Future<void> _check() async {
    // The native restart bridge currently targets this project's Android app.
    if (widget.controller == null && !Platform.isAndroid) return;
    await _updates.check();
    if (mounted) _onUpdate();
  }

  void _onUpdate() {
    if (!mounted) return;
    if (!_updates.restartRequired) {
      _prompted = false;
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          !_prompted &&
          WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        unawaited(_showUpdate());
      }
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  Future<void> _restart() async {
    // Recheck before restarting: a server rollback may have removed the patch.
    await _updates.check(force: true);
    if (!_updates.restartRequired) {
      throw StateError('Update is no longer pending');
    }
    if (widget.restart != null) return widget.restart!();
    if (!Platform.isAndroid) {
      throw UnsupportedError(
        'Close the app completely and reopen it to update.',
      );
    }
    await restartAfterLocationSaved(
      prepare: prepareLocationForPatchRestart,
      restart: () async {
        await const MethodChannel('com.app.nia_hrms/app_restart')
            .invokeMethod<void>('restart');
      },
      restore: resumeLocationAfterFailedRestart,
    );
  }

  Future<void> _showUpdate() async {
    final sheetContext = widget.navigatorKey.currentState?.overlay?.context;
    if (_sheetOpen || !_updates.restartRequired || sheetContext == null) return;
    _sheetOpen = true;
    _prompted = true;
    try {
      await showModalBottomSheet<void>(
        context: sheetContext,
        useRootNavigator: true,
        isScrollControlled: true,
        useSafeArea: true,
        isDismissible: false,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => PatchRestartSheet(onRestart: _restart),
      );
    } finally {
      _sheetOpen = false;
      // A login/splash route replacement can remove even a non-dismissible
      // modal. Re-present it on the new route if the update is still pending.
      _prompted = false;
      if (mounted && _updates.restartRequired) {
        _promptRetry?.cancel();
        _promptRetry = Timer(const Duration(seconds: 2), _onUpdate);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_check());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _promptRetry?.cancel();
    _updates.removeListener(_onUpdate);
    if (widget.controller == null) _updates.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class PatchRestartSheet extends StatefulWidget {
  const PatchRestartSheet({required this.onRestart, super.key});

  final Future<void> Function() onRestart;

  @override
  State<PatchRestartSheet> createState() => _PatchRestartSheetState();
}

class _PatchRestartSheetState extends State<PatchRestartSheet> {
  bool _restarting = false;
  String? _error;

  Future<void> _restart() async {
    if (_restarting) return;
    setState(() {
      _restarting = true;
      _error = null;
    });
    try {
      await widget.onRestart();
    } catch (error) {
      debugPrint('[App update] Restart failed: $error');
      if (mounted) {
        setState(() {
          _restarting = false;
          _error =
              'Unable to restart automatically and safely. Please try again. '
              'If this continues, contact support.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    child: SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'New update available',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            const Text(
              'Your update has been downloaded. Restart the app to '
              'start using the latest changes.',
            ),
            const SizedBox(height: 8),
            const Text(
              'Save any unfinished work first. Location tracking '
              'will briefly pause while the app restarts.',
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _restarting ? null : _restart,
              child: Text(_restarting ? 'Restarting...' : 'Restart now'),
            ),
          ],
        ),
      ),
    ),
  );
}
