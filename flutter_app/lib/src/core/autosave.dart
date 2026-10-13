import 'dart:async';

/// Runs [onElapsed] once [schedule] has not been called again for [delay].
///
/// The journal editor saves a few seconds after the writing pauses instead of
/// through a `Lưu nhật ký` button, so every keystroke restarts the wait and a
/// burst of typing collapses into a single save.
class AutosaveDebouncer {
  AutosaveDebouncer({required this.delay, required this.onElapsed});

  /// How long the caller has to stay quiet before the save runs.
  final Duration delay;

  /// Called once per quiet period.
  final void Function() onElapsed;

  Timer? _timer;

  /// Whether a save is waiting for the quiet period to end.
  bool get pending => _timer?.isActive ?? false;

  /// (Re)starts the wait: calling it again pushes the save further out.
  void schedule() {
    _timer?.cancel();
    _timer = Timer(delay, onElapsed);
  }

  /// Drops a waiting save, e.g. because one is about to run instead.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
