// Dumps one Figma frame from design/figma-file.json as an indented spec: node
// name, type, geometry, text content and the design tokens bound to each node.
//
// Usage (from the repository root):
//   dart run tool/figma_frame.dart 35:19598        # by node id
//   dart run tool/figma_frame.dart "HOME-01"       # by name (substring)
import 'dart:convert';
import 'dart:io';

import 'figma_report.dart';

const String _design = 'design';

/// `VariableID -> token path` for every variable export in design/.
Map<String, String> loadVariables() {
  final variables = <String, String>{};
  final files = <File>[
    File('$_design/figma-variables.json'),
    for (final entity in Directory(_design).listSync(recursive: true))
      if (entity is File && entity.path.endsWith('.tokens.json')) entity,
  ];
  for (final file in files) {
    if (!file.existsSync()) continue;
    collectVariables(jsonDecode(file.readAsStringSync()), '', variables);
  }
  return variables;
}

/// The document's top-level frames.
List<Map> topLevelFrames(Map document) {
  final frames = <Map>[];
  for (final page in (document['children'] as List? ?? const []).cast<Map>()) {
    frames.addAll((page['children'] as List? ?? const []).cast<Map>());
  }
  return frames;
}

String _box(Map node) {
  final box = node['absoluteBoundingBox'];
  if (box is! Map) return '';
  final width = box['width'];
  final height = box['height'];
  if (width is! num || height is! num) return '';
  return '${width.round()}x${height.round()}';
}

void _dump(
  Map node,
  String indent,
  Map<String, String> variables,
  StringBuffer out,
) {
  final children =
      (node['children'] as List? ?? const []).cast<Map>().toList();
  final text = node['characters'];
  out.writeln(
    '$indent${node['name']} [${node['type']}] ${_box(node)}'
    '${text is String ? ' "${text.replaceAll('\n', ' / ')}"' : ''}',
  );
  // Only leaves carry the node's own styling; parents would repeat the subtree.
  if (children.isEmpty) {
    final ids = <String>{};
    collectIds(node['boundVariables'], ids);
    for (final paint in [
      ...(node['fills'] as List? ?? const []),
      ...(node['strokes'] as List? ?? const []),
    ]) {
      if (paint is Map) collectIds(paint['boundVariables'], ids);
    }
    final tokens = ids
        .map((id) => variables[id])
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();
    if (tokens.isNotEmpty) out.writeln('$indent  → ${tokens.join(', ')}');
  }
  for (final child in children) {
    _dump(child, '$indent  ', variables, out);
  }
}

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('usage: dart run tool/figma_frame.dart <node-id|name>');
    exit(64);
  }
  final needle = args.first;
  final variables = loadVariables();
  final document =
      (jsonDecode(File('$_design/figma-file.json').readAsStringSync())
          as Map)['document'];
  var found = 0;
  for (final frame in topLevelFrames(document as Map)) {
    final id = '${frame['id']}';
    final name = '${frame['name']}';
    if (id != needle && !name.contains(needle)) continue;
    found++;
    final out = StringBuffer();
    _dump(frame, '', variables, out);
    stdout
      ..writeln('===== $name ($id) =====')
      ..write(out)
      ..writeln();
  }
  if (found == 0) stderr.writeln('no frame matched "$needle"');
}
