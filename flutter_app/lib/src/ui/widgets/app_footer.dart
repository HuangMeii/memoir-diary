import 'package:flutter/material.dart';

import '../utilities.dart';

/// Below this width the footer renders as an in-page section instead of a
/// persistent bottom bar.
const double kFooterBreakpoint = 800;

/// Opens a utility screen. Kept in one place so the footer bar and the in-page
/// section navigate identically.
void openUtility(BuildContext context, UtilityItem item) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => item.builder()),
  );
}

/// Persistent footer for wide layouts (web/desktop).
class AppFooterBar extends StatelessWidget {
  const AppFooterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                Icons.widgets_outlined,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Tiện ích',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: utilityItems.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 4),
                  itemBuilder: (_, index) {
                    final item = utilityItems[index];
                    return TextButton.icon(
                      onPressed: () => openUtility(context, item),
                      icon: Icon(item.icon, size: 18),
                      label: Text(item.label),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

/// In-page utilities block for narrow layouts (mobile).
class UtilitiesSection extends StatelessWidget {
  const UtilitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tiện ích',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: utilityItems
              .map(
                (item) => ActionChip(
                  avatar: Icon(item.icon, size: 18),
                  label: Text(item.label),
                  onPressed: () => openUtility(context, item),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
