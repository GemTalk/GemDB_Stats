import 'package:flutter/material.dart' hide SearchBar;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vsd/domain/models/process.dart';
import 'package:vsd/domain/models/statistic.dart';
import 'package:vsd/presentation/_reusable_components/pulldown_button.dart';
import 'package:vsd/presentation/_reusable_components/search_bar.dart';
import 'package:vsd/presentation/chart/multi_statistic_line_chart.dart';
import 'package:vsd/presentation/statistics_table/tool_icon_button.dart';

class StatisticsTable extends StatefulWidget {
  const StatisticsTable({
    required this.selectedProcess,
    super.key,
    this.onStatisticSelected,
    this.onMultiChartSelectionChanged,
  });

  final Process selectedProcess;
  final void Function(int?)? onStatisticSelected;
  // null = MultiChart mode off; non-null = mode on with primary/secondary index sets
  final void Function(({Set<int> primary, Set<int> secondary})?)? onMultiChartSelectionChanged;

  @override
  State<StatisticsTable> createState() => _StatisticsTableState();
}

class _StatisticsTableState extends State<StatisticsTable> {
  final TextEditingController _searchController = TextEditingController();
  int? selectedIndex;
  int? _hoveredIndex;
  String searchQuery = '';
  bool hideStatisticsWithNoData = false;
  bool _hideStatsSummary = false;
  bool _multiChartMode = false;
  Set<int> _primaryChecked = {};
  Set<int> _secondaryChecked = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StatisticsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedProcess != oldWidget.selectedProcess) {
      selectedIndex = null;
      searchQuery = '';
      _searchController.clear();
      if (_multiChartMode) {
        _multiChartMode = false;
        _primaryChecked = {};
        _secondaryChecked = {};
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            widget.onMultiChartSelectionChanged?.call(null);
          }
        });
      }
    }
  }

  void _fireSelectionChanged() {
    widget.onMultiChartSelectionChanged?.call(
      (primary: Set.from(_primaryChecked), secondary: Set.from(_secondaryChecked)),
    );
  }

  bool _hasData(int statisticIndex) {
    if (statisticIndex >= widget.selectedProcess.type.statistics.length) {
      return false;
    }
    final stat = widget.selectedProcess.type.statistics[statisticIndex];
    final ts = widget.selectedProcess.statisticData[stat.name];
    return ts != null && ts.points.length >= 2;
  }

  /// Color for primary-axis series; null if unchecked or has no data.
  Color? _getPrimarySeriesColor(int statisticIndex) {
    if (!_primaryChecked.contains(statisticIndex)) {
      return null;
    }
    final validList = _primaryChecked.where(_hasData).toList();
    final idx = validList.indexOf(statisticIndex);
    if (idx < 0) {
      return null;
    }
    return kMultiChartPalette[idx % kMultiChartPalette.length];
  }

  /// Color for secondary-axis series; offset past primary valid count.
  Color? _getSecondarySeriesColor(int statisticIndex) {
    if (!_secondaryChecked.contains(statisticIndex)) {
      return null;
    }
    final primaryValidCount = _primaryChecked.where(_hasData).length;
    final validList = _secondaryChecked.where(_hasData).toList();
    final idx = validList.indexOf(statisticIndex);
    if (idx < 0) {
      return null;
    }
    return kMultiChartPalette[(primaryValidCount + idx) % kMultiChartPalette.length];
  }

  @override
  Widget build(BuildContext context) {
    final statistics = widget.selectedProcess.type.statistics;
    final filteredStatistics = statistics.asMap().entries.where((entry) {
      final matchesSearch = searchQuery.isEmpty || entry.value.name.toLowerCase().contains(searchQuery.toLowerCase());
      if (!matchesSearch) {
        return false;
      }

      if (!hideStatisticsWithNoData) {
        return true;
      }

      return widget.selectedProcess.statisticData[entry.value.name]?.hasData ?? false;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: .center,
            spacing: 8,
            children: [
              multiChartButton(),
              Flexible(child: searchBar()),
              threeDotMenu(statistics),
            ],
          ),
        ),
        Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: filteredStatistics.length,
            itemBuilder: (context, index) {
              final statisticEntry = filteredStatistics[index];
              final statisticIndex = statisticEntry.key;
              final statistic = statisticEntry.value;
              final isSelected = selectedIndex == statisticIndex;
              final ts = widget.selectedProcess.statisticData[statistic.name];
              final hasData = ts?.hasData ?? false;
              final minVal = ts?.min;
              final maxVal = ts?.max;
              final avgVal = ts?.average;

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _hoveredIndex = statisticIndex),
                onExit: (_) => setState(() => _hoveredIndex = null),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = statisticIndex;
                    });
                    widget.onStatisticSelected?.call(statisticIndex);
                  },
                  child: Container(
                    height: 25,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    color: isSelected
                        ? const Color(0xFFDCF5FF)
                        : _hoveredIndex == statisticIndex
                        ? Colors.grey.shade100
                        : Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: _multiChartMode
                        ? multiChartModeRow(
                            statisticIndex,
                            statistic,
                            hasData,
                            _hideStatsSummary ? null : minVal,
                            _hideStatsSummary ? null : maxVal,
                            _hideStatsSummary ? null : avgVal,
                          )
                        : singleChartModeRow(
                            statistic,
                            hasData,
                            _hideStatsSummary ? null : minVal,
                            _hideStatsSummary ? null : maxVal,
                            _hideStatsSummary ? null : avgVal,
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatStat(num value) {
    if (value > 99000) {
      return '${value ~/ 1000}k';
    }
    if (value is double) {
      return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
    }
    return value.toString();
  }

  Widget singleChartModeRow(Statistic statistic, bool hasData, int? minVal, int? maxVal, double? avgVal) {
    return Row(
      children: [
        Expanded(
          child: Text(
            statistic.name,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
              fontSize: 13,
              fontWeight: hasData ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        if (hasData && minVal != null && maxVal != null && avgVal != null) ...[
          const SizedBox(width: 8),
          Text(
            'min: ${_formatStat(minVal)}  max: ${_formatStat(maxVal)}  avg: ${_formatStat(avgVal)}',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ],
    );
  }

  Widget multiChartModeRow(
    int statisticIndex,
    Statistic statistic,
    bool hasData,
    int? minVal,
    int? maxVal,
    double? avgVal,
  ) {
    final isPrimary = _primaryChecked.contains(statisticIndex);
    final isSecondary = _secondaryChecked.contains(statisticIndex);
    final primaryColor = _getPrimarySeriesColor(statisticIndex);
    final secondaryColor = _getSecondarySeriesColor(statisticIndex);
    final labelColor = primaryColor ?? secondaryColor;

    return Row(
      children: [
        _axisCheckbox(
          isChecked: isPrimary,
          seriesColor: primaryColor,
          onToggle: () {
            setState(() {
              if (isPrimary) {
                _primaryChecked.remove(statisticIndex);
              } else {
                _primaryChecked.add(statisticIndex);
                _secondaryChecked.remove(statisticIndex);
              }
            });
            _fireSelectionChanged();
          },
        ),
        const SizedBox(width: 4),
        _axisCheckbox(
          isChecked: isSecondary,
          seriesColor: secondaryColor,
          onToggle: () {
            setState(() {
              if (isSecondary) {
                _secondaryChecked.remove(statisticIndex);
              } else {
                _secondaryChecked.add(statisticIndex);
                _primaryChecked.remove(statisticIndex);
              }
            });
            _fireSelectionChanged();
          },
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            statistic.name,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
              fontSize: 13,
              fontWeight: hasData ? FontWeight.bold : FontWeight.normal,
              color: labelColor,
            ),
          ),
        ),
        if (hasData && minVal != null && maxVal != null && avgVal != null) ...[
          const SizedBox(width: 8),
          Text(
            'min: ${_formatStat(minVal)}  max: ${_formatStat(maxVal)}  avg: ${_formatStat(avgVal)}',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ],
    );
  }

  Widget _axisCheckbox({
    required bool isChecked,
    required Color? seriesColor,
    required VoidCallback onToggle,
  }) {
    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: ShadCheckbox(
        value: isChecked,
        onChanged: (_) => onToggle(),
        color: seriesColor,
        size: 14,
        uncheckedColor: Colors.white,
        checkboxPadding: EdgeInsets.zero,
        decoration: ShadDecoration(
          border: ShadBorder.all(
            color: isChecked ? (seriesColor ?? Colors.grey.shade600) : Colors.grey.shade400,
            radius: BorderRadius.circular(4),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget searchBar() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: SearchBar(
        controller: _searchController,
        hintText: 'Search statistics',
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  Widget multiChartButton() {
    return ToolIconButton(
      icon: FontAwesomeIcons.chartLine,
      tooltip: _multiChartMode ? 'Stop MultiChart' : 'Start MultiChart',
      isActive: _multiChartMode,
      onTap: () {
        setState(() {
          _multiChartMode = !_multiChartMode;
          if (_multiChartMode) {
            _primaryChecked = selectedIndex != null ? {selectedIndex!} : {};
            _secondaryChecked = {};
            _fireSelectionChanged();
          } else {
            _primaryChecked = {};
            _secondaryChecked = {};
            widget.onMultiChartSelectionChanged?.call(null);
          }
        });
      },
    );
  }

  Widget threeDotMenu(List<Statistic> statistics) {
    return CustomPulldownButton(
      icon: Icons.more_horiz,
      items: [
        MacosPulldownMenuItem(
          label: 'Show statistics with no data',
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 14,
                child: !hideStatisticsWithNoData ? const Icon(Icons.check, size: 14) : null,
              ),
              const SizedBox(width: 8),
              const Text('Show statistics with no data'),
            ],
          ),
          onTap: () {
            setState(() {
              hideStatisticsWithNoData = !hideStatisticsWithNoData;

              if (hideStatisticsWithNoData && selectedIndex != null) {
                final selectedStatistic = statistics[selectedIndex!];
                final selectedHasData = widget.selectedProcess.statisticData[selectedStatistic.name]?.hasData ?? false;
                if (!selectedHasData) {
                  selectedIndex = null;
                  widget.onStatisticSelected?.call(null);
                }
              }
            });
          },
        ),
        MacosPulldownMenuItem(
          label: 'Show statistics summary',
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 14,
                child: !_hideStatsSummary ? const Icon(Icons.check, size: 14) : null,
              ),
              const SizedBox(width: 8),
              const Text('Show statistics summary'),
            ],
          ),
          onTap: () {
            setState(() {
              _hideStatsSummary = !_hideStatsSummary;
            });
          },
        ),
      ],
    );
  }
}
