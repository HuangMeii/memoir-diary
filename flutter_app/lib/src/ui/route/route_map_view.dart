import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../data/models.dart';
import '../theme.dart';
import '../tokens.dart';
import 'route_format.dart';

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

/// The route map: the polyline, the place markers, the weather markers, and a
/// tap handler so a stop can be picked straight off the map.
///
/// Tiles come from OpenStreetMap and carry its attribution, just as the routing
/// and weather providers carry theirs.
class RouteMapView extends StatefulWidget {
  const RouteMapView({
    super.key,
    required this.plan,
    required this.report,
    required this.selectedSeq,
    required this.onSelectSample,
    required this.onPickPoint,
    this.height = 360,
    this.scale = 1,
  });

  final RoutePlan plan;
  final RouteWeatherReport? report;

  /// Sequence number of the sample the timeline has selected, if any.
  final int? selectedSeq;

  final ValueChanged<RouteWeatherSample> onSelectSample;

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
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final line = _line;
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
                if (line.length > 1)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: line,
                        strokeWidth: 4 * widget.scale,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                MarkerLayer(markers: _weatherMarkers()),
                MarkerLayer(markers: _stopMarkers()),
              ],
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

  /// Small round markers carrying the temperature, tinted by severity.
  List<Marker> _weatherMarkers() => [
        for (final sample in _samples)
          Marker(
            point: LatLng(sample.lat, sample.lon),
            width: 44 * widget.scale,
            height: 28 * widget.scale,
            child: GestureDetector(
              onTap: () => widget.onSelectSample(sample),
              child: _SampleMarker(
                sample: sample,
                selected: sample.seq == widget.selectedSeq,
                scale: widget.scale,
              ),
            ),
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

/// A temperature bubble, tinted by how notable the weather there is.
class _SampleMarker extends StatelessWidget {
  const _SampleMarker({
    required this.sample,
    required this.selected,
    required this.scale,
  });

  final RouteWeatherSample sample;
  final bool selected;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = routeSeverityColor(context, sample.severity);

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: routeSeveritySurface(context, sample.severity),
        border: Border.all(color: color, width: (selected ? 2 : 1) * scale),
        borderRadius: BorderRadius.circular(MemoirRadius.pill),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 8 * scale,
                ),
              ]
            : null,
      ),
      child: Text(
        sample.tempC == null ? '—' : '${sample.tempC!.round()}°',
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontSize: MemoirType.caption,
          fontWeight: FontWeight.w600,
        ),
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

