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
    final padding = range == 0 ? (maxY.abs() * 0.02).clamp(0.001, 1.0) : range * 0.1;

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
          min: minY - padding,
          max: maxY + padding,
        )
        .build();
  }
}
