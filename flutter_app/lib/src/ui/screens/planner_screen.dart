import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_client.dart';

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

  Future<void> _load() async {
    try {
      final client = ref.read(apiClientProvider);
      final results = await Future.wait([
        client.get('/todos'),
        client.get('/events'),
        client.get('/schedules'),
      ]);
      setState(() {
        _todos = (results[0] as List).cast<Map<String, dynamic>>();
        _events = (results[1] as List).cast<Map<String, dynamic>>();
        _schedules = (results[2] as List).cast<Map<String, dynamic>>();
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addTodo(String text) async {
    if (text.trim().isEmpty) return;
    try {
      await ref.read(apiClientProvider).post('/todos', data: {
        'title': text.trim(),
        'due_date':
            DateTime.now().toIso8601String().substring(0, 10),
      });
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    }
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
                  todos: _todos,
                  onAdd: _addTodo,
                  onChanged: _load,
                ),
                _SimpleList(items: _events, emptyLabel: 'Chưa có sự kiện'),
                _SimpleList(
                  items: _schedules,
                  emptyLabel: 'Chưa có lịch biểu',
                  leadingKey: 'start_time',
                ),
              ]),
      ),
    );
  }
}
class _TodoTab extends ConsumerWidget {
  const _TodoTab({
    required this.todos,
    required this.onAdd,
    required this.onChanged,
  });

  final List<Map<String, dynamic>> todos;
  final Future<void> Function(String) onAdd;
  final Future<void> Function() onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Mục tiêu trong tuần...',
                  ),
                  onSubmitted: (v) async {
                    await onAdd(v);
                    controller.clear();
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  await onAdd(controller.text);
                  controller.clear();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: todos.isEmpty
              ? const Center(child: Text('Chưa có mục tiêu'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    final done = todo['is_done'] as bool? ?? false;
                    return CheckboxListTile(
                      value: done,
                      title: Text(
                        todo['title'] as String? ?? '',
                        style: TextStyle(
                          decoration: done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text('Hạn: ${todo['due_date'] ?? '-'}'),
                      onChanged: (value) async {
                        await ref
                            .read(apiClientProvider)
                            .put('/todos/${todo['id']}', data: {
                              'is_done': value,
                            });
                        await onChanged();
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _SimpleList extends StatelessWidget {
  const _SimpleList({
    required this.items,
    required this.emptyLabel,
    this.leadingKey,
  });

  final List<Map<String, dynamic>> items;
  final String emptyLabel;
  final String? leadingKey;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return Center(child: Text(emptyLabel));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final title =
            item['title'] as String? ?? item['event_date']?.toString() ?? '';
        final subtitle = leadingKey != null
            ? '${item[leadingKey] ?? ''}'
            : '${item['event_date'] ?? ''}';
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(title: Text(title), subtitle: Text(subtitle)),
        );
      },
    );
  }
}