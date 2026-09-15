import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vsd/presentation/chart/trackball_tooltip.dart';
import 'package:vsd_core/vsd_core.dart';

/// X-axis title for the tick-label zone.
/// Kept here so paint-time label widening cannot misalign the plot rectangle.
String xAxisTitle(DateTime instant) => 'Timestamp (${DisplayTime.abbreviationAt(instant)})';

const double kChartPlotTop = 16.0;
const double kChartTooltipWidth = 280.0;

/// Pointer travel (logical px) before a pan is treated as a zoom drag rather
/// than a click, so accidental clicks don't trigger a zoom.
const double kDragThreshold = 8.0;

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
  final niceStep =
      (normalized <= 1.5
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

  const base = 8.0; // theme.padding
  const axisW = 2.0; // axisWidth * 2 (tick extent)
  const tickG = 4.0; // tickToLabelSpacing
  const l2t = 8.0; // _labelToTitleSpacing
  const tfs = 13.0; // title font size (axisLabelStyle.fontSize + 1)

  final leftPad = base + axisW + tickG + maxLabelW(primaryTicks);
  // Single-axis: right side has no secondary axis, only base padding.
  final rightPad = secondaryTicks.isEmpty ? base : base + axisW + tickG + maxLabelW(secondaryTicks);
  final bottomPad = base + axisW + tickG + xTp.height + l2t + tfs;

  return Rect.fromLTWH(
    leftPad,
    kChartPlotTop,
    size.width - leftPad - rightPad,
    size.height - kChartPlotTop - bottomPad,
  );
}

/// Converts a horizontal pixel position to a data-x value, the inverse of the
/// data→pixel mapping used to draw the chart. [minX]/[maxX] are the currently
/// displayed x bounds (zoomed or full).
double pixelToDataX(double px, Rect plot, double minX, double maxX) {
  if (plot.width <= 0) {
    return minX;
  }
  return minX + (px - plot.left) / plot.width * (maxX - minX);
}

/// Converts a vertical pixel position to a data-y value. Pixels grow downward,
/// so the top of the plot maps to [maxY] and the bottom to [minY].
double pixelToDataY(double py, Rect plot, double minY, double maxY) {
  if (plot.height <= 0) {
    return minY;
  }
  return minY + (1.0 - (py - plot.top) / plot.height) * (maxY - minY);
}

/// Converts a data-x value to its horizontal pixel position — the forward of
/// [pixelToDataX], used to place crosshair/dot overlays on the chart.
///
/// When the x range is degenerate ([maxX] == [minX] — every visible sample
/// shares one timestamp, e.g. a capture spanning under a second, since sample
/// times have 1-second resolution) there is no meaningful horizontal position,
/// so the plot's horizontal center is returned rather than dividing 0/0 into a
/// NaN that would crash CustomPaint.
double dataXToPixel(double dataX, Rect plot, double minX, double maxX) {
  final range = maxX - minX;
  if (range <= 0) {
    return plot.left + plot.width / 2;
  }
  return plot.left + (dataX - minX) / range * plot.width;
}

/// Index of the in-window point whose timestamp (ms) is nearest [targetMs], or
/// null if no point lies within `[minX, maxX]`.
///
/// [xs] must be sorted ascending (true for `TimeSeries.points`, appended in
/// chronological order). Runs in O(log n): the nearest value to a target in a
/// sorted array is always one of the two neighbors of the lower bound, so only
/// those are checked. The in-window guard reproduces the existing "only snap to
/// points inside the visible window" behavior; ties resolve to the earlier index.
int? nearestInWindowIndex(List<double> xs, double targetMs, double minX, double maxX) {
  if (xs.isEmpty) {
    return null;
  }
  var lo = 0;
  var hi = xs.length;
  while (lo < hi) {
    final mid = (lo + hi) >> 1;
    if (xs[mid] < targetMs) {
      lo = mid + 1;
    } else {
      hi = mid;
    }
  }
  int? best;
  var bestDist = double.infinity;
  for (final i in [lo - 1, lo]) {
    if (i < 0 || i >= xs.length) {
      continue;
    }
    final x = xs[i];
    if (x < minX || x > maxX) {
      continue;
    }
    final d = (x - targetMs).abs();
    if (d < bestDist) {
      bestDist = d;
      best = i;
    }
  }
  return best;
}

/// Normalizes a drag from [a] to [b] into an axis-aligned rectangle clamped to
/// [plot]. Returns null when either side is shorter than [minPx] — the gesture
/// was a click or an accidental sliver, not a zoom box. Normalizing handles
/// right-to-left and bottom-to-top drags; clamping keeps the box inside the
/// plot so the resulting data bounds never invert (cristalyse throws when
/// min > max).
Rect? normalizeDragBox(Offset a, Offset b, Rect plot, {double minPx = 12}) {
  final left = a.dx < b.dx ? a.dx : b.dx;
  final right = a.dx < b.dx ? b.dx : a.dx;
  final top = a.dy < b.dy ? a.dy : b.dy;
  final bottom = a.dy < b.dy ? b.dy : a.dy;

  final clamped = Rect.fromLTRB(
    left.clamp(plot.left, plot.right),
    top.clamp(plot.top, plot.bottom),
    right.clamp(plot.left, plot.right),
    bottom.clamp(plot.top, plot.bottom),
  );

  if (clamped.width < minPx || clamped.height < minPx) {
    return null;
  }
  return clamped;
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
