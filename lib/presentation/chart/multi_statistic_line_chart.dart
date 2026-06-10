import 'dart:math' as math;

import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vsd/domain/models/time_series.dart';
import 'package:vsd/presentation/chart/chart_crosshair.dart';
import 'package:vsd/presentation/chart/chart_utils.dart';

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

  // Finds the nearest data-x value (ms since epoch) across all series by
  // x-only distance, used to snap the trackball to the closest timestamp.
  double _nearestDataX(double dataX, List<({String name, List<DataPoint> points})> allValid) {
    var bestDist = double.infinity;
    var bestX = dataX;
    for (final s in allValid) {
      for (final p in s.points) {
        final px = p.timestamp.millisecondsSinceEpoch.toDouble();
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
  ) {
    return allValid.asMap().entries.map((e) {
      final color = kMultiChartPalette[e.key % kMultiChartPalette.length];
      final nearest = e.value.points.reduce((a, b) {
        final aDist = (a.timestamp.millisecondsSinceEpoch.toDouble() - dataX).abs();
        final bDist = (b.timestamp.millisecondsSinceEpoch.toDouble() - dataX).abs();
        return aDist <= bDist ? a : b;
      });
      return (name: e.value.name, value: nearest.value, color: color);
    }).toList();
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
    final minX = allX.reduce((a, b) => a < b ? a : b);
    final maxX = allX.reduce((a, b) => a > b ? a : b);

    final chart = CristalyseChart()
        .data(allData)
        .mapping(x: 'x', y: 'y', color: 'series')
        .geomLine(strokeWidth: 1.8)
        .animate(duration: Duration.zero)
        .scaleXContinuous(
          title: 'Timestamp',
          labels: (value) => timeFormatter.format(
            DateTime.fromMillisecondsSinceEpoch(value.toInt()),
          ),
          min: minX,
          max: maxX,
        )
        .scaleYContinuous(
          labels: chartTickFormatter(bounds.ticks),
          min: bounds.displayMin.toDouble(),
          max: bounds.displayMax.toDouble(),
          tickConfig: TickConfig(ticks: bounds.ticks),
        )
        .build();

    final sampleXLabel = timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(minX.toInt()));

    return MouseRegion(
      onHover: (event) => setState(() => _mouseX = event.localPosition.dx),
      onExit: (_) => setState(() => _mouseX = null),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          final plotRect = computePlotRect(size, bounds.ticks, [], sampleXLabel);

          List<({String name, num value, Color color})>? hoveredEntries;
          DateTime? hoveredTimestamp;
          double? crosshairX;
          List<({Offset position, Color color})> dots = const [];

          if (_mouseX != null && plotRect.width > 0) {
            final dataX = minX + (_mouseX! - plotRect.left) / plotRect.width * (maxX - minX);
            final snappedDataX = _nearestDataX(dataX, validSeries);
            hoveredTimestamp = DateTime.fromMillisecondsSinceEpoch(snappedDataX.round());
            hoveredEntries = _findHoveredEntries(snappedDataX, validSeries);
            crosshairX = plotRect.left + (snappedDataX - minX) / (maxX - minX) * plotRect.width;

            final yRange = (bounds.displayMax - bounds.displayMin).toDouble();
            dots = hoveredEntries.map((entry) {
              final entryYT = yRange > 0
                  ? 1.0 - (entry.value - bounds.displayMin) / yRange
                  : 0.5;
              return (
                position: Offset(crosshairX!, plotRect.top + entryYT * plotRect.height),
                color: entry.color,
              );
            }).toList();
          }

          return Stack(
            children: [
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
              if (hoveredEntries != null && hoveredTimestamp != null && crosshairX != null)
                buildPositionedTooltip(
                  entries: hoveredEntries,
                  timestamp: hoveredTimestamp,
                  crosshairX: crosshairX,
                  size: size,
                ),
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
    final minX = allX.reduce((a, b) => a < b ? a : b);
    final maxX = allX.reduce((a, b) => a > b ? a : b);

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
            DateTime.fromMillisecondsSinceEpoch(value.toInt()),
          ),
          min: minX,
          max: maxX,
        )
        .scaleYContinuous(
          labels: chartTickFormatter(primaryBounds.ticks),
          min: primaryBounds.displayMin.toDouble(),
          max: primaryBounds.displayMax.toDouble(),
          tickConfig: TickConfig(ticks: primaryBounds.ticks),
        )
        .scaleY2Continuous(
          labels: chartTickFormatter(secondaryBounds.ticks),
          min: secondaryBounds.displayMin.toDouble(),
          max: secondaryBounds.displayMax.toDouble(),
          tickConfig: TickConfig(ticks: secondaryBounds.ticks),
        )
        .theme(_kDualAxisTheme)
        .build();

    final allValid = [...validPrimary, ...validSecondary];
    final sampleXLabel = timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(minX.toInt()));

    return MouseRegion(
      onHover: (event) => setState(() => _mouseX = event.localPosition.dx),
      onExit: (_) => setState(() => _mouseX = null),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          final plotArea = computePlotRect(size, primaryBounds.ticks, secondaryBounds.ticks, sampleXLabel);

          List<({String name, num value, Color color})>? hoveredEntries;
          DateTime? hoveredTimestamp;
          double? crosshairX;
          List<({Offset position, Color color})> dots = const [];

          if (_mouseX != null && plotArea.width > 0) {
            final dataX = minX + (_mouseX! - plotArea.left) / plotArea.width * (maxX - minX);
            final snappedDataX = _nearestDataX(dataX, allValid);
            hoveredTimestamp = DateTime.fromMillisecondsSinceEpoch(snappedDataX.round());
            hoveredEntries = _findHoveredEntries(snappedDataX, allValid);
            crosshairX = plotArea.left + (snappedDataX - minX) / (maxX - minX) * plotArea.width;

            dots = hoveredEntries.map((entry) {
              final isPrimary = primarySeriesNames.contains(entry.name);
              final b = isPrimary ? primaryBounds : secondaryBounds;
              final yRange = (b.displayMax - b.displayMin).toDouble();
              final entryYT = yRange > 0
                  ? 1.0 - (entry.value - b.displayMin) / yRange
                  : 0.5;
              return (
                position: Offset(crosshairX!, plotArea.top + entryYT * plotArea.height),
                color: entry.color,
              );
            }).toList();
          }

          return Stack(
            children: [
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
                      displayMin: secondaryBounds.displayMin,
                      displayMax: secondaryBounds.displayMax,
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
              if (hoveredEntries != null && hoveredTimestamp != null && crosshairX != null)
                buildPositionedTooltip(
                  entries: hoveredEntries,
                  timestamp: hoveredTimestamp,
                  crosshairX: crosshairX,
                  size: size,
                ),
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
