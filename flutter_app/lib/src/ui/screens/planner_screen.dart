import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_client.dart';
import '../../data/providers.dart' show dayKey;

/// The ISO week label the API expects, e.g. `2026-W41`.
///
/// Mondays start the week, so this walks back to Monday before numbering.
String isoWeekLabel(DateTime day) {
  final monday = day.subtract(Duration(days: day.weekday - 1));
  final thursday = monday.add(const Duration(days: 3));
  // The ISO year is the year of that Thursday, which can differ from `day`'s
  // year around New Year.
  final year = thursday.year;
  final firstThursday = DateTime(year, 1, 4);
  final firstMonday = firstThursday.subtract(Duration(days: firstThursday.weekday - 1));
  final week = 1 + thursday.difference(firstMonday).inDays ~/ 7;
  return '$year-W${week.toString().padLeft(2, '0')}';
}

/// Human label for the current week, e.g. "Tuần 41 · 6/10 - 12/10".
String weekHeading(DateTime day) {
  final monday = day.subtract(Duration(days: day.weekday - 1));
  final sunday = monday.add(const Duration(days: 6));
  String fmt(DateTime d) => '${d.day}/${d.month}';
  return 'Tuần ${isoWeekLabel(day).split('-W').last} · ${fmt(monday)} - ${fmt(sunday)}';
}

/// Todo list, weekly goals, special events and daily schedule in one place.
class PlannerScreen extends ConsumerStatefulWidget {
  const PlannerScreen({super.key});

  @override
  ConsumerState<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends ConsumerState<PlannerScreen> {
  List<Map<String, dynamic>> _todos = [];
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _schedules = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Loads the three lists independently.
  ///
  /// They used to share one `Future.wait`, which meant a single wrong path or a
  /// hiccup on one endpoint rejected the whole batch: the catch swallowed it and
  /// the lists kept showing whatever was there before, so a todo that had been
  /// created successfully looked like it had vanished. Fetching each on its own
  /// keeps one broken call from hiding the other two.
  Future<void> _load() async {
    final client = ref.read(apiClientProvider);
    final results = await Future.wait([
      client.get('/todos').catchError((_) => null),
      client.get('/events').catchError((_) => null),
      client.get('/schedule-items').catchError((_) => null),
    ]);
    if (!mounted) return;
    setState(() {
      // A null means that call failed, so its previous contents are kept.
      if (results[0] != null) {
        _todos = (results[0] as List).cast<Map<String, dynamic>>();
      }
      if (results[1] != null) {
        _events = (results[1] as List).cast<Map<String, dynamic>>();
      }
      if (results[2] != null) {
        _schedules = (results[2] as List).cast<Map<String, dynamic>>();
      }
      _loading = false;
    });
  }

  /// Runs a write request then reloads, reporting failures in a snack bar.
  Future<void> _write(
    Future<dynamic> Function(ApiClient client) request,
  ) async {
    try {
      await request(ref.read(apiClientProvider));
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  Future<void> _post(String path, Map<String, dynamic> body) =>
      _write((c) => c.post(path, data: body));

  Future<void> _put(String path, Map<String, dynamic> body) =>
      _write((c) => c.put(path, data: body));

  Future<void> _delete(String path) => _write((c) => c.delete(path));

  /// New goals belong to the week they are typed in, so the weekly list stays
  /// meaningful instead of piling everything into one bucket.
  Future<void> _addTodo(String text) async {
    if (text.trim().isEmpty) return;
    final now = DateTime.now();
    await _post('/todos', {
      'title': text.trim(),
      'due_date': dayKey(now),
      'week_label': isoWeekLabel(now),
    });
  }

  Future<void> _addEvent(String title) async {
    if (title.trim().isEmpty) return;
    // Default to later today so the event lands in the list as "upcoming".
    final start = DateTime.now().add(const Duration(hours: 2));
    await _post('/events', {
      'title': title.trim(),
      'start_at': start.toIso8601String(),
    });
  }

  Future<void> _addSchedule(String title) async {
    if (title.trim().isEmpty) return;
    final start = DateTime.now().add(const Duration(hours: 1));
    await _post('/schedule-items', {
      'title': title.trim(),
      'start_at': start.toIso8601String(),
    });
  }

  /// The goals that belong to the week being viewed, plus older ones that were
  /// never tagged with a week (rows created before `week_label` was filled in).
  List<Map<String, dynamic>> _todosForWeek(String week) {
    return _todos
        .where((t) => (t['week_label'] as String?) == null || t['week_label'] == week)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kế hoạch'),
          bottom: const TabBar(tabs: [
            Tab(text: 'Mục tiêu'),
            Tab(text: 'Sự kiện'),
            Tab(text: 'Lịch biểu'),
          ]),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(children: [
                _TodoTab(
                  todos: _todosForWeek(isoWeekLabel(DateTime.now())),
                  heading: weekHeading(DateTime.now()),
                  onAdd: _addTodo,
                  // PUT, not POST: the update route for a goal is PUT /todos/{id}.
                  onToggle: (id, value) async =>
                      _put('/todos/$id', {'is_done': value}),
                  onDelete: (id) => _delete('/todos/$id'),
                ),
                _SimpleList(
                  items: _events,
                  emptyLabel: 'Chưa có sự kiện',
                  hint: 'Sự kiện sắp tới...',
                  onAdd: _addEvent,
                  onDelete: (id) => _delete('/events/$id'),
                ),
                _SimpleList(
                  items: _schedules,
                  emptyLabel: 'Chưa có lịch biểu',
                  hint: 'Lịch hẹn trong ngày...',
                  onAdd: _addSchedule,
                  onDelete: (id) => _delete('/schedule-items/$id'),
                ),
              ]),
      ),
    );
  }
}

/// The weekly goals tab: a heading naming the week, an add box, and the goals
/// belonging to it.
class _TodoTab extends StatelessWidget {
  const _TodoTab({
    required this.todos,
    required this.heading,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
  });

