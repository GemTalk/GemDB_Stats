import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
/// Thousand separators (commas) are always included.
String Function(num) chartTickFormatter(List<double> ticks) {
  if (ticks.length < 2) {
    return (v) => NumberFormat('#,##0').format(v.round());
  }
  final step = (ticks[1] - ticks[0]).abs();
  if (step >= 1) {
    return (v) => NumberFormat('#,##0').format(v.round());
  }
  final decimals = (-math.log(step) / math.ln10).ceil().clamp(1, 4);
  final fmt = NumberFormat('#,##0.${'0' * decimals}');
  return (v) => fmt.format(v);
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

/// Replicates Cristalyse's internal plot-area layout so CustomPaint overlays
/// align pixel-perfectly with the chart canvas.
///
/// Pass [secondaryTicks] as an empty list for single-axis charts.
Rect computePlotRect(
  Size size,
  List<double> primaryTicks,
  List<double> secondaryTicks,
  String sampleXLabel,
) {
  double maxLabelW(List<double> ticks) {
    if (ticks.isEmpty) {
      return 0.0;
    }
    final fmt = chartTickFormatter(ticks);
    var w = 0.0;
    for (final t in ticks) {
      final tp = TextPainter(
        text: TextSpan(text: fmt(t), style: const TextStyle(fontSize: 12)),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      w = math.max(w, tp.width);
    }
    return w;
  }

  final xTp = TextPainter(
    text: TextSpan(text: sampleXLabel, style: const TextStyle(fontSize: 12)),
    textDirection: ui.TextDirection.ltr,
  )..layout();

  const base = 8.0;   // theme.padding
  const axisW = 2.0;  // axisWidth * 2 (tick extent)
  const tickG = 4.0;  // tickToLabelSpacing
  const l2t = 8.0;    // _labelToTitleSpacing
  const tfs = 13.0;   // title font size (axisLabelStyle.fontSize + 1)

  final leftPad = base + axisW + tickG + maxLabelW(primaryTicks);
  // Single-axis: right side has no secondary axis, only base padding.
  final rightPad = secondaryTicks.isEmpty
      ? base
      : base + axisW + tickG + maxLabelW(secondaryTicks);
  final bottomPad = base + axisW + tickG + xTp.height + l2t + tfs;

  return Rect.fromLTWH(
    leftPad,
    kChartPlotTop,
    size.width - leftPad - rightPad,
    size.height - kChartPlotTop - bottomPad,
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
