import 'package:flutter/material.dart';

import '../theme.dart';
import '../tokens.dart';

/// One suggested province / town of the `Chọn địa điểm` picker.
class WeatherPlace {
  const WeatherPlace(this.name, this.lat, this.lon);

  final String name;
  final double lat;
  final double lon;

  /// Two places are the same when they name the same town; the coordinates are
  /// only used for the API call.
  @override
  bool operator ==(Object other) => other is WeatherPlace && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

/// The provinces the picker suggests, in the order the design lists them.
const List<WeatherPlace> kWeatherPlaces = [
  WeatherPlace('TP. Hồ Chí Minh', 10.8231, 106.6297),
  WeatherPlace('Hà Nội', 21.0285, 105.8542),
  WeatherPlace('Đà Nẵng', 16.0544, 108.2022),
  WeatherPlace('Huế', 16.4637, 107.5909),
  WeatherPlace('Cần Thơ', 10.0452, 105.7469),
  WeatherPlace('Hải Phòng', 20.8449, 106.6881),
  WeatherPlace('Hạ Long', 20.9101, 107.1839),
  WeatherPlace('Nha Trang', 12.2388, 109.1967),
  WeatherPlace('Đà Lạt', 11.9465, 108.4419),
  WeatherPlace('Phú Quốc', 10.2899, 103.9840),
];

/// The `Chọn địa điểm` dialog (`46:9100`).
///
/// Heading and close button, the description, the province search, the
/// "use my location" action, the location-permission callout and the suggested
/// provinces. Pops the picked [WeatherPlace], or null when dismissed.
class LocationDialog extends StatefulWidget {
  const LocationDialog({
    super.key,
    required this.currentName,
    required this.places,
  });

  /// The location the forecast is showing, marked `Đang chọn` in the list.
  final String currentName;

  final List<WeatherPlace> places;

  @override
  State<LocationDialog> createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
  final _query = TextEditingController();
  String _filter = '';
  bool _permissionCardVisible = true;
  bool _locating = false;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  List<WeatherPlace> get _matches => widget.places
      .where((place) =>
          _filter.isEmpty ||
          place.name.toLowerCase().contains(_filter.toLowerCase()))
      .toList();

  /// The browser location is not wired up yet, so `Tiếp tục` explains that
  /// instead of pretending to resolve a position.
  void _requestLocation() => setState(() {
        _locating = true;
        _permissionCardVisible = true;
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Dialog(
      insetPadding: const EdgeInsets.all(MemoirSpace.s4),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: MemoirSize.weatherWidth520),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(MemoirSpace.s6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Chọn tỉnh / thành',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Đóng',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              Text(
                'Chọn nơi bạn muốn xem dự báo.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: muted,
                  fontSize: MemoirType.body,
                ),
              ),
              const SizedBox(height: MemoirSpace.s4),
              TextField(
                controller: _query,
                autofocus: true,
                onChanged: (value) => setState(() => _filter = value.trim()),
                decoration: const InputDecoration(
                  hintText: 'Tìm tỉnh / thành phố',
                  prefixIcon: Icon(Icons.search, size: 18),
                ),
              ),
              const SizedBox(height: MemoirSpace.s3),
              OutlinedButton.icon(
                onPressed: _requestLocation,
                icon: const Icon(Icons.my_location, size: 18),
                label: const Text('Dùng vị trí hiện tại'),
              ),
              if (_permissionCardVisible) ...[
                const SizedBox(height: MemoirSpace.s3),
                _permissionCard(context),
              ],
              const SizedBox(height: MemoirSpace.s5),
              Text(
                'TỈNH / THÀNH GỢI Ý',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: MemoirType.overlineEditorial,
                  letterSpacing: MemoirType.overlineEditorialLetterSpacing,
                ),
              ),
              const SizedBox(height: MemoirSpace.s2),
              for (final place in _matches) _option(context, place),
              if (_matches.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: MemoirSpace.s3,
                  ),
                  child: Text(
                    'Không tìm thấy tỉnh / thành phù hợp.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: muted,
                      fontSize: MemoirType.body,
                    ),
                  ),
                ),
              const SizedBox(height: MemoirSpace.s4),
              Text(
                'Địa điểm áp dụng ngay cho dự báo.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: muted,
                  fontSize: MemoirType.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The `Cần quyền truy cập vị trí` callout above the province list.
  Widget _permissionCard(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);

    return Container(
      padding: const EdgeInsets.all(MemoirSpace.s4),
      decoration: BoxDecoration(
        color: palette.warningSurface,
        borderRadius: BorderRadius.circular(MemoirRadius.feedback),
        border: Border.all(color: palette.warningText.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.place_outlined, size: 18, color: palette.warningText),
              const SizedBox(width: MemoirSpace.s2),
              Expanded(
                child: Text(
                  'Cần quyền truy cập vị trí',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: palette.warningText,
                    fontSize: MemoirType.body,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: MemoirSpace.s1),
          Text(
            _locating
                ? 'Bản này chưa kết nối định vị tự động. Hãy chọn một tỉnh / '
                    'thành bên dưới.'
                : 'Trình duyệt sẽ hỏi quyền khi bạn tiếp tục. Chưa yêu cầu '
                    'quyền và chưa xác định vị trí của bạn.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: MemoirType.caption,
              height: 1.5,
            ),
          ),
          const SizedBox(height: MemoirSpace.s2),
          Row(
            children: [
              TextButton.icon(
                onPressed: _requestLocation,
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Tiếp tục'),
              ),
              const SizedBox(width: MemoirSpace.s1),
              TextButton(
                onPressed: () => setState(() => _permissionCardVisible = false),
                child: const Text('Để sau'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// One province row; the one the forecast is showing carries `Đang chọn`.
  Widget _option(BuildContext context, WeatherPlace place) {
    final theme = Theme.of(context);
    final isCurrent = place.name == widget.currentName;

    return InkWell(
      borderRadius: BorderRadius.circular(MemoirRadius.control),
      onTap: () => Navigator.of(context).pop(place),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: MemoirSpace.custom10,
          horizontal: MemoirSpace.s1,
        ),
        child: Row(
          children: [
            Icon(
              Icons.place_outlined,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: MemoirSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: MemoirType.body,
                    ),
                  ),
                  if (isCurrent)
                    Text(
                      'Đang chọn',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontSize: MemoirType.caption,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              isCurrent ? Icons.check : Icons.chevron_right,
              size: 16,
              color: isCurrent
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
