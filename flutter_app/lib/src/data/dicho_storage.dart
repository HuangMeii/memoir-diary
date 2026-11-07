/// Local persistence for the "Đi chợ thông minh" baskets.
///
/// Nothing goes to the database. The screen state is written as a CSV document
/// ([dichoShoppingToCsv]) into `shared_preferences` — `localStorage` on web, the
/// native preferences on mobile/desktop — and read back on the next visit.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dicho_csv.dart';
import 'dicho_shopping.dart';

/// Key of the stored document, versioned so a format change can migrate.
const String kDichoStorageKey = 'dicho.shopping.csv.v1';

/// Reads and writes the basket document on the device.
class DichoStorage {
  const DichoStorage();

  /// The saved basket, or null when this device has none (or it is unreadable).
  Future<DichoState?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final document = prefs.getString(kDichoStorageKey);
    if (document == null || document.isEmpty) return null;
    return dichoShoppingFromCsv(document);
  }

  Future<void> save(DichoState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kDichoStorageKey, dichoShoppingToCsv(state));
  }

  /// Forgets the device's basket; the screen falls back to the seeded one.
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kDichoStorageKey);
  }
}

/// Swappable in tests; the app always writes to the device.
final dichoStorageProvider =
    Provider<DichoStorage>((ref) => const DichoStorage());

/// Writes basket edits to the device, debounced, and reads the saved basket
/// once when the screen opens.
///
/// Pure storage: the notifier reports its edits through
/// `DichoNotifier.onChanged`, so there is no listener plumbing here and the
/// class is easy to drive from a test.
class DichoSync {
  DichoSync({required DichoStorage storage}) : _storage = storage;

  /// Quiet period before a change is written.
  static const Duration debounce = Duration(milliseconds: 250);

  final DichoStorage _storage;
  Timer? _timer;
  bool _restored = false;
  bool _editedBeforeRestore = false;
  DichoState? _latest;

  /// True when the shopper edited the basket before the device answered: the
  /// stored copy is stale then and must not overwrite the screen.
  bool get editedBeforeRestore => _editedBeforeRestore;

  /// Reads the saved basket; answers null when the device has none (or the
  /// document is unreadable).
  Future<DichoState?> restore() async {
    final saved = await _storage.load();
    _restored = true;
    // An edit made while the read was in flight is newer than the stored copy:
    // it wins, and it still has to reach the device.
    if (_editedBeforeRestore) _write();
    return saved;
  }

  /// Called by the notifier after every edit.
  void changed(DichoState state) {
    _latest = state;
    if (!_restored) {
      _editedBeforeRestore = true;
      return;
    }
    _timer?.cancel();
    _timer = Timer(debounce, _write);
  }

  /// Writes the basket now (app pause, tests).
  Future<void> flush() async {
    _timer?.cancel();
    final state = _latest;
    if (state == null || !_restored) return;
    await _storage.save(state);
  }

  void dispose() {
    _timer?.cancel();
    final state = _latest;
    if (state != null && _restored) unawaited(_storage.save(state));
  }

  void _write() {
    final state = _latest;
    if (state == null) return;
    unawaited(_storage.save(state));
  }
}

/// The one source of truth for the "Đi chợ thông minh" screen: restored from
/// the device and written back as the shopper edits.
final dichoProvider = StateNotifierProvider<DichoNotifier, DichoState>((ref) {
  final sync = DichoSync(storage: ref.watch(dichoStorageProvider));
  final notifier = DichoNotifier(onChanged: sync.changed);
  ref.onDispose(sync.dispose);

  // One-shot restore: a saved basket replaces the seeded one, unless the
  // shopper already edited something while the read was in flight.
  unawaited(sync.restore().then((saved) {
    if (saved == null || sync.editedBeforeRestore) return;
    notifier.restore(saved);
  }));

  return notifier;
});
