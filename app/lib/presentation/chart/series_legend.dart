import 'package:flutter/material.dart';
import 'package:vsd/presentation/chart/multi_chart_controller.dart';
import 'package:vsd_core/vsd_core.dart';

/// Lists every series currently charted, grouped by process.
///
/// This is what makes a cross-process selection workable: once the process
/// table has moved on, the statistics table no longer shows the checkboxes for
/// series belonging to earlier processes, so this panel is the only place they
/// can be seen, moved between axes, or removed.
class SeriesLegend extends StatelessWidget {
  const SeriesLegend({required this.controller, super.key});

  final MultiChartController controller;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final refs = controller.all;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(refs.length),
              const Divider(height: 1),
              Expanded(
                child: refs.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'No series charted.\nTick statistics to add them.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.black45),
                          ),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.only(bottom: 8),
                        children: _groupedRows(refs),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _header(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Series',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          if (count > 0)
            _TextButton(
              label: 'Clear',
              tooltip: 'Remove all series',
              onTap: controller.clear,
            ),
        ],
      ),
    );
  }

  /// One subheading per process, in the order each process first contributed a
  /// series, with that process's series beneath it.
  List<Widget> _groupedRows(List<SeriesRef> refs) {
    final byProcess = <String, List<SeriesRef>>{};
    final processes = <String, Process>{};
    for (final ref in refs) {
      final key = ref.process.identityKey;
      processes[key] = ref.process;
      (byProcess[key] ??= []).add(ref);
    }

    return [
      for (final entry in byProcess.entries) ...[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
          child: Text(
            processes[entry.key]!.displayLabel,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        for (final ref in entry.value) _SeriesRow(controller: controller, seriesRef: ref),
      ],
    ];
  }
}

class _SeriesRow extends StatelessWidget {
  const _SeriesRow({required this.controller, required this.seriesRef});

  final MultiChartController controller;
  final SeriesRef seriesRef;

  @override
  Widget build(BuildContext context) {
    final color = controller.colorFor(seriesRef);
    final onSecondary = controller.isSecondary(seriesRef);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 1, 4, 1),
      child: Row(
        children: [
          // A null color means the series has fewer than two samples, so no
          // line is drawn. Show it hollow rather than hiding it, so it is clear
          // why the chart looks emptier than the selection.
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color ?? Colors.transparent,
              border: color == null ? Border.all(color: Colors.black26) : null,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Tooltip(
              message: seriesRef.isValid
                  ? (color == null
                        ? '${seriesRef.statistic.name} — not enough data to chart'
                        : seriesRef.statistic.name)
                  : '',
              child: Text(
                seriesRef.isValid ? seriesRef.statistic.name : '',
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontSize: 12,
                  color: color == null ? Colors.black38 : Colors.black87,
                ),
              ),
            ),
          ),
          _TextButton(
            label: onSecondary ? 'R' : 'L',
            tooltip: onSecondary ? 'On the right axis — move to left' : 'On the left axis — move to right',
            onTap: () => onSecondary ? controller.togglePrimary(seriesRef) : controller.toggleSecondary(seriesRef),
          ),
          _TextButton(
            label: '×',
            tooltip: 'Remove series',
            onTap: () => controller.remove(seriesRef),
          ),
        ],
      ),
    );
  }
}

/// A compact text affordance sized for the legend rows. [ToolIconButton] is
/// 28x28 with a FontAwesome glyph, too heavy to sit two-per-row here.
class _TextButton extends StatefulWidget {
  const _TextButton({required this.label, required this.tooltip, required this.onTap});

  final String label;
  final String tooltip;
  final VoidCallback onTap;

  @override
  State<_TextButton> createState() => _TextButtonState();
}

class _TextButtonState extends State<_TextButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            constraints: const BoxConstraints(minWidth: 20),
            height: 20,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _hovered ? const Color(0xfff4f5f5) : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _hovered ? Colors.black87 : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
