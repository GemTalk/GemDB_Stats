import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vsd/domain/models/time_series.dart';
import 'package:vsd/presentation/chart/chart_crosshair.dart';
import 'package:vsd/presentation/chart/trackball_tooltip.dart';

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

// theme.padding.top is always 16px — used for tooltip and dot Y calibration.
const double _kPlotTop = 16.0;
const double _kTooltipWidth = 170.0;

class MultiStatisticLineChart extends StatefulWidget {
  const MultiStatisticLineChart({required this.series, super.key});

  final List<({String name, List<DataPoint> points})> series;

  @override
  State<MultiStatisticLineChart> createState() => _MultiStatisticLineChartState();
}

class _MultiStatisticLineChartState extends State<MultiStatisticLineChart> {
  // Populated by Cristalyse's HoverConfig — screenPosition is from the actual
  // painter plotArea, so it gives pixel-perfect dot positions.
  DataPointInfo? _hover;

  List<({String name, int value, Color color})> _findHoveredEntries(
    double dataX,
    List<({String name, List<DataPoint> points})> validSeries,
  ) {
    return validSeries.asMap().entries.map((e) {
      final color = kMultiChartPalette[e.key % kMultiChartPalette.length];
      final nearest = e.value.points.reduce((a, b) {
        final aDist = (a.timestamp.millisecondsSinceEpoch.toDouble() - dataX).abs();
        final bDist = (b.timestamp.millisecondsSinceEpoch.toDouble() - dataX).abs();
        return aDist <= bDist ? a : b;
      });
      return (name: e.value.name, value: nearest.value, color: color);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final validSeries = widget.series.where((s) => s.points.length >= 2).toList();

    if (validSeries.isEmpty) {
      return const Center(
        child: Text(
          'Not enough data',
          style: TextStyle(fontSize: 12, color: Colors.black45),
        ),
      );
    }

    final timeFormatter = DateFormat('HH:mm:ss');

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

    final allY = validSeries.expand((s) => s.points).map((p) => p.value).toList();
    final minY = allY.reduce((a, b) => a < b ? a : b);
    final maxY = allY.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    final computedPadding = (range * 0.1).ceil();
    final padding = computedPadding < 2 ? 2 : computedPadding;
    final displayMinY = minY >= 0 ? (minY - padding).clamp(0, minY) : minY - padding;
    final displayMaxY = maxY + padding;
    final yTicks = _buildIntegerTicks(displayMinY, displayMaxY);

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
          labels: (value) => value.round().toString(),
          min: displayMinY.toDouble(),
          max: displayMaxY.toDouble(),
          tickConfig: TickConfig(ticks: yTicks),
        )
        .interaction(
          hover: HoverConfig(
            hitTestRadius: 10000,
            onHover: (p) => setState(() => _hover = p),
            onExit: (_) => setState(() => _hover = null),
          ),
        )
        .build();

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;

        List<({String name, int value, Color color})>? hoveredEntries;
        DateTime? hoveredTimestamp;
        double? crosshairX;
        List<({Offset position, Color color})> dots = const [];

        if (_hover != null) {
          crosshairX = _hover!.screenPosition.dx;
          final snappedDataX = (_hover!.xValue as num).toDouble();
          hoveredTimestamp = DateTime.fromMillisecondsSinceEpoch(snappedDataX.round());
          hoveredEntries = _findHoveredEntries(snappedDataX, validSeries);

          // Derive the actual plotHeight from the detected point's screen position.
          // screenY = _kPlotTop + (1 - (value - displayMinY) / yRange) * plotHeight
          // ∴  plotHeight = (screenY - _kPlotTop) / detectedYT
          final yRange = (displayMaxY - displayMinY).toDouble();
          final detectedValue = (_hover!.yValue as num).toDouble();
          final detectedScreenY = _hover!.screenPosition.dy;
          double? actualPlotHeight;
          if (yRange > 0) {
            final detectedYT = 1.0 - (detectedValue - displayMinY) / yRange;
            if (detectedYT.abs() > 0.02) {
              actualPlotHeight = (detectedScreenY - _kPlotTop) / detectedYT;
            }
          }

          dots = hoveredEntries.map((entry) {
            double dotY;
            if (actualPlotHeight != null && yRange > 0) {
              final entryYT = 1.0 - (entry.value - displayMinY) / yRange;
              dotY = _kPlotTop + entryYT * actualPlotHeight;
            } else {
              dotY = detectedScreenY;
            }
            return (position: Offset(crosshairX!, dotY), color: entry.color);
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
              _positionedTooltip(hoveredEntries, hoveredTimestamp, crosshairX, size),
          ],
        );
      },
    );
  }

  Widget _positionedTooltip(
    List<({String name, int value, Color color})> entries,
    DateTime timestamp,
    double crosshairX,
    Size size,
  ) {
    final left = (crosshairX + 12 + _kTooltipWidth > size.width)
        ? crosshairX - _kTooltipWidth - 12
        : crosshairX + 12;

    return Positioned(
      left: left,
      top: _kPlotTop,
      child: IgnorePointer(
        child: TrackballTooltip(
          timestamp: timestamp,
          entries: entries,
        ),
      ),
    );
  }

  List<double> _buildIntegerTicks(int min, int max) {
    final span = max - min;
    if (span <= 0) {
      return [min.toDouble()];
    }
    if (span <= 6) {
      return List.generate(span + 1, (i) => (min + i).toDouble());
    }
    final step = (span / 5).ceil();
    final ticks = <double>[];
    for (int v = min; v <= max; v += step) {
      ticks.add(v.toDouble());
    }
    if (ticks.last != max.toDouble()) {
      ticks.add(max.toDouble());
    }
    return ticks;
  }
}
