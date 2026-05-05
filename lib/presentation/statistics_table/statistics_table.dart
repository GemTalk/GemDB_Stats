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
  // null = MultiChart mode off; Set<int> = MultiChart mode on with checked indices
  final void Function(Set<int>?)? onMultiChartSelectionChanged;

  @override
  State<StatisticsTable> createState() => _StatisticsTableState();
}

class _StatisticsTableState extends State<StatisticsTable> {
  final TextEditingController _searchController = TextEditingController();
  int? selectedIndex;
  int? _hoveredIndex;
  String searchQuery = '';
  bool hideStatisticsWithNoData = false;
  bool _multiChartMode = false;
  Set<int> _multiChartChecked = {};

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
        _multiChartChecked = {};
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            widget.onMultiChartSelectionChanged?.call(null);
          }
        });
      }
    }
  }

  /// Returns the chart color for a checked statistic, or null if unchecked/no data.
  /// Color index matches Cristalyse's assignment order (position among valid series).
  Color? _getSeriesColor(int statisticIndex) {
    if (!_multiChartChecked.contains(statisticIndex)) {
      return null;
    }
    final checkedWithData = _multiChartChecked.where((i) {
      if (i >= widget.selectedProcess.type.statistics.length) {
        return false;
      }
      final stat = widget.selectedProcess.type.statistics[i];
      final ts = widget.selectedProcess.statisticData[stat.name];
      return ts != null && ts.points.length >= 2;
    }).toList();
    final colorIndex = checkedWithData.indexOf(statisticIndex);
    if (colorIndex < 0) {
      return null;
    }
    return kMultiChartPalette[colorIndex % kMultiChartPalette.length];
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
              final hasData = widget.selectedProcess.statisticData[statistic.name]?.hasData ?? false;
              final isChecked = _multiChartChecked.contains(statisticIndex);
              final seriesColor = _multiChartMode ? _getSeriesColor(statisticIndex) : null;

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _hoveredIndex = statisticIndex),
                onExit: (_) => setState(() => _hoveredIndex = null),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = statisticIndex;
                      if (_multiChartMode) {
                        if (isChecked) {
                          _multiChartChecked.remove(statisticIndex);
                        } else {
                          _multiChartChecked.add(statisticIndex);
                        }
                        widget.onMultiChartSelectionChanged?.call(Set.from(_multiChartChecked));
                      }
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
                        ? multiChartModeRow(isChecked, seriesColor, statistic, hasData)
                        : singleChartModeRow(statistic, hasData),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget singleChartModeRow(Statistic statistic, bool hasData) {
    return Text(
      statistic.name,
      style: TextStyle(
        fontSize: 13,
        fontWeight: hasData ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget multiChartModeRow(bool isChecked, Color? seriesColor, Statistic statistic, bool hasData) {
    return Row(
      spacing: 6,
      children: [
        IgnorePointer(
          child: ShadCheckbox(
            value: isChecked,
            onChanged: (_) {},
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
        ),
        Text(
          statistic.name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: hasData ? FontWeight.bold : FontWeight.normal,
            color: seriesColor,
          ),
        ),
      ],
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
            _multiChartChecked = selectedIndex != null ? {selectedIndex!} : {};
            widget.onMultiChartSelectionChanged?.call(Set.from(_multiChartChecked));
          } else {
            _multiChartChecked = {};
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
          label: 'Hide statistics with no data',
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 14,
                child: hideStatisticsWithNoData ? const Icon(Icons.check, size: 14) : null,
              ),
              const SizedBox(width: 8),
              const Text('Hide statistics with no data'),
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
      ],
    );
  }
}
