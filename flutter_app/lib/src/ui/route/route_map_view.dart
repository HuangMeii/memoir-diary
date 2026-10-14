import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../data/models.dart';
import '../theme.dart';
import '../tokens.dart';
import 'route_format.dart';
import 'route_segments.dart';

/// Decodes the `coordinates` of a GeoJSON LineString into map points.
List<LatLng> decodeRoutePoints(String geoJson) {
  if (geoJson.isEmpty) return const [];
  final dynamic decoded = jsonDecode(geoJson);
  if (decoded is! Map) return const [];
  final coordinates = decoded['coordinates'];
  if (coordinates is! List) return const [];

  final points = <LatLng>[];
  for (final point in coordinates) {
    if (point is! List || point.length < 2) continue;
    final lon = (point[0] as num).toDouble();
    final lat = (point[1] as num).toDouble();
    points.add(LatLng(lat, lon));
  }
  return points;
}

/// The route map: the route drawn in the colours of the weather along it, the
/// place markers, and a tap handler so a stop can be picked straight off the
/// map.
///
/// The route is one unbroken line, cut into stretches painted for the weather
/// they will be ridden through - rain teal, no rain yellow - with the stretches
/// the forecast never reached left grey. The stretches themselves come from
/// `route_segments.dart`; the pale bed and casing that hold them together are
/// drawn by a single line underneath.
///
/// Tiles come from OpenStreetMap and carry its attribution, just as the routing
/// and weather providers carry theirs.
class RouteMapView extends StatefulWidget {
  const RouteMapView({
    super.key,
    required this.plan,
    required this.report,
    required this.selectedSeq,
    required this.onPickPoint,
    this.height = 360,
    this.scale = 1,
  });

  final RoutePlan plan;
  final RouteWeatherReport? report;

  /// Sequence number of the sample the timeline has selected, if any: the
  /// stretch that holds it is drawn thicker and a ring marks the spot.
  final int? selectedSeq;

  /// Called with the coordinates of a tap on the map.
  final void Function(double lat, double lon) onPickPoint;

  final double height;
  final double scale;

  @override
  State<RouteMapView> createState() => _RouteMapViewState();
}

class _RouteMapViewState extends State<RouteMapView> {
  final MapController _controller = MapController();

  List<LatLng> get _line => decodeRoutePoints(widget.plan.geometry);

  List<RouteWeatherSample> get _samples =>
      widget.report?.samples ?? const <RouteWeatherSample>[];

  /// The route cut into stretches, each carrying the severity of the weather
  /// along it. Without a forecast this is the whole line in the brand colour.
  List<RouteSegment> get _segments => buildRouteSegments(_line, _samples);

  /// The sample the timeline picked, when it is one of the ones drawn here.
  RouteWeatherSample? get _selected {
    final seq = widget.selectedSeq;
    if (seq == null) return null;
    for (final sample in _samples) {
      if (sample.seq == seq) return sample;
    }
    return null;
  }

