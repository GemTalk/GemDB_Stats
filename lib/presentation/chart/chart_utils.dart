import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vsd/presentation/chart/trackball_tooltip.dart';

const double kChartPlotTop = 16.0;
const double kChartTooltipWidth = 170.0;

const Widget kNotEnoughDataWidget = Center(
  child: Text(
    'Not enough data',
    style: TextStyle(fontSize: 12, color: Colors.black45),
  ),
);

/// Returns a label formatter matched to [ticks].
/// Uses integers when the step is ≥ 1; otherwise uses enough decimal
/// places to distinguish adjacent ticks.
String Function(num) chartTickFormatter(List<double> ticks) {
  if (ticks.length < 2) {
    return (v) => v.round().toString();
  }
  final step = (ticks[1] - ticks[0]).abs();
  if (step >= 1) {
    return (v) => v.round().toString();
  }
  final decimals = (-math.log(step) / math.ln10).ceil().clamp(1, 4);
  return (v) => v.toStringAsFixed(decimals);
}

/// Generates nicely spaced tick marks for any numeric range — works for
/// both integer statistics and decimal float statistics.
List<double> buildChartTicks(num min, num max) {
  final span = max - min;
  if (span <= 0) {
    return [min.toDouble()];
  }

  final rawStep = span / 5;
  final magnitude = math.pow(10, (math.log(rawStep) / math.ln10).floor());
  final normalized = rawStep / magnitude;
  final niceStep = (normalized <= 1.5
          ? 1
          : normalized <= 3.5
              ? 2
              : normalized <= 7.5
                  ? 5
                  : 10) *
      magnitude;

  final firstTick = (min / niceStep).ceil() * niceStep;
  final count = ((max - firstTick) / niceStep).floor() + 1;
  if (count <= 0) {
    return [min.toDouble()];
  }
  return List.generate(
    count.clamp(1, 20),
    (i) => (firstTick + i * niceStep).toDouble(),
  );
}

/// Positions a [TrackballTooltip] to the right of [crosshairX], flipping
/// left when it would overflow [size].
Widget buildPositionedTooltip({
  required List<({String name, num value, Color color})> entries,
  required DateTime timestamp,
  required double crosshairX,
  required Size size,
}) {
  final left = (crosshairX + 12 + kChartTooltipWidth > size.width)
      ? crosshairX - kChartTooltipWidth - 12
      : crosshairX + 12;

  return Positioned(
    left: left,
    top: kChartPlotTop,
    child: IgnorePointer(
      child: TrackballTooltip(
        timestamp: timestamp,
        entries: entries,
      ),
    ),
  );
}
