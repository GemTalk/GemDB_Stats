import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vsd/domain/models/time_series.dart';

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

class MultiStatisticLineChart extends StatelessWidget {
  const MultiStatisticLineChart({required this.series, super.key});

  final List<({String name, List<DataPoint> points})> series;

  @override
  Widget build(BuildContext context) {
    final validSeries = series.where((s) => s.points.length >= 2).toList();

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
    final displayMinY = minY >= 0 ? 0 : minY - padding;
    final displayMaxY = maxY + padding;
    final yTicks = _buildIntegerTicks(displayMinY, displayMaxY);

    final allX = allData.map((d) => d['x'] as double).toList();
    final minX = allX.reduce((a, b) => a < b ? a : b);
    final maxX = allX.reduce((a, b) => a > b ? a : b);

    return CristalyseChart()
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
        .build();
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
