import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vsd/domain/models/time_series.dart';

class StatisticLineChart extends StatelessWidget {
  const StatisticLineChart({required this.points, super.key});

  final List<DataPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return const Center(
        child: Text(
          'Not enough data',
          style: TextStyle(fontSize: 12, color: Colors.black45),
        ),
      );
    }

    final timeFormatter = DateFormat('HH:mm:ss');
    final yValues = points.map((p) => p.value).toList();
    final minY = yValues.reduce((a, b) => a < b ? a : b);
    final maxY = yValues.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    final computedPadding = (range * 0.1).ceil();
    final padding = computedPadding < 2 ? 2 : computedPadding;
    final displayMinY = minY >= 0 ? (minY - padding).clamp(0, minY) : minY - padding;
    final displayMaxY = maxY + padding;
    final yTicks = _buildIntegerTicks(displayMinY, displayMaxY);

    final chartData = List.generate(
      points.length,
      (index) => {
        'x': points[index].timestamp.millisecondsSinceEpoch.toDouble(),
        'y': points[index].value,
      },
    );

    return CristalyseChart()
        .data(chartData)
        .mapping(x: 'x', y: 'y')
        .geomLine(strokeWidth: 1.8, color: const Color(0xFF0078A8))
        .animate(duration: Duration.zero)
        .scaleXContinuous(
          title: 'Timestamp',
          labels: (value) => timeFormatter.format(
            DateTime.fromMillisecondsSinceEpoch(value.toInt()),
          ),
          min: points.first.timestamp.millisecondsSinceEpoch.toDouble(),
          max: points.last.timestamp.millisecondsSinceEpoch.toDouble(),
        )
        .scaleYContinuous(
          labels: (value) => value.round().toString(),
          min: displayMinY.toDouble(),
          max: displayMaxY.toDouble(),
          tickConfig: TickConfig(ticks: yTicks),
        )
        .build();
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
