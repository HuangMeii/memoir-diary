// Rebuilds tokens/memoir-foundation.tokens.json from the Figma variable export
// (design/figma-variables.json) so the checked-in token source stays a faithful
// copy of the Figma foundation.
//
// Two normalisations are applied:
//   - Figma's `$root` (a style's own font size) becomes `size`, which is what it
//     actually is, and keeps every name valid DTCG;
//   - the `$extensions` metadata is dropped, matching the rest of tokens/.
//
// Run from the repository root:  dart run tool/import_figma_tokens.dart
import 'dart:convert';
import 'dart:io';

const String _source = 'design/figma-variables.json';
const String _target = 'tokens/memoir-foundation.tokens.json';
const String _wrapper = 'Memoir \u00b7 Foundation';
const String _schema = 'https://www.designtokens.org/schemas/2025.10/format.json';

/// Copies [node], dropping `$extensions` metadata.
///
/// Figma exports a style's own font size as `$root`; it is hoisted onto the
/// style object itself, so the generated name stays `type.body.meta` while the
/// style's other fields remain available as `type.body.meta.weight` and so on.
Object? _clean(Object? node) {
  if (node is List) return node.map(_clean).toList();
  if (node is! Map) return node;
  final out = <String, Object?>{};
  final root = node[r'$root'];
  if (root is Map) {
    out[r'$type'] = root[r'$type'];
    out[r'$value'] = root[r'$value'];
  }
  for (final entry in node.entries) {
    final key = entry.key;
    if (key == r'$extensions' || key == r'$root') continue;
    out['$key'] = _clean(entry.value);
  }
  return out;
}

void main() {
  final source = jsonDecode(File(_source).readAsStringSync()) as Map;
  final foundation = <String, Object?>{};
  for (final entry in source.entries) {
    final key = entry.key;
    if (key is String && key.startsWith(r'$')) continue;
    foundation['$key'] = _clean(entry.value);
  }

  final out = <String, Object?>{
    r'$schema': _schema,
    _wrapper: foundation,
  };
  const encoder = JsonEncoder.withIndent('  ');
  File(_target).writeAsStringSync('${encoder.convert(out)}\n');
  stdout.writeln('wrote $_target (${foundation.length} groups)');
}
