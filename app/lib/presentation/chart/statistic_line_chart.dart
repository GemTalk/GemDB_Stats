import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vsd/presentation/_reusable_components/tool_icon_button.dart';
import 'package:vsd/presentation/chart/chart_crosshair.dart';
import 'package:vsd/presentation/chart/chart_utils.dart';
import 'package:vsd/presentation/chart/selection_box_painter.dart';
import 'package:vsd_core/vsd_core.dart';

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
  // Hover x in local pixels. A ValueNotifier (not setState) so a pointer move
  // repaints only the crosshair/tooltip overlay — never rebuilds or repaints
  // the chart, whose Cristalyse paint is O(number of points).
  final ValueNotifier<double?> _mouseX = ValueNotifier(null);

  // Active zoom window in data coordinates; null means "show full range".
  ({double minX, double maxX, double minY, double maxY})? _zoom;

  // Transient drag state for the marquee selection box.
  Offset? _dragStart;
  Offset? _dragCurrent;
  bool _dragging = false;

  @override
  void dispose() {
    _mouseX.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StatisticLineChart old) {
    super.didUpdateWidget(old);
    // Reset zoom when the underlying series changes (different statistic /
    // process / reload). points is identity-stable per TimeSeries instance.
    if (!identical(old.points, widget.points) || old.points.length != widget.points.length) {
      _zoom = null;
    }
  }

  void _onPanEnd(Rect plotRect, double minX, double maxX, double minY, double maxY) {
    final start = _dragStart;
    final current = _dragCurrent;
    Rect? box;
    if (start != null && current != null) {
      box = normalizeDragBox(start, current, plotRect);
    }

    setState(() {
      _dragStart = null;
      _dragCurrent = null;
      _dragging = false;
      if (box == null) {
        return; // click / sliver — not a zoom
      }
      final newMinX = pixelToDataX(box.left, plotRect, minX, maxX);
      final newMaxX = pixelToDataX(box.right, plotRect, minX, maxX);
      // Top pixel = max value, bottom pixel = min value.
      final newMaxY = pixelToDataY(box.top, plotRect, minY, maxY);
      final newMinY = pixelToDataY(box.bottom, plotRect, minY, maxY);

      // Reject a window that contains no data points.
      final hasPoints = widget.points.any((p) {
        final px = p.timestamp.millisecondsSinceEpoch.toDouble();
        return px >= newMinX && px <= newMaxX;
      });
      if (!hasPoints || newMaxX <= newMinX || newMaxY <= newMinY) {
        return;
      }
      _zoom = (minX: newMinX, maxX: newMaxX, minY: newMinY, maxY: newMaxY);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.points.length < 2) {
      return kNotEnoughDataWidget;
    }

    final timeFormatter = DateFormat('HH:mm:ss');

    // Full data-derived bounds (with padding) used when not zoomed.
    final yValues = widget.points.map((p) => p.value).toList();
    final dataMinY = yValues.reduce((a, b) => a < b ? a : b);
    final dataMaxY = yValues.reduce((a, b) => a > b ? a : b);
    final range = dataMaxY - dataMinY;
    final padding = range > 0 ? range * 0.1 : 1.0;
    final fullMinY = (dataMinY >= 0 ? (dataMinY - padding).clamp(0, dataMinY) : dataMinY - padding).toDouble();
    final fullMaxY = (dataMaxY + padding).toDouble();
    final fullMinX = widget.points.first.timestamp.millisecondsSinceEpoch.toDouble();
    final fullMaxX = widget.points.last.timestamp.millisecondsSinceEpoch.toDouble();

    // Active bounds: exact zoom box when zoomed (bypasses padding / clamp).
    final minX = _zoom?.minX ?? fullMinX;
    final maxX = _zoom?.maxX ?? fullMaxX;
    final displayMinY = _zoom?.minY ?? fullMinY;
    final displayMaxY = _zoom?.maxY ?? fullMaxY;

    final yTicks = buildChartTicks(displayMinY, displayMaxY);

    final chartData = List.generate(
      widget.points.length,
      (index) => {
        'x': widget.points[index].timestamp.millisecondsSinceEpoch.toDouble(),
        'y': widget.points[index].value,
      },
    );

    // Sorted timestamps (ms), cached per real build for the O(log n) hover
    // lookup so a pointer move never rescans/re-allocates all points.
    final xsMs = [for (final d in chartData) d['x']!.toDouble()];

    final chart = CristalyseChart()
        .data(chartData)
        .mapping(x: 'x', y: 'y')
        .geomLine(strokeWidth: 1.8, color: const Color(0xFF0078A8))
        .animate(duration: Duration.zero)
        .scaleXContinuous(
          title: 'Timestamp',
          labels: (value) => timeFormatter.format(
            DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true),
          ),
          min: minX,
          max: maxX,
        )
        .scaleYContinuous(
          labels: chartTickFormatter(yTicks),
          min: displayMinY,
          max: displayMaxY,
          tickConfig: TickConfig(ticks: yTicks),
        )
        .build();

    final sampleXLabel = timeFormatter.format(widget.points.last.timestamp);

    return MouseRegion(
      cursor: _dragging ? SystemMouseCursors.precise : SystemMouseCursors.basic,
      onHover: (event) => _mouseX.value = event.localPosition.dx,
      onExit: (_) => _mouseX.value = null,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          final plotRect = computePlotRect(size, yTicks, [], sampleXLabel);

          final selectionBox = (_dragging && _dragStart != null && _dragCurrent != null)
              ? Rect.fromPoints(_dragStart!, _dragCurrent!)
              : null;

          final gestureLayer = GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: _zoom == null ? null : () => setState(() => _zoom = null),
            onPanStart: (details) {
              _dragStart = details.localPosition;
              _dragCurrent = details.localPosition;
            },
            onPanUpdate: (details) => setState(() {
              _dragCurrent = details.localPosition;
              if (!_dragging && (details.localPosition - _dragStart!).distance > kDragThreshold) {
                _dragging = true;
              }
            }),
            onPanEnd: (_) => _onPanEnd(plotRect, minX, maxX, displayMinY, displayMaxY),
            onPanCancel: () => setState(() {
              _dragStart = null;
              _dragCurrent = null;
              _dragging = false;
            }),
            child: Stack(
              children: [
                // The chart paints into its own layer so a hover never triggers
                // its (O(N)) Cristalyse repaint — only the overlay below repaints.
                RepaintBoundary(child: chart),
                // Crosshair + dot + tooltip; repaint on pointer move via the
                // ValueNotifier, isolated in their own layer.
                RepaintBoundary(
                  child: ValueListenableBuilder<double?>(
                    valueListenable: _mouseX,
                    builder: (context, mouseX, _) {
                      if (_dragging || mouseX == null || plotRect.width <= 0) {
                        return const SizedBox.shrink();
                      }
                      final dataX = pixelToDataX(mouseX, plotRect, minX, maxX);
                      final idx = nearestInWindowIndex(xsMs, dataX, minX, maxX);
                      if (idx == null) {
                        return const SizedBox.shrink();
                      }
                      final hoveredPoint = widget.points[idx];
                      final crosshairX = dataXToPixel(xsMs[idx], plotRect, minX, maxX);
                      final yRange = displayMaxY - displayMinY;
                      final dotY = yRange > 0
                          ? plotRect.top + (1.0 - (hoveredPoint.value - displayMinY) / yRange) * plotRect.height
                          : plotRect.top + plotRect.height / 2;
                      return Stack(
                        children: [
                          IgnorePointer(
                            child: SizedBox.fromSize(
                              size: size,
                              child: CustomPaint(
                                painter: CrosshairPainter(
                                  xPosition: crosshairX,
                                  dots: [(position: Offset(crosshairX, dotY), color: const Color(0xFF0078A8))],
                                ),
                              ),
                            ),
                          ),
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
                ),
                if (selectionBox != null)
                  IgnorePointer(
                    child: SizedBox.fromSize(
                      size: size,
                      child: CustomPaint(
                        painter: SelectionBoxPainter(box: selectionBox),
                      ),
                    ),
                  ),
              ],
            ),
          );

          // The reset button is a sibling ABOVE the gesture layer so its tap is
          // handled immediately, not held by the chart's double-tap recognizer.
          return Stack(
            children: [
              gestureLayer,
              if (_zoom != null)
                Positioned(
                  top: 4,
                  right: 4,
                  child: ToolIconButton(
                    icon: FontAwesomeIcons.magnifyingGlassMinus,
                    tooltip: 'Reset zoom',
                    onTap: () => setState(() => _zoom = null),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