  @override
  void didUpdateWidget(RouteMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Follow the timeline: bring the newly selected point into view.
    final seq = widget.selectedSeq;
    if (seq == null || seq == oldWidget.selectedSeq) return;
    for (final sample in _samples) {
      if (sample.seq != seq) continue;
      _controller.move(LatLng(sample.lat, sample.lon), _controller.camera.zoom);
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = MemoirPalette.of(context);
    final line = _line;
    final segments = _segments;
    final selected = _selected;
    final stops = widget.plan.stops;

    // A plan with fewer than two points cannot be framed; fall back to Ha Noi.
    final fallback = stops.isEmpty
        ? const LatLng(21.0285, 105.8542)
        : LatLng(stops.first.lat, stops.first.lon);
    final bounds = line.length > 1
        ? LatLngBounds.fromPoints(line)
        : LatLngBounds(fallback, fallback);

    return ClipRRect(
      borderRadius: BorderRadius.circular(MemoirRadius.control * widget.scale),
      child: SizedBox(
        height: widget.height * widget.scale,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _controller,
              options: MapOptions(
                initialCameraFit: CameraFit.bounds(
                  bounds: bounds,
                  padding: EdgeInsets.all(MemoirSpace.s6 * widget.scale),
                ),
                minZoom: 3,
                maxZoom: 17,
                onTap: (_, point) =>
                    widget.onPickPoint(point.latitude, point.longitude),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'memoir_app',
                ),
                if (segments.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      _baseLine(context, line),
                      for (final segment in segments)
                        _routeLine(
                          context,
                          segment,
                          selected: selected != null &&
                              segment.covers(
                                selected.distanceFromStartMeters.toDouble(),
                              ),
                        ),
                    ],
                  ),
                MarkerLayer(markers: _stopMarkers()),
                if (selected != null)
                  MarkerLayer(
                    markers: _selectedMarkers(
                      selected,
                      _bucketAt(selected, segments),
                    ),
                  ),
              ],
            ),
            Positioned(
              right: MemoirSpace.s2 * widget.scale,
              bottom: MemoirSpace.s2 * widget.scale,
              child: _RouteMapLegend(scale: widget.scale),
            ),
            Positioned(
              left: MemoirSpace.s2 * widget.scale,
              bottom: MemoirSpace.s2 * widget.scale,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MemoirSpace.s2 * widget.scale,
                  vertical: 2 * widget.scale,
                ),
                decoration: BoxDecoration(
                  color: palette.surfaceCard.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(MemoirRadius.control),
                ),
                child: const Text(
                  '© OpenStreetMap contributors · OSRM · Open-Meteo',
                  style: TextStyle(fontSize: 9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The route drawn whole, under the painted stretches.
  ///
  /// It carries the pale casing and the bed the stretches sit on. Each stretch
  /// is drawn without a casing of its own on purpose: the casing of one stretch
  /// would bite a notch out of its neighbour wherever the weather changes, and
  /// the line would read as a row of separate pieces. One unbroken line beneath
  /// them keeps the road whole, colour change or not.
  Polyline _baseLine(BuildContext context, List<LatLng> points) {
    final palette = MemoirPalette.of(context);
    return Polyline(
      points: points,
      strokeWidth: 4.5 * widget.scale,
      color: palette.textDisabled.withValues(alpha: 0.45),
      borderStrokeWidth: 2 * widget.scale,
      borderColor: palette.surfaceCard,
    );
  }

  /// The bucket of the stretch that holds [sample], so the ring the timeline
  /// draws always matches the colour of the line under it.
  String _bucketAt(RouteWeatherSample sample, List<RouteSegment> segments) {
    final meters = sample.distanceFromStartMeters.toDouble();
    for (final segment in segments) {
      if (segment.covers(meters)) return segment.bucket;
    }
    return routeWeatherBucket(sample);
  }

  /// One stretch of the route, painted for the weather along it: rain teal, no
  /// rain yellow, no forecast grey. Every stretch is a solid stroke - the route
  /// is one continuous line, and the bed that keeps it that way comes from
  /// [_baseLine].
  Polyline _routeLine(
    BuildContext context,
    RouteSegment segment, {
    required bool selected,
  }) =>
      Polyline(
        points: segment.points,
        strokeWidth: (selected ? 7 : 4.5) * widget.scale,
        color: routeWeatherLineColor(context, segment.bucket),
      );

  /// A ring on the sample the timeline picked, so the way from a card to its
  /// spot on the route still shows now that the weather markers are gone.
  List<Marker> _selectedMarkers(RouteWeatherSample sample, String bucket) => [
        Marker(
          point: LatLng(sample.lat, sample.lon),
          width: 18 * widget.scale,
          height: 18 * widget.scale,
          child: _SelectedSampleDot(bucket: bucket, scale: widget.scale),
        ),
      ];

  /// Pins for the origin, the waypoints and the destination.
  List<Marker> _stopMarkers() {
    final stops = widget.plan.stops;
    return [
      for (var i = 0; i < stops.length; i++)
        Marker(
          point: LatLng(stops[i].lat, stops[i].lon),
          width: 150 * widget.scale,
          height: 44 * widget.scale,
          alignment: Alignment.topCenter,
          child: _StopMarker(
            stop: stops[i],
            index: i,
            last: i == stops.length - 1,
            scale: widget.scale,
          ),
        ),
    ];
  }
}

/// A ring around the sample the timeline selected, drawn in the colour of the
/// stretch under it so the selected spot reads at a glance.
class _SelectedSampleDot extends StatelessWidget {
  const _SelectedSampleDot({required this.bucket, required this.scale});

  final String bucket;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final color = routeWeatherLineColor(context, bucket);

    return Container(
      decoration: BoxDecoration(
        color: MemoirPalette.of(context).surfaceCard,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 3 * scale),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 6 * scale,
          ),
        ],
      ),
    );
  }
}

/// What the colours of the route mean, written on the map itself.
///
/// The line carries the meaning now, so the scale has to be readable where it
/// is read - and the grey entry has to be there too, or a stretch the forecast
/// never reached would read as a dry one.
class _RouteMapLegend extends StatelessWidget {
  const _RouteMapLegend({required this.scale});

  final double scale;

  static const List<(String, String)> _entries = [
    (RouteWeatherBucket.rain, 'Mưa'),
    (RouteWeatherBucket.sun, 'Nắng · không mưa'),
    (RouteWeatherBucket.unknown, 'Chưa có dự báo'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MemoirSpace.s2 * scale,
        vertical: MemoirSpace.s1 * scale,
      ),
      decoration: BoxDecoration(
        color: palette.surfaceCard.withValues(alpha: 0.92),
        border: Border.all(color: palette.borderDefault),
        borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (bucket, label) in _entries)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2 * scale),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16 * scale,
                    height: 4 * scale,
                    decoration: BoxDecoration(
                      color: routeWeatherLineColor(context, bucket),
                      borderRadius: BorderRadius.circular(2 * scale),
                    ),
                  ),
                  SizedBox(width: MemoirSpace.s2 * scale),
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: MemoirType.caption,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// A labelled pin for one stop of the route.
class _StopMarker extends StatelessWidget {
  const _StopMarker({
    required this.stop,
    required this.index,
    required this.last,
    required this.scale,
  });

  final RouteStop stop;
  final int index;
  final bool last;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final role = stop.isOrigin
        ? 'Điểm đi'
        : stop.isDestination
            ? 'Điểm đến'
            : 'Điểm dừng $index';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: MemoirSpace.s2 * scale,
            vertical: 2 * scale,
          ),
          decoration: BoxDecoration(
            color: palette.surfaceCard,
            border: Border.all(color: theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(MemoirRadius.pill),
          ),
          child: Text(
            '$role · ${stop.name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontSize: MemoirType.caption,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Icon(
          last ? Icons.place : Icons.circle,
          size: (last ? 14 : 8) * scale,
          color: theme.colorScheme.primary,
        ),
      ],
    );
  }
}

