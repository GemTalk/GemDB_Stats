import 'dart:math' as math;

import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vsd/domain/models/time_series.dart';
import 'package:vsd/presentation/_reusable_components/tool_icon_button.dart';
import 'package:vsd/presentation/chart/chart_crosshair.dart';
import 'package:vsd/presentation/chart/chart_utils.dart';
import 'package:vsd/presentation/chart/selection_box_painter.dart';

// Matches Cristalyse's default ChartTheme.defaultTheme() colorPalette order.
const List<Color> kMultiChartPalette = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.brown,
  Colors.pink,
  Colors.grey,
  Colors.cyan,
  Colors.lime,
];

// Default theme with colorPalette[1] changed to the axis color so the Y2 axis
// label is rendered black (Cristalyse hardcodes Y2 label = colorPalette[1]).
const ChartTheme _kDualAxisTheme = ChartTheme(
  backgroundColor: Colors.white,
  plotBackgroundColor: Colors.white,
  primaryColor: Colors.blue,
  borderColor: Colors.grey,
  gridColor: Color(0xFFE0E0E0),
  axisColor: Colors.black87,
  gridWidth: 0.5,
  axisWidth: 1.0,
  pointSizeDefault: 4.0,
  pointSizeMin: 2.0,
  pointSizeMax: 12.0,
  colorPalette: [
    Colors.blue,
    Colors.black87,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.pink,
    Colors.grey,
    Colors.cyan,
    Colors.lime,
  ],
  padding: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
  axisTextStyle: TextStyle(fontSize: 12, color: Colors.black87),
  axisLabelStyle: TextStyle(fontSize: 12, color: Colors.black87),
);

class MultiStatisticLineChart extends StatefulWidget {
  const MultiStatisticLineChart({
    required this.primarySeries,
    required this.secondarySeries,
    super.key,
  });

  final List<({String name, List<DataPoint> points})> primarySeries;
  final List<({String name, List<DataPoint> points})> secondarySeries;

  @override
  State<MultiStatisticLineChart> createState() => _MultiStatisticLineChartState();
}

class _MultiStatisticLineChartState extends State<MultiStatisticLineChart> {
  double? _mouseX;

  // Active zoom window in data coordinates; null means "show full range".
  // minY/maxY apply to the primary (left) axis, minY2/maxY2 to the secondary
  // (right) axis when the chart is dual-axis.
  ({double minX, double maxX, double minY, double maxY, double? minY2, double? maxY2})? _zoom;

  // Transient drag state for the marquee selection box.
  Offset? _dragStart;
  Offset? _dragCurrent;
  bool _dragging = false;

  @override
  void didUpdateWidget(MultiStatisticLineChart old) {
    super.didUpdateWidget(old);
    // The series lists are rebuilt every parent build, so compare a stable
    // projection: series names + each series' points identity. Reset the zoom
    // when the selection or underlying data changes.
    if (_seriesChanged(old.primarySeries, widget.primarySeries) ||
        _seriesChanged(old.secondarySeries, widget.secondarySeries)) {
      _zoom = null;
    }
  }

