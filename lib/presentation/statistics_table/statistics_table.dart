import 'package:flutter/material.dart' hide SearchBar;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluto_grid/pluto_grid.dart';
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
  PlutoGridStateManager? _stateManager;
  final TextEditingController _searchController = TextEditingController();
  int? selectedIndex;
  int? _hoveredRowIndex;
  String searchQuery = '';
  bool hideStatisticsWithNoData = false;
  bool _hideStatsSummary = false;
  bool _multiChartMode = false;
  Set<int> _primaryChecked = {};
  Set<int> _secondaryChecked = {};

  late final List<PlutoColumn> _columns;

  @override
  void initState() {
    super.initState();
    _columns = [
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
        enableColumnDrag: false,
        enableContextMenu: false,
        renderer: _nameRenderer,
      ),
      PlutoColumn(
        title: 'Units',
        field: 'units',
        type: PlutoColumnType.text(),
        enableColumnDrag: false,
        enableContextMenu: false,
        width: 90,
      ),
      PlutoColumn(
        title: 'Min',
        field: 'min',
        type: PlutoColumnType.text(),
        enableColumnDrag: false,
        enableContextMenu: false,
        width: 90,
        textAlign: PlutoColumnTextAlign.right,
      ),
      PlutoColumn(
        title: 'Max',
        field: 'max',
        type: PlutoColumnType.text(),
        enableColumnDrag: false,
        enableContextMenu: false,
        width: 90,
        textAlign: PlutoColumnTextAlign.right,
      ),
      PlutoColumn(
        title: 'Avg',
        field: 'avg',
        type: PlutoColumnType.text(),
        enableColumnDrag: false,
        enableContextMenu: false,
        width: 90,
        textAlign: PlutoColumnTextAlign.right,
      ),
    ];
  }

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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updateGridRows();
        }
      });
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

  Widget _nameRenderer(PlutoColumnRendererContext ctx) {
    final statIdx = ctx.row.cells['statIdx']!.value as int;
    final statistics = widget.selectedProcess.type.statistics;
    if (statIdx >= statistics.length) {
      return const SizedBox();
    }
    final statistic = statistics[statIdx];
    final ts = widget.selectedProcess.statisticData[statistic.name];
    final hasData = ts?.hasData ?? false;

    if (_multiChartMode) {
      final isPrimary = _primaryChecked.contains(statIdx);
      final isSecondary = _secondaryChecked.contains(statIdx);
      final primaryColor = _getPrimarySeriesColor(statIdx);
      final secondaryColor = _getSecondarySeriesColor(statIdx);
      final labelColor = primaryColor ?? secondaryColor;

      return Row(
        children: [
          _axisCheckbox(
            isChecked: isPrimary,
            seriesColor: primaryColor,
            onToggle: () {
              setState(() {
                if (isPrimary) {
                  _primaryChecked.remove(statIdx);
                } else {
                  _primaryChecked.add(statIdx);
                  _secondaryChecked.remove(statIdx);
                }
              });
              _fireSelectionChanged();
              _updateGridRows();
            },
          ),
          const SizedBox(width: 4),
          _axisCheckbox(
            isChecked: isSecondary,
            seriesColor: secondaryColor,
            onToggle: () {
              setState(() {
                if (isSecondary) {
                  _secondaryChecked.remove(statIdx);
                } else {
                  _secondaryChecked.add(statIdx);
                  _primaryChecked.remove(statIdx);
                }
              });
              _fireSelectionChanged();
              _updateGridRows();
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
        ],
      );
    }

    return Text(
      statistic.name,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      style: TextStyle(
        fontSize: 13,
        fontWeight: hasData ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  List<PlutoRow> _buildRows() {
    final statistics = widget.selectedProcess.type.statistics;
    return statistics.asMap().entries.where((entry) {
      final matchesSearch = searchQuery.isEmpty || entry.value.name.toLowerCase().contains(searchQuery.toLowerCase());
      if (!matchesSearch) {
        return false;
      }
      if (!hideStatisticsWithNoData) {
        return true;
      }
      return widget.selectedProcess.statisticData[entry.value.name]?.hasData ?? false;
    }).map((entry) {
      final statisticIndex = entry.key;
      final statistic = entry.value;
      final ts = widget.selectedProcess.statisticData[statistic.name];
      final hasData = ts?.hasData ?? false;
      final minVal = ts?.min;
      final maxVal = ts?.max;
      final avgVal = ts?.average;

      return PlutoRow(
        cells: {
          'statIdx': PlutoCell(value: statisticIndex),
          'name': PlutoCell(value: statistic.name),
          'units': PlutoCell(value: statistic.units),
          'min': PlutoCell(value: (hasData && !_hideStatsSummary && minVal != null) ? _formatStat(minVal) : ''),
          'max': PlutoCell(value: (hasData && !_hideStatsSummary && maxVal != null) ? _formatStat(maxVal) : ''),
          'avg': PlutoCell(value: (hasData && !_hideStatsSummary && avgVal != null) ? _formatStat(avgVal) : ''),
        },
      );
    }).toList();
  }

  void _updateGridRows() {
    if (_stateManager == null) {
      return;
    }
    _stateManager!.removeAllRows();
    final newRows = _buildRows();
    if (newRows.isNotEmpty) {
      _stateManager!.appendRows(newRows);
    }
    _stateManager!.clearCurrentCell();
    _stateManager!.clearCurrentSelecting();
  }

  @override
  Widget build(BuildContext context) {
    final statistics = widget.selectedProcess.type.statistics;

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
          child: MouseRegion(
            onHover: (event) {
              final scrollOffset = _stateManager?.scroll.vertical?.offset ?? 0;
              final adjustedY = event.localPosition.dy - 30 + scrollOffset;
              final rowIdx = adjustedY < 0 ? null : (adjustedY / 25).floor();
              if (rowIdx != _hoveredRowIndex) {
                setState(() => _hoveredRowIndex = rowIdx);
              }
            },
            onExit: (_) {
              if (_hoveredRowIndex != null) {
                setState(() => _hoveredRowIndex = null);
              }
            },
            child: PlutoGrid(
              columns: _columns,
              rows: _buildRows(),
              mode: PlutoGridMode.selectWithOneTap,
              rowColorCallback: (ctx) {
                final statIdx = ctx.row.cells['statIdx']?.value as int?;
                if (statIdx == selectedIndex) {
                  return const Color(0xFFDCF5FF);
                }
                if (ctx.rowIdx == _hoveredRowIndex) {
                  return Colors.grey.shade100;
                }
                return Colors.white;
              },
              configuration: PlutoGridConfiguration(
                style: PlutoGridStyleConfig(
                  rowHeight: 25,
                  columnHeight: 30,
                  cellTextStyle: const TextStyle(fontSize: 13),
                  columnTextStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  enableCellBorderHorizontal: false,
                  enableCellBorderVertical: false,
                  activatedBorderColor: Colors.transparent,
                  gridBorderColor: Colors.transparent,
                  iconSize: 0,
                ),
                columnSize: const PlutoGridColumnSizeConfig(resizeMode: PlutoResizeMode.normal),
                enterKeyAction: PlutoGridEnterKeyAction.toggleEditing,
                tabKeyAction: PlutoGridTabKeyAction.normal,
                enableMoveDownAfterSelecting: true,
                enableMoveHorizontalInEditing: false,
              ),
              onLoaded: (PlutoGridOnLoadedEvent event) {
                _stateManager = event.stateManager;
                event.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                event.stateManager.setEditing(false);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  event.stateManager.clearCurrentCell();
                  event.stateManager.clearCurrentSelecting();
                });
              },
              onSelected: (PlutoGridOnSelectedEvent event) {
                if (event.row == null) {
                  return;
                }
                final statIdx = event.row!.cells['statIdx']!.value as int;
                setState(() => selectedIndex = statIdx);
                widget.onStatisticSelected?.call(statIdx);
                _stateManager?.clearCurrentCell();
                _stateManager?.clearCurrentSelecting();
              },
            ),
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
          _updateGridRows();
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
        _updateGridRows();
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
            _updateGridRows();
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
            _updateGridRows();
          },
        ),
      ],
    );
  }
}
