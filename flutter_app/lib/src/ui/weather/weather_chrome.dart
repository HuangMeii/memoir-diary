import 'package:flutter/material.dart';

import '../theme.dart';
import '../tokens.dart';
import 'location_dialog.dart';

/// Breadcrumb of the weather frames: `← Trang chủ / Tiện ích`.
class WeatherBreadcrumb extends StatelessWidget {
  const WeatherBreadcrumb({
    super.key,
    required this.scale,
    required this.onBack,
  });

  final double scale;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = theme.colorScheme.primary;
    final muted = theme.colorScheme.onSurfaceVariant;
    final caption = theme.textTheme.bodySmall?.copyWith(
      color: muted,
      fontSize: MemoirType.caption,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
          onTap: onBack,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: MemoirSpace.s1 * scale,
              horizontal: 2 * scale,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The design's `arrow-left` is not exported yet.
                Icon(Icons.arrow_back, size: 16 * scale, color: brand),
                SizedBox(width: MemoirSpace.s2 * scale),
                Text(
                  'Trang chủ',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: brand,
                    fontSize: MemoirType.body,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: MemoirSpace.s1 * scale),
        Text('/', style: caption),
        SizedBox(width: MemoirSpace.s1 * scale),
        Text('Tiện ích', style: caption),
      ],
    );
  }
}

/// The `Forecast introduction`: overline, page title, description and the
/// location controls on the right.
class WeatherHeading extends StatelessWidget {
  const WeatherHeading({
    super.key,
    required this.overline,
    required this.title,
    required this.description,
    required this.locationName,
    required this.places,
    required this.scale,
    required this.onOpenLocationDialog,
    required this.onPickLocation,
  });

  final String overline;
  final String title;
  final String description;

  /// The location the forecast is showing.
  final String locationName;

  final List<WeatherPlace> places;
  final double scale;

  /// Opens the full `Chọn địa điểm` dialog.
  final VoidCallback onOpenLocationDialog;

  /// Applies a province picked from the quick menu.
  final ValueChanged<WeatherPlace> onPickLocation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          overline,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: MemoirType.overlineEditorial,
            letterSpacing: MemoirType.overlineEditorialLetterSpacing,
          ),
        ),
        SizedBox(height: MemoirSpace.s3 * scale),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontSize: MemoirType.headingPage,
            height: MemoirType.headingPageLineHeight / MemoirType.headingPage,
          ),
        ),
        SizedBox(height: MemoirSpace.s1 * scale),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: muted,
            fontSize: MemoirType.body,
          ),
        ),
      ],
    );

    final controls = WeatherLocationControls(
      currentName: locationName,
      places: places,
      scale: scale,
      onOpenDialog: onOpenLocationDialog,
      onPick: onPickLocation,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 720 * scale) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: heading),
              SizedBox(width: MemoirSpace.s6 * scale),
              SizedBox(width: 264 * scale, child: controls),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading,
            SizedBox(height: MemoirSpace.s4 * scale),
            controls,
          ],
        );
      },
    );
  }
}

/// The two location controls of the heading: the big button that opens the
/// `Chọn địa điểm` dialog and the quick `Dùng vị trí hiện tại` menu.
class WeatherLocationControls extends StatelessWidget {
  const WeatherLocationControls({
    super.key,
    required this.currentName,
    required this.places,
    required this.scale,
    required this.onOpenDialog,
    required this.onPick,
  });

  final String currentName;
  final List<WeatherPlace> places;
  final double scale;
  final VoidCallback onOpenDialog;
  final ValueChanged<WeatherPlace> onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = theme.colorScheme.primary;
    final muted = theme.colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
          onTap: onOpenDialog,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: MemoirSpace.s4 * scale,
              vertical: MemoirSpace.s2 * scale + 3,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Icon(Icons.place_outlined, size: 18 * scale, color: brand),
                SizedBox(width: MemoirSpace.s2 * scale),
                Expanded(
                  child: Text(
                    currentName.isEmpty ? 'Chọn địa điểm' : currentName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: MemoirType.label,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: MemoirSpace.s2 * scale),
        PopupMenuButton<WeatherPlace>(
          tooltip: 'Dùng vị trí hiện tại',
          onSelected: onPick,
          itemBuilder: (context) => [
            for (final place in places)
              PopupMenuItem<WeatherPlace>(
                value: place,
                child: Text(place.name),
              ),
          ],
          child: Row(
            children: [
              Icon(Icons.my_location, size: 14 * scale, color: brand),
              SizedBox(width: MemoirSpace.s2 * scale),
              Expanded(
                child: Text(
                  'Dùng vị trí hiện tại',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: muted,
                    fontSize: MemoirType.body,
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_down, size: 14 * scale, color: muted),
            ],
          ),
        ),
      ],
    );
  }
}

/// The status strip under the heading.
///
/// Names the source of the reading, or turns into a cautious callout when the
/// server answered from its stored snapshots and the number may be stale.
class WeatherDataNotice extends StatelessWidget {
  const WeatherDataNotice({
    super.key,
    required this.message,
    required this.scale,
    this.isWarning = false,
    this.onRefresh,
  });

  final String message;
  final double scale;

  /// Draws the strip in the warning palette.
  final bool isWarning;

  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final foreground =
        isWarning ? palette.warningText : theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MemoirSpace.s3 * scale,
        vertical: MemoirSpace.s2 * scale,
      ),
      decoration: BoxDecoration(
        color: isWarning
            ? palette.warningSurface
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(MemoirRadius.feedback * scale),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            isWarning ? Icons.info_outline : Icons.cloud_outlined,
            size: 14 * scale,
            color: foreground,
          ),
          SizedBox(width: MemoirSpace.s2 * scale),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: foreground,
                fontSize: MemoirType.caption,
              ),
            ),
          ),
          if (onRefresh != null)
            TextButton.icon(
              onPressed: onRefresh,
              icon: Icon(Icons.refresh, size: 14 * scale),
              label: const Text('Tải lại'),
            ),
        ],
      ),
    );
  }
}

/// The muted source line that closes the page.
class WeatherSourceNote extends StatelessWidget {
  const WeatherSourceNote({super.key, required this.message, required this.scale});

  final String message;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      message,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontSize: MemoirType.caption,
      ),
    );
  }
}
