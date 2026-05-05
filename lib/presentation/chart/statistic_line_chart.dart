import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vsd/domain/models/time_series.dart';
import 'package:vsd/presentation/chart/chart_crosshair.dart';
import 'package:vsd/presentation/chart/trackball_tooltip.dart';

// theme.padding.top is a constant 16px — used for tooltip vertical positioning only.
const double _kPlotTop = 16.0;
const double _kTooltipWidth = 170.0;

class StatisticLineChart extends StatefulWidget {
  const StatisticLineChart({
    required this.points,
    required this.statisticName,
    super.key,
  });

  final List<DataPoint> points;
  final String statisticName;

  @override
  State<StatisticLineChart> createState() => _StatisticLineChartState();
}

class _StatisticLineChartState extends State<StatisticLineChart> {
  // Populated by Cristalyse's own HoverConfig — screenPosition is computed
  // from the painter's actual plotArea, not our estimated constants.
  DataPointInfo? _hover;

  DataPoint _nearestPoint(double dataX) {
    return widget.points.reduce((a, b) {
      final aDist = (a.timestamp.millisecondsSinceEpoch.toDouble() - dataX).abs();
      final bDist = (b.timestamp.millisecondsSinceEpoch.toDouble() - dataX).abs();
      return aDist <= bDist ? a : b;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.points.length < 2) {
      return const Center(
        child: Text(
          'Not enough data',
          style: TextStyle(fontSize: 12, color: Colors.black45),
        ),
      );
    }

    final timeFormatter = DateFormat('HH:mm:ss');
    final yValues = widget.points.map((p) => p.value).toList();
    final minY = yValues.reduce((a, b) => a < b ? a : b);
    final maxY = yValues.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    final computedPadding = (range * 0.1).ceil();
    final padding = computedPadding < 2 ? 2 : computedPadding;
    final displayMinY = minY >= 0 ? (minY - padding).clamp(0, minY) : minY - padding;
    final displayMaxY = maxY + padding;
    final yTicks = _buildIntegerTicks(displayMinY, displayMaxY);

    final minX = widget.points.first.timestamp.millisecondsSinceEpoch.toDouble();
    final maxX = widget.points.last.timestamp.millisecondsSinceEpoch.toDouble();

    final chartData = List.generate(
      widget.points.length,
      (index) => {
        'x': widget.points[index].timestamp.millisecondsSinceEpoch.toDouble(),
        'y': widget.points[index].value,
      },
    );

    final chart = CristalyseChart()
        .data(chartData)
        .mapping(x: 'x', y: 'y')
        .geomLine(strokeWidth: 1.8, color: const Color(0xFF0078A8))
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
            // Large radius so a point is always found while hovering.
            hitTestRadius: 10000,
            onHover: (p) => setState(() => _hover = p),
            onExit: (_) => setState(() => _hover = null),
          ),
        )
        .build();

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final crosshairX = _hover?.screenPosition.dx;

        // screenPosition comes from Cristalyse's painter - it's on the actual line.
        final dots = _hover != null
            ? <({Offset position, Color color})>[
                (position: _hover!.screenPosition, color: const Color(0xFF0078A8)),
              ]
            : const <({Offset position, Color color})>[];

        final hoveredPoint = _hover != null
            ? _nearestPoint((_hover!.xValue as num).toDouble())
            : null;

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
            if (hoveredPoint != null && crosshairX != null)
              _positionedTooltip(hoveredPoint, crosshairX, size),
          ],
        );
      },
    );
  }

  Widget _positionedTooltip(DataPoint point, double crosshairX, Size size) {
    final left = (crosshairX + 12 + _kTooltipWidth > size.width)
        ? crosshairX - _kTooltipWidth - 12
        : crosshairX + 12;

    return Positioned(
      left: left,
      top: _kPlotTop,
      child: IgnorePointer(
        child: TrackballTooltip(
          timestamp: point.timestamp,
          entries: [
            (
              name: widget.statisticName,
              value: point.value,
              color: const Color(0xFF0078A8),
            ),
          ],
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
      return List.generate(span + 1, (index) => (min + index).toDouble());
    }
    final step = (span / 5).ceil();
    final ticks = <double>[];
    for (int value = min; value <= max; value += step) {
      ticks.add(value.toDouble());
    }
    if (ticks.last != max.toDouble()) {
      ticks.add(max.toDouble());
    }
    return ticks;
  }
}
