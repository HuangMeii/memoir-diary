// Reports how the local Figma exports (design/) map onto the design tokens.
//
// Every `VariableID` a frame references is resolved to its token path using the
// variable exports in design/, then:
//   - design/figma-tokens-report.md gets the per-frame token usage, and
//   - the console gets the summary plus the tokens still missing from tokens/.
//
// Run from the repository root:  dart run tool/figma_report.dart
import 'dart:convert';
import 'dart:io';

const String _design = 'design';
const String _tokens = 'tokens';

/// DTCG keywords that are metadata, not child token groups. `$root` is Figma's
/// name for a style's own font size, so it is handled as the node's value.
const Set<String> _keywords = {
  r'$schema',
  r'$value',
  r'$type',
  r'$description',
  r'$deprecated',
  r'$extensions',
  r'$root',
};

void _record(Map token, String path, Map<String, String> out) {
  final extensions = token[r'$extensions'];
  if (extensions is Map) {
    final id = extensions['com.figma.variableId'];
    if (id is String) out.putIfAbsent(id, () => path);
  }
}

/// Collects `VariableID -> dotted token path` from an exported token tree.
///
/// A style node keeps its font size in `$root`, which belongs to the style
/// itself (`type.body.meta`), not to a `$root` child.
void collectVariables(Object? node, String prefix, Map<String, String> out) {
  if (node is! Map) return;
  final root = node[r'$root'];
  if (root is Map) _record(root, prefix, out);
  if (node.containsKey(r'$value')) _record(node, prefix, out);
  for (final entry in node.entries) {
    final key = entry.key;
    if (key is! String || _keywords.contains(key)) continue;
    final child = entry.value;
    if (child is Map) {
      collectVariables(child, prefix.isEmpty ? key : '$prefix.$key', out);
    }
  }
}

/// Collects every dotted token path found under [node].
void collectPaths(Object? node, String prefix, Set<String> out) {
  if (node is! Map) return;
  for (final entry in node.entries) {
    final key = entry.key;
    if (key is! String || _keywords.contains(key)) continue;
    final child = entry.value;
    if (child is! Map) continue;
    final path = prefix.isEmpty ? key : '$prefix.$key';
    if (child.containsKey(r'$value') || child.containsKey(r'$root')) {
      out.add(path);
    }
    // A node may hold both its own value and child tokens (a type style has a
    // font size *and* a weight / line-height / letter-spacing).
    collectPaths(child, path, out);
  }
}

/// Every `VariableID` string referenced anywhere under [node].
void collectIds(Object? node, Set<String> out) {
  if (node is String) {
    if (node.startsWith('VariableID:')) out.add(node);
  } else if (node is List) {
    for (final item in node) {
      collectIds(item, out);
    }
  } else if (node is Map) {
    for (final value in node.values) {
      collectIds(value, out);
    }
  }
}

/// Token paths of a checked-in `tokens/` file, with its single wrapper key
/// ("Memoir · Foundation" / "Memoir · Colors") stripped so the paths line up
/// with the Figma exports.
Set<String> readTokenPaths(File file) {
  final out = <String>{};
  final json = jsonDecode(file.readAsStringSync());
  if (json is Map) {
    for (final entry in json.entries) {
      final key = entry.key;
      if (key is! String || key.startsWith(r'$')) continue;
      collectPaths(entry.value, '', out);
    }
  }
  return out;
}

void main() {
  // 1. Variable exports -> VariableID => token path.
  final variables = <String, String>{};
  final exports = <File>[
    File('$_design/figma-variables.json'),
    for (final entity in Directory(_design).listSync(recursive: true))
      if (entity is File && entity.path.endsWith('.tokens.json')) entity,
  ];
  for (final file in exports) {
    if (!file.existsSync()) continue;
    collectVariables(jsonDecode(file.readAsStringSync()), '', variables);
  }

  // 2. Checked-in tokens -> the paths the generator can actually emit.
  final checkedIn = <String>{};
  for (final entity in Directory(_tokens).listSync()) {
    if (entity is File && entity.path.endsWith('.tokens.json')) {
      checkedIn.addAll(readTokenPaths(entity));
    }
  }

  // 3. The design: tokens used by each top-level frame.
  final design =
      jsonDecode(File('$_design/figma-file.json').readAsStringSync()) as Map;
  final document = design['document'] as Map;

  // Every path the Figma exports define, for spotting stale checked-in tokens.
  final exportedAll = <String>{};
  for (final file in exports) {
    if (!file.existsSync()) continue;
    collectPaths(jsonDecode(file.readAsStringSync()), '', exportedAll);
  }
  final stale = checkedIn.difference(exportedAll).toList()..sort();

  final report = StringBuffer()
    ..writeln('# Figma → token report')
    ..writeln()
    ..writeln('- resolved variables: ${variables.length}')
    ..writeln('- checked-in token paths: ${checkedIn.length}')
    ..writeln();

  final usedIds = <String>{};
  var frames = 0;
  for (final page in (document['children'] as List).cast<Map>()) {
    for (final frame
        in (page['children'] as List? ?? const []).cast<Map>()) {
      frames++;
      final ids = <String>{};
      collectIds(frame, ids);
      usedIds.addAll(ids);
      final paths = ids
          .map((id) => variables[id] ?? 'UNRESOLVED $id')
          .toList()
        ..sort();
      report
        ..writeln('## ${frame['name']} (${frame['id']})')
        ..writeln()
        ..writeln('${paths.length} tokens')
        ..writeln()
        ..writeln('```text')
        ..writeln(paths.join('\n'))
        ..writeln('```')
        ..writeln();
    }
  }

  final unresolved =
      usedIds.where((id) => !variables.containsKey(id)).toList();
  final usedPaths =
      usedIds.map((id) => variables[id]).whereType<String>().toSet();
  final missing = usedPaths.difference(checkedIn).toList()..sort();

  File('$_design/figma-tokens-report.md').writeAsStringSync(report.toString());

  // `copy.*` holds UI wording rather than a design token, so it is counted
  // separately from the tokens that belong in tokens/.
  final byGroup = <String, int>{};
  for (final path in missing) {
    final group = path.split('.').first;
    byGroup[group] = (byGroup[group] ?? 0) + 1;
  }
  final groups = byGroup.keys.toList()..sort();

  stdout
    ..writeln('frames: $frames')
    ..writeln(
      'used VariableIDs: ${usedIds.length} (unresolved: ${unresolved.length})',
    )
    ..writeln('used token paths: ${usedPaths.length}')
    ..writeln('missing from tokens/: ${missing.length}');
  for (final group in groups) {
    stdout.writeln('  $group: ${byGroup[group]}');
  }

  stdout.writeln('checked-in paths not in Figma exports: ${stale.length}');
  for (final path in stale.take(40)) {
    stdout.writeln('  STALE $path');
  }

  stdout.writeln('--- missing design tokens (excluding copy.*) ---');
  for (final path in missing.where((p) => !p.startsWith('copy.'))) {
    stdout.writeln('  $path');
  }

  if (unresolved.isNotEmpty) {
    stdout.writeln('--- unresolved VariableIDs (${unresolved.length}) ---');
    for (final id in unresolved) {
      stdout.writeln('  $id');
    }
  }
}