  bool _seriesChanged(
    List<({String name, List<DataPoint> points})> a,
    List<({String name, List<DataPoint> points})> b,
  ) {
    if (a.length != b.length) {
      return true;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i].name != b[i].name || !identical(a[i].points, b[i].points) || a[i].points.length != b[i].points.length) {
        return true;
      }
    }
    return false;
  }

  // Finds the nearest in-window data-x value (ms since epoch) across all
  // series, used to snap the trackball. Returns null when the visible window
  // contains no points.
  double? _nearestDataX(
    double dataX,
    List<({String name, List<DataPoint> points})> allValid,
    double minX,
    double maxX,
  ) {
    var bestDist = double.infinity;
    double? bestX;
    for (final s in allValid) {
      for (final p in s.points) {
        final px = p.timestamp.millisecondsSinceEpoch.toDouble();
        if (px < minX || px > maxX) {
          continue;
        }
        final d = (px - dataX).abs();
        if (d < bestDist) {
          bestDist = d;
          bestX = px;
        }
      }
    }
    return bestX;
  }

  List<({String name, num value, Color color})> _findHoveredEntries(
    double dataX,
    List<({String name, List<DataPoint> points})> allValid,
    double minX,
    double maxX,
  ) {
    final result = <({String name, num value, Color color})>[];
    for (var i = 0; i < allValid.length; i++) {
      final color = kMultiChartPalette[i % kMultiChartPalette.length];
      DataPoint? nearest;
      var bestDist = double.infinity;
      for (final p in allValid[i].points) {
        final px = p.timestamp.millisecondsSinceEpoch.toDouble();
        if (px < minX || px > maxX) {
          continue;
        }
        final d = (px - dataX).abs();
        if (d < bestDist) {
          bestDist = d;
          nearest = p;
        }
      }
      if (nearest != null) {
        result.add((name: allValid[i].name, value: nearest.value, color: color));
      }
    }
    return result;
  }

  num _computePadding(num range) {
    return range > 0 ? range * 0.1 : 1.0;
  }

  ({num displayMin, num displayMax, List<double> ticks}) _yBounds(
    List<({String name, List<DataPoint> points})> series,
  ) {
    final allY = series.expand((s) => s.points).map((p) => p.value).toList();
    final minY = allY.reduce((a, b) => a < b ? a : b);
    final maxY = allY.reduce((a, b) => a > b ? a : b);
    final padding = _computePadding(maxY - minY);
    final displayMin = minY >= 0 ? (minY - padding).clamp(0, minY) : minY - padding;
    final displayMax = maxY + padding;
    return (displayMin: displayMin, displayMax: displayMax, ticks: buildChartTicks(displayMin, displayMax));
  }

  // Wraps chart content with the drag-to-zoom gesture handling.
  Widget _zoomGestureDetector({
    required Widget child,
    required Rect plotRect,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    required List<({String name, List<DataPoint> points})> windowSeries,
    double? minY2,
    double? maxY2,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: _zoom == null ? null : () => setState(() => _zoom = null),
      onPanStart: (details) {
        _dragStart = details.localPosition;
        _dragCurrent = details.localPosition;
      },
      onPanUpdate: (details) => setState(() {
        _dragCurrent = details.localPosition;
        if (!_dragging && (details.localPosition - _dragStart!).distance > kDragThreshold) {
          _dragging = true;
        }
      }),
      onPanEnd: (_) => _commitZoom(
        plotRect: plotRect,
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        minY2: minY2,
        maxY2: maxY2,
        windowSeries: windowSeries,
      ),
      onPanCancel: () => setState(() {
        _dragStart = null;
        _dragCurrent = null;
        _dragging = false;
      }),
      child: child,
    );
  }

  void _commitZoom({
    required Rect plotRect,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    required List<({String name, List<DataPoint> points})> windowSeries,
    double? minY2,
    double? maxY2,
  }) {
    final start = _dragStart;
    final current = _dragCurrent;
    Rect? box;
    if (start != null && current != null) {
      box = normalizeDragBox(start, current, plotRect);
    }

    setState(() {
      _dragStart = null;
      _dragCurrent = null;
      _dragging = false;
      if (box == null) {
        return; // click / sliver — not a zoom
      }
      final newMinX = pixelToDataX(box.left, plotRect, minX, maxX);
      final newMaxX = pixelToDataX(box.right, plotRect, minX, maxX);
      // Top pixel = max value, bottom pixel = min value.
      final newMaxY = pixelToDataY(box.top, plotRect, minY, maxY);
      final newMinY = pixelToDataY(box.bottom, plotRect, minY, maxY);
      double? newMinY2;
      double? newMaxY2;
      if (minY2 != null && maxY2 != null) {
        newMaxY2 = pixelToDataY(box.top, plotRect, minY2, maxY2);
        newMinY2 = pixelToDataY(box.bottom, plotRect, minY2, maxY2);
      }

      final hasPoints = windowSeries.any(
        (s) => s.points.any((p) {
          final px = p.timestamp.millisecondsSinceEpoch.toDouble();
          return px >= newMinX && px <= newMaxX;
        }),
      );
      if (!hasPoints || newMaxX <= newMinX || newMaxY <= newMinY) {
        return;
      }
      _zoom = (minX: newMinX, maxX: newMaxX, minY: newMinY, maxY: newMaxY, minY2: newMinY2, maxY2: newMaxY2);
    });
  }

  Widget _resetButton() {
    if (_zoom == null) {
      return const SizedBox.shrink();
    }
    return Positioned(
      top: 4,
      right: 4,
      child: ToolIconButton(
        icon: FontAwesomeIcons.magnifyingGlassMinus,
        tooltip: 'Reset zoom',
        onTap: () => setState(() => _zoom = null),
      ),
    );
  }

  Widget? _selectionOverlay(Size size) {
    if (!_dragging || _dragStart == null || _dragCurrent == null) {
      return null;
    }
    return IgnorePointer(
      child: SizedBox.fromSize(
        size: size,
        child: CustomPaint(
          painter: SelectionBoxPainter(box: Rect.fromPoints(_dragStart!, _dragCurrent!)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final validPrimary = widget.primarySeries.where((s) => s.points.length >= 2).toList();
    final validSecondary = widget.secondarySeries.where((s) => s.points.length >= 2).toList();

    if (validPrimary.isEmpty && validSecondary.isEmpty) {
      return kNotEnoughDataWidget;
    }

    final timeFormatter = DateFormat('HH:mm:ss');
    final isDual = validPrimary.isNotEmpty && validSecondary.isNotEmpty;

    if (!isDual) {
      return _buildSingleAxisChart(
        validPrimary.isNotEmpty ? validPrimary : validSecondary,
        timeFormatter,
      );
    }

    return _buildDualAxisChart(validPrimary, validSecondary, timeFormatter);
  }

  Widget _buildSingleAxisChart(
    List<({String name, List<DataPoint> points})> validSeries,
    DateFormat timeFormatter,
  ) {
    final allData = validSeries
        .expand(
          (s) => s.points.map(
            (p) => {
              'x': p.timestamp.millisecondsSinceEpoch.toDouble(),
              'y': p.value,
              'series': s.name,
            },
          ),
        )
        .toList();

    final bounds = _yBounds(validSeries);

    final allX = allData.map((d) => d['x'] as double).toList();
    final fullMinX = allX.reduce((a, b) => a < b ? a : b);
    final fullMaxX = allX.reduce((a, b) => a > b ? a : b);

    // Active bounds: exact zoom box when zoomed (bypasses padding / clamp).
    final minX = _zoom?.minX ?? fullMinX;
    final maxX = _zoom?.maxX ?? fullMaxX;
    final displayMinY = _zoom?.minY ?? bounds.displayMin.toDouble();
    final displayMaxY = _zoom?.maxY ?? bounds.displayMax.toDouble();
    final yTicks = buildChartTicks(displayMinY, displayMaxY);

    final chart = CristalyseChart()
        .data(allData)
        .mapping(x: 'x', y: 'y', color: 'series')
        .geomLine(strokeWidth: 1.8)
        .animate(duration: Duration.zero)
        .scaleXContinuous(
          title: 'Timestamp',
          labels: (value) => timeFormatter.format(
            DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true),
          ),
          min: minX,
          max: maxX,
        )
        .scaleYContinuous(
          labels: chartTickFormatter(yTicks),
          min: displayMinY,
          max: displayMaxY,
          tickConfig: TickConfig(ticks: yTicks),
        )
        .build();

    final sampleXLabel = timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(minX.toInt(), isUtc: true));

    return MouseRegion(
      cursor: _dragging ? SystemMouseCursors.precise : SystemMouseCursors.basic,
      onHover: (event) => setState(() => _mouseX = event.localPosition.dx),
      onExit: (_) => setState(() => _mouseX = null),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          final plotRect = computePlotRect(size, yTicks, [], sampleXLabel);

          List<({String name, num value, Color color})>? hoveredEntries;
          DateTime? hoveredTimestamp;
          double? crosshairX;
          List<({Offset position, Color color})> dots = const [];

          if (!_dragging && _mouseX != null && plotRect.width > 0) {
            final dataX = pixelToDataX(_mouseX!, plotRect, minX, maxX);
            final snappedDataX = _nearestDataX(dataX, validSeries, minX, maxX);
            if (snappedDataX != null) {
              hoveredTimestamp = DateTime.fromMillisecondsSinceEpoch(snappedDataX.round(), isUtc: true);
              hoveredEntries = _findHoveredEntries(snappedDataX, validSeries, minX, maxX);
              crosshairX = plotRect.left + (snappedDataX - minX) / (maxX - minX) * plotRect.width;

              final yRange = displayMaxY - displayMinY;
              dots = hoveredEntries.map((entry) {
                final entryYT = yRange > 0 ? 1.0 - (entry.value - displayMinY) / yRange : 0.5;
                return (
                  position: Offset(crosshairX!, plotRect.top + entryYT * plotRect.height),
                  color: entry.color,
                );
              }).toList();
            }
          }

          final children = <Widget>[
            chart,
            if (crosshairX != null)
              IgnorePointer(
                child: SizedBox.fromSize(
                  size: size,
                  child: CustomPaint(
                    painter: CrosshairPainter(xPosition: crosshairX, dots: dots),
                  ),
                ),
              ),
            ?_selectionOverlay(size),
            if (hoveredEntries != null && hoveredEntries.isNotEmpty && hoveredTimestamp != null && crosshairX != null)
              buildPositionedTooltip(
                entries: hoveredEntries,
                timestamp: hoveredTimestamp,
                crosshairX: crosshairX,
                size: size,
              ),
          ];

          return Stack(
            children: [
              _zoomGestureDetector(
                plotRect: plotRect,
                minX: minX,
                maxX: maxX,
                minY: displayMinY,
                maxY: displayMaxY,
                windowSeries: validSeries,
                child: Stack(children: children),
              ),
              _resetButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDualAxisChart(
    List<({String name, List<DataPoint> points})> validPrimary,
    List<({String name, List<DataPoint> points})> validSecondary,
    DateFormat timeFormatter,
  ) {
    final primarySeriesNames = validPrimary.map((s) => s.name).toSet();
    final primaryBounds = _yBounds(validPrimary);
    final secondaryBounds = _yBounds(validSecondary);

    // Secondary series are NOT given real y2 values here — Cristalyse will skip
    // drawing them (null y2 → skipped) but will still render the right Y axis
    // because mappingY2 + geomLine(secondary) + scaleY2Continuous are configured.
    // We draw the secondary lines ourselves as dashes in the CustomPaint overlay.
    final allData = [
      ...validPrimary.expand(
        (s) => s.points.map(
          (p) => {
            'x': p.timestamp.millisecondsSinceEpoch.toDouble(),
            'y': p.value,
            'y2': null,
            'series': s.name,
          },
        ),
      ),
      // Include secondary x-values so X scale spans all data; y/y2 null → no lines drawn.
      ...validSecondary.expand(
        (s) => s.points.map(
          (p) => {
            'x': p.timestamp.millisecondsSinceEpoch.toDouble(),
            'y': null,
            'y2': null,
            'series': s.name,
          },
        ),
      ),
    ];

    final allX = allData.map((d) => d['x'] as double).toList();
    final fullMinX = allX.reduce((a, b) => a < b ? a : b);
    final fullMaxX = allX.reduce((a, b) => a > b ? a : b);

    // Active bounds: exact zoom box when zoomed (each axis independently).
    final minX = _zoom?.minX ?? fullMinX;
    final maxX = _zoom?.maxX ?? fullMaxX;
    final primMinY = _zoom?.minY ?? primaryBounds.displayMin.toDouble();
    final primMaxY = _zoom?.maxY ?? primaryBounds.displayMax.toDouble();
    final secMinY = _zoom?.minY2 ?? secondaryBounds.displayMin.toDouble();
    final secMaxY = _zoom?.maxY2 ?? secondaryBounds.displayMax.toDouble();
    final primTicks = buildChartTicks(primMinY, primMaxY);
    final secTicks = buildChartTicks(secMinY, secMaxY);

    final chart = CristalyseChart()
        .data(allData)
        .mapping(x: 'x', y: 'y', color: 'series')
        .mappingY2('y2')
        .geomLine(strokeWidth: 1.8)
        .geomLine(strokeWidth: 1.8, yAxis: YAxis.secondary) // keeps right axis enabled
        .animate(duration: Duration.zero)
        .scaleXContinuous(
          title: 'Timestamp',
          labels: (value) => timeFormatter.format(
            DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true),
          ),
          min: minX,
          max: maxX,
        )
        .scaleYContinuous(
          labels: chartTickFormatter(primTicks),
          min: primMinY,
          max: primMaxY,
          tickConfig: TickConfig(ticks: primTicks),
        )
        .scaleY2Continuous(
          labels: chartTickFormatter(secTicks),
          min: secMinY,
          max: secMaxY,
          tickConfig: TickConfig(ticks: secTicks),
        )
        .theme(_kDualAxisTheme)
        .build();

    final allValid = [...validPrimary, ...validSecondary];
    final sampleXLabel = timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(minX.toInt(), isUtc: true));

    return MouseRegion(
      cursor: _dragging ? SystemMouseCursors.precise : SystemMouseCursors.basic,
      onHover: (event) => setState(() => _mouseX = event.localPosition.dx),
      onExit: (_) => setState(() => _mouseX = null),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          final plotArea = computePlotRect(size, primTicks, secTicks, sampleXLabel);

          List<({String name, num value, Color color})>? hoveredEntries;
          DateTime? hoveredTimestamp;
          double? crosshairX;
          List<({Offset position, Color color})> dots = const [];

          if (!_dragging && _mouseX != null && plotArea.width > 0) {
            final dataX = pixelToDataX(_mouseX!, plotArea, minX, maxX);
            final snappedDataX = _nearestDataX(dataX, allValid, minX, maxX);
            if (snappedDataX != null) {
              hoveredTimestamp = DateTime.fromMillisecondsSinceEpoch(snappedDataX.round(), isUtc: true);
              hoveredEntries = _findHoveredEntries(snappedDataX, allValid, minX, maxX);
              crosshairX = plotArea.left + (snappedDataX - minX) / (maxX - minX) * plotArea.width;

              dots = hoveredEntries.map((entry) {
                final isPrimary = primarySeriesNames.contains(entry.name);
                final bMin = isPrimary ? primMinY : secMinY;
                final bMax = isPrimary ? primMaxY : secMaxY;
                final yRange = bMax - bMin;
                final entryYT = yRange > 0 ? 1.0 - (entry.value - bMin) / yRange : 0.5;
                return (
                  position: Offset(crosshairX!, plotArea.top + entryYT * plotArea.height),
                  color: entry.color,
                );
              }).toList();
            }
          }

          final children = <Widget>[
            chart,
            // Dashed secondary lines drawn on top of the Cristalyse chart.
            IgnorePointer(
              child: SizedBox.fromSize(
                size: size,
                child: CustomPaint(
                  painter: _DashedLinesPainter(
                    series: validSecondary,
                    colorOffset: validPrimary.length,
                    plotArea: plotArea,
                    minX: minX,
                    maxX: maxX,
                    displayMin: secMinY,
                    displayMax: secMaxY,
                  ),
                ),
              ),
            ),
            if (crosshairX != null)
              IgnorePointer(
                child: SizedBox.fromSize(
                  size: size,
                  child: CustomPaint(
                    painter: CrosshairPainter(xPosition: crosshairX, dots: dots),
                  ),
                ),
              ),
            ?_selectionOverlay(size),
            if (hoveredEntries != null && hoveredEntries.isNotEmpty && hoveredTimestamp != null && crosshairX != null)
              buildPositionedTooltip(
                entries: hoveredEntries,
                timestamp: hoveredTimestamp,
                crosshairX: crosshairX,
                size: size,
              ),
          ];

          return Stack(
            children: [
              _zoomGestureDetector(
                plotRect: plotArea,
                minX: minX,
                maxX: maxX,
                minY: primMinY,
                maxY: primMaxY,
                minY2: secMinY,
                maxY2: secMaxY,
                windowSeries: allValid,
                child: Stack(children: children),
              ),
              _resetButton(),
            ],
          );
        },
      ),
    );
  }
}

class _DashedLinesPainter extends CustomPainter {
  const _DashedLinesPainter({
    required this.series,
    required this.colorOffset,
    required this.plotArea,
    required this.minX,
    required this.maxX,
    required this.displayMin,
    required this.displayMax,
  });

  final List<({String name, List<DataPoint> points})> series;
  final int colorOffset;
  final Rect plotArea;
  final double minX;
  final double maxX;
  final num displayMin;
  final num displayMax;

  @override
  void paint(Canvas canvas, Size size) {
    final xRange = maxX - minX;
    final yRange = (displayMax - displayMin).toDouble();
    if (xRange <= 0 || yRange <= 0 || plotArea.isEmpty) {
      return;
    }

    // Clip to the plot area so zoomed-out segments don't bleed over the axes
    // and labels (Cristalyse clips its own geometry the same way).
    canvas.save();
    canvas.clipRect(plotArea);

    for (int i = 0; i < series.length; i++) {
      final s = series[i];
      final color = kMultiChartPalette[(colorOffset + i) % kMultiChartPalette.length];

      final sorted = List.of(s.points)..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      final pts = sorted.map((p) {
        final sx = plotArea.left + (p.timestamp.millisecondsSinceEpoch.toDouble() - minX) / xRange * plotArea.width;
        final sy = plotArea.top + (1.0 - (p.value - displayMin) / yRange) * plotArea.height;
        return Offset(sx, sy);
      }).toList();

      _drawDashed(canvas, pts, color);
    }

    canvas.restore();
  }

  void _drawDashed(Canvas canvas, List<Offset> pts, Color color) {
    if (pts.length < 2) {
      return;
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const dashLen = 7.0;
    const gapLen = 4.0;

    for (int i = 0; i < pts.length - 1; i++) {
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final dx = p2.dx - p1.dx;
      final dy = p2.dy - p1.dy;
      final dist = math.sqrt(dx * dx + dy * dy);
      if (dist == 0) {
        continue;
      }
      final nx = dx / dist;
      final ny = dy / dist;

      double drawn = 0;
      bool dashing = true;
      while (drawn < dist) {
        final segLen = math.min(dashing ? dashLen : gapLen, dist - drawn);
        if (dashing) {
          canvas.drawLine(
            Offset(p1.dx + nx * drawn, p1.dy + ny * drawn),
            Offset(p1.dx + nx * (drawn + segLen), p1.dy + ny * (drawn + segLen)),
            paint,
          );
        }
        drawn += segLen;
        dashing = !dashing;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedLinesPainter old) =>
      old.series != series ||
      old.plotArea != plotArea ||
      old.minX != minX ||
      old.maxX != maxX ||
      old.displayMin != displayMin ||
      old.displayMax != displayMax;
}
