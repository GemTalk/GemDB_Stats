import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vsd/domain/models/time_series.dart';
import 'package:vsd/presentation/chart/chart_crosshair.dart';
import 'package:vsd/presentation/chart/chart_utils.dart';

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
  double? _mouseX;

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
      return kNotEnoughDataWidget;
    }

    final timeFormatter = DateFormat('HH:mm:ss');
    final yValues = widget.points.map((p) => p.value).toList();
    final minY = yValues.reduce((a, b) => a < b ? a : b);
    final maxY = yValues.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    final padding = range > 0 ? range * 0.1 : 1.0;
    final displayMinY = minY >= 0 ? (minY - padding).clamp(0, minY) : minY - padding;
    final displayMaxY = maxY + padding;
    final yTicks = buildChartTicks(displayMinY, displayMaxY);

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
          labels: chartTickFormatter(yTicks),
          min: displayMinY.toDouble(),
          max: displayMaxY.toDouble(),
          tickConfig: TickConfig(ticks: yTicks),
        )
        .build();

    final sampleXLabel = timeFormatter.format(widget.points.last.timestamp);

    return MouseRegion(
      onHover: (event) => setState(() => _mouseX = event.localPosition.dx),
      onExit: (_) => setState(() => _mouseX = null),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          final plotRect = computePlotRect(size, yTicks, [], sampleXLabel);

          double? crosshairX;
          DataPoint? hoveredPoint;
          List<({Offset position, Color color})> dots = const [];

          if (_mouseX != null && plotRect.width > 0) {
            final dataX = minX + (_mouseX! - plotRect.left) / plotRect.width * (maxX - minX);
            hoveredPoint = _nearestPoint(dataX);
            final snappedMs = hoveredPoint.timestamp.millisecondsSinceEpoch.toDouble();
            crosshairX = plotRect.left + (snappedMs - minX) / (maxX - minX) * plotRect.width;
            final yRange = displayMaxY - displayMinY;
            final dotY = yRange > 0
                ? plotRect.top + (1.0 - (hoveredPoint.value - displayMinY) / yRange) * plotRect.height
                : plotRect.top + plotRect.height / 2;
            dots = [(position: Offset(crosshairX, dotY), color: const Color(0xFF0078A8))];
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
              if (hoveredPoint != null && crosshairX != null)
                buildPositionedTooltip(
                  entries: [
                    (
                      name: widget.statisticName,
                      value: hoveredPoint.value,
                      color: const Color(0xFF0078A8),
                    ),
                  ],
                  timestamp: hoveredPoint.timestamp,
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
