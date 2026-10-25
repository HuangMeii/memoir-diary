import 'package:flutter/material.dart';

import '../theme.dart';
import '../tokens.dart';

/// From this width up the health secondary forms are shown as centred dialogs.
const double kHealthModalBreakpoint = 700;

/// Key of the centred panel, so tests can measure the form itself instead of
/// the full-screen route used to lay it out.
const Key healthModalPanelKey = ValueKey<String>('health-modal-panel');

/// Presents a secondary health form the way the app presents its other modal
/// forms: a bottom sheet on phones and a centred dialog on wide windows.
///
/// A bottom sheet is anchored to the lower edge, so on a desktop window the
/// "Thông số" and "Ghi nhận nhanh" forms hung at the bottom under a large empty
/// area and read as off-centre. From [kHealthModalBreakpoint] up they use the
/// same centred, size-bounded panel as the note editor dialog in
/// `notes_screen.dart`.
Future<T?> showHealthModal<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  double maxWidth = 560,
  double heightFactor = 0.86,
}) {
  final size = MediaQuery.sizeOf(context);
  if (size.width < kHealthModalBreakpoint) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: builder,
    );
  }
  final palette = MemoirPalette.of(context);
  return showDialog<T>(
    context: context,
    barrierColor: const Color(0x59000000),
    builder: (dialogContext) => Dialog(
      backgroundColor: palette.surfaceCard,
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.all(MemoirSpace.s6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MemoirRadius.card),
      ),
      child: ConstrainedBox(
        key: healthModalPanelKey,
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: size.height * heightFactor,
        ),
        child: builder(dialogContext),
      ),
    ),
  );
}
