import 'package:flutter/material.dart';

import '../tokens.dart';
import 'home_scale.dart';

/// Width of the main column in the Figma `HOME-01 · Web` frames.
const double kMainColumnWidth = 700;

/// Width of the secondary column (journal prompt + shortcuts).
const double kSideColumnWidth = 300;

/// Gap between the two dashboard columns. 700 + 24 + 300 = the 1024 design.
const double kColumnGap = 24;

/// Below this width the dashboard drops to a single column: the design's two
/// columns no longer fit, so the side content stacks under the main one.
///
/// These are design pixels; the width the layout actually needs is
/// `kDashboardBreakpoint * HomeScale.of(context)`.
const double kDashboardBreakpoint =
    kMainColumnWidth + kColumnGap + kSideColumnWidth;

/// The web dashboard layout: a 700 px main column beside a 300 px side column,
/// stacking into one column when there is not enough room.
class DashboardColumns extends StatelessWidget {
  const DashboardColumns({
    super.key,
    required this.main,
    required this.side,
    this.stackGap = MemoirSpace.s6,
  });

  /// Main column: quick picks, the quote and the writing activity.
  final Widget main;

  /// Secondary column: the journal invitation and the shortcuts.
  final Widget side;

  /// Vertical gap used once the two columns stack.
  final double stackGap;

  @override
  Widget build(BuildContext context) {
    final scale = HomeScale.of(context);
    final gap = kColumnGap * scale;
    final needed = kDashboardBreakpoint * scale;

    return LayoutBuilder(
      builder: (context, constraints) {
        // One pixel of slack: the parent sizes the content from the same scaled
        // numbers, and floating point can leave it a hair under.
        if (constraints.maxWidth + 1 < needed) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [main, SizedBox(height: stackGap * scale), side],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: kMainColumnWidth * scale, child: main),
            SizedBox(width: gap),
            SizedBox(width: kSideColumnWidth * scale, child: side),
          ],
        );
      },
    );
  }
}