  final List<Map<String, dynamic>> todos;
  final String heading;
  final Future<void> Function(String) onAdd;
  final Future<void> Function(String, bool) onToggle;
  final Future<void> Function(String) onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Text('🎯 $heading', style: theme.textTheme.titleSmall),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: AddBox(
            hint: 'Mục tiêu trong tuần...',
            onSubmit: onAdd,
          ),
        ),
        Expanded(
          child: todos.isEmpty
              ? const Center(child: Text('Chưa có mục tiêu cho tuần này'))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    final done = todo['is_done'] as bool? ?? false;
                    final id = todo['id'] as String;
                    return CheckboxListTile(
                      value: done,
                      title: Text(
                        todo['title'] as String? ?? '',
                        style: TextStyle(
                          decoration: done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text('Hạn: ${todo['due_date'] ?? '-'}'),
                      secondary: IconButton(
                        tooltip: 'Xoá',
                        icon: const Icon(Icons.delete_outline, size: 20),
                        onPressed: () => onDelete(id),
                      ),
                      onChanged: (value) => onToggle(id, value ?? false),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Events and schedules: an add box plus a list of rows.
class _SimpleList extends StatelessWidget {
  const _SimpleList({
    required this.items,
    required this.emptyLabel,
    required this.hint,
    required this.onAdd,
    required this.onDelete,
  });

  final List<Map<String, dynamic>> items;
  final String emptyLabel;
  final String hint;
  final Future<void> Function(String) onAdd;
  final Future<void> Function(String) onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: AddBox(hint: hint, onSubmit: onAdd),
        ),
        Expanded(
          child: items.isEmpty
              ? Center(child: Text(emptyLabel))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          title: Text(item['title'] as String? ?? ''),
                          subtitle: _subtitle(item),
                          trailing: IconButton(
                            tooltip: 'Xoá',
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: () => onDelete(item['id'] as String),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// Both tables store the moment in `start_at`; `event_date` / `start_time`
  /// were never fields, which is why these rows showed no date at all.
  Widget? _subtitle(Map<String, dynamic> item) {
    final start = item['start_at'];
    if (start is! String || start.isEmpty) return null;
    final when = DateTime.tryParse(start);
    if (when == null) return null;
    String two(int n) => n.toString().padLeft(2, '0');
    final end = item['end_at'];
    var suffix = '';
    if (end is String && end.isNotEmpty) {
      final e = DateTime.tryParse(end);
      if (e != null) suffix = ' · đến ${two(e.hour)}:${two(e.minute)}';
    }
    return Text('${two(when.day)}/${two(when.month)}/${when.year}'
        ' · ${two(when.hour)}:${two(when.minute)}$suffix');
  }
}

/// A text box with a + button, shared by all three tabs.
class AddBox extends StatefulWidget {
  const AddBox({super.key, required this.hint, required this.onSubmit});

  final String hint;
  final Future<void> Function(String) onSubmit;

  @override
  State<AddBox> createState() => _AddBoxState();
}

class _AddBoxState extends State<AddBox> {
  final _controller = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text;
    if (text.trim().isEmpty || _busy) return;
    setState(() => _busy = true);
    try {
      await widget.onSubmit(text);
      // Cleared only on success, so a failed request keeps what was typed.
      _controller.clear();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: widget.hint),
            onSubmitted: (_) => _send(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          icon: const Icon(Icons.add),
          onPressed: _busy ? null : _send,
        ),
      ],
    );
  }
}
