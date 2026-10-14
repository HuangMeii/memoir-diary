// Preview helper, not part of the test suite: it renders the Figma journey
// export (the biggest SVG in ui-figma/) to a PNG so the layout can be compared
// with the app screen. The export folder is git-ignored, so run it on demand:
//
//   cd flutter_app
//   flutter test tool/journey_svg_preview.dart
//
// Optional overrides: MEMOIR_SVG_PATH (input .svg) and MEMOIR_PREVIEW_OUT
// (output .png). Keeping the helper outside test/ leaves the default
// `flutter test` run independent of the local Figma export.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

/// Frame size of the journey export, in SVG units.
const double _frameWidth = 1284.0;
const double _frameHeight = 2457.0;

/// The render is only a preview, so the frame is scaled down to stay small.
const double _previewScale = 0.55;

void main() {
  final svg = _journeyExport();

  testWidgets(
    svg == null
        ? 'journey svg preview (skipped: no export - set MEMOIR_SVG_PATH)'
        : 'journey svg preview',
    skip: svg == null,
    (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RepaintBoundary(
                key: key,
                child: SizedBox(
                  width: _frameWidth * _previewScale,
                  height: _frameHeight * _previewScale,
                  child: SvgPicture.string(
                    svg!.readAsStringSync(),
                    width: _frameWidth,
                    height: _frameHeight,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 1);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final out = File(_previewOutputPath())
        ..writeAsBytesSync(bytes!.buffer.asUint8List());
      // ignore: avoid_print
      print('PREVIEW ${out.path} (${bytes.lengthInBytes} bytes)');
    },
  );
}

/// Returns the SVG to render, or null when the git-ignored export is absent.
///
/// The journey frame is the biggest SVG in `ui-figma/`; matching by size keeps
/// the Vietnamese file name out of the source.
File? _journeyExport() {
  final configured = Platform.environment['MEMOIR_SVG_PATH'];
  if (configured != null && configured.isNotEmpty) {
    final file = File(configured);
    return file.existsSync() ? file : null;
  }

  for (final dir in _exportDirs()) {
    if (!dir.existsSync()) continue;
    final svgs = dir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.toLowerCase().endsWith('.svg'))
        .toList()
      ..sort((a, b) => b.lengthSync().compareTo(a.lengthSync()));
    if (svgs.isNotEmpty) return svgs.first;
  }
  return null;
}

/// `flutter test` starts in the package root, so `ui-figma/` sits one level up;
/// the walk also covers starting from the repository root.
Iterable<Directory> _exportDirs() sync* {
  var dir = Directory.current.absolute;
  for (var depth = 0; depth < 4; depth++) {
    yield Directory('${dir.path}${Platform.pathSeparator}ui-figma');
    final parent = dir.parent;
    if (parent.path == dir.path) return;
    dir = parent;
  }
}

String _previewOutputPath() {
  final configured = Platform.environment['MEMOIR_PREVIEW_OUT'];
  if (configured != null && configured.isNotEmpty) return configured;
  return '${Directory.systemTemp.path}${Platform.pathSeparator}journey-full.png';
}
