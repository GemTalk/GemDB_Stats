import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:vsd/presentation/_reusable_components/case_insensitive_text_type.dart';
import 'package:vsd/presentation/_reusable_components/search_bar.dart';
import 'package:vsd_core/vsd_core.dart';

class ProcessTable extends StatefulWidget {
  const ProcessTable({
    super.key,
    this.onProcessSelected,
    this.showYearAndZone = true,
    this.displayZone = const DisplayZone.file(),
  });

  final void Function(Process?)? onProcessSelected;
  final bool showYearAndZone;
  final DisplayZone displayZone;

  @override
  State<ProcessTable> createState() => _ProcessTableState();
}

class _ProcessTableState extends State<ProcessTable> {
  PlutoGridStateManager? _stateManager;
  String? selectedProcessSelectionKey;
  int? _hoveredRowIndex;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  late List<PlutoColumn> columns;
  late DateFormat _dateFormat;
  late final List<Process> _allProcesses;
  List<PlutoRow> _rows = const [];
  // Tracks whether the cursor is over a data row, so the click/basic cursor can
  // update without rebuilding the grid on every hover frame.
  final ValueNotifier<bool> _overRow = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    final timeWidth = widget.showYearAndZone ? 158.0 : 124.0;
    columns = [
      PlutoColumn(
        title: _timeColumnTitle('Start Time'),
        field: 'startTime',
        type: PlutoColumnType.text(),
        enableColumnDrag: false,
        enableContextMenu: false,
        width: timeWidth,
      ),
      PlutoColumn(
        title: _timeColumnTitle('End Time'),
        field: 'endTime',
        type: PlutoColumnType.text(),
        enableColumnDrag: false,
        enableContextMenu: false,
        width: timeWidth,
      ),
      PlutoColumn(
        title: 'Samples',
        field: 'samples',
        type: PlutoColumnType.text(),
        enableColumnDrag: false,
        enableContextMenu: false,
        width: 85,
      ),
      PlutoColumn(
        title: 'Process ID',
        field: 'processId',
        type: PlutoColumnType.text(),
        enableColumnDrag: false,
        enableContextMenu: false,
        width: 100,
      ),
      PlutoColumn(
        title: 'Session ID',
        field: 'sessionId',
        type: PlutoColumnType.text(),
        enableColumnDrag: false,
        enableContextMenu: false,
        width: 110,
      ),
      PlutoColumn(
        title: 'Type',
        field: 'type',
        type: CaseInsensitiveTextType(),
        enableColumnDrag: false,
        enableContextMenu: false,
        width: 140,
      ),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
        enableColumnDrag: false,
        enableContextMenu: false,
      ),
    ];
    // Built once; zone changes are reapplied in didUpdateWidget so the user's
    // search, selection, and scroll state survive a display-zone switch.
    _dateFormat = DateFormat(widget.showYearAndZone ? 'yyyy/MM/dd HH:mm:ss' : 'MM/dd HH:mm:ss');
    _allProcesses = DataManager().allProcesses;
    _rows = _buildRows();
  }

  @override
  void didUpdateWidget(ProcessTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.displayZone == widget.displayZone) {
      return;
    }
    columns[0].title = _timeColumnTitle('Start Time');
    columns[1].title = _timeColumnTitle('End Time');
    _updateGridRows();
    _stateManager?.notifyListeners();
  }

  /// Names the zone in the header rather than in every cell, which would
  /// outgrow the column widths.
  String _timeColumnTitle(String base) {
    final processes = DataManager().allProcesses;
    if (!widget.showYearAndZone || processes.isEmpty) {
      return base;
    }
    // A file spanning a DST change has two abbreviations; the one it starts
    // in is the honest single answer.
    return '$base (${DisplayTime.abbreviationAt(processes.first.startTime)})';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _overRow.dispose();
    super.dispose();
  }

  List<PlutoRow> _buildRows() {
    final q = searchQuery.toLowerCase();
    return _allProcesses
        .where((process) {
          if (q.isEmpty) {
            return true;
          }
          return process.name.toLowerCase().contains(q) ||
              process.type.name.toLowerCase().contains(q) ||
              (process.processId?.toString().contains(q) ?? false);
        })
        .map((process) {
          return PlutoRow(
            cells: {
              'startTime': PlutoCell(
                value: _dateFormat.format(DisplayTime.wallClock(process.startTime)),
              ),
              'endTime': PlutoCell(
                value: _dateFormat.format(DisplayTime.wallClock(process.endTime)),
              ),
              'file': PlutoCell(value: 1),
              'samples': PlutoCell(value: process.samples),
              'processId': PlutoCell(value: (process.processId ?? '').toString()),
              'sessionId': PlutoCell(value: (process.sessionId ?? '').toString()),
              'type': PlutoCell(value: process.type.name),
              'typeId': PlutoCell(value: process.type.id),
              'name': PlutoCell(value: process.name),
            },
          );
        })
        .toList();
  }

  void _updateGridRows() {
    if (_stateManager == null) {
      return;
    }
    _stateManager!.removeAllRows();
    _rows = _buildRows();
    if (_rows.isNotEmpty) {
      _stateManager!.appendRows(_rows);
    }
    _stateManager!.clearCurrentCell();
    _stateManager!.clearCurrentSelecting();
  }

  /// Maps a pointer position to the row index currently under it, or null if it
  /// is past the last row.
  int? _rowIndexAt(Offset localPosition) {
    final scrollOffset = _stateManager?.scroll.vertical?.offset ?? 0;
    final rowsTopOffset = (_stateManager?.rowsTopOffset ?? 30) + PlutoGridSettings.gridBorderWidth;
    final rowTotalHeight = _stateManager?.rowTotalHeight ?? 26.0;
    final rowCount = _stateManager?.refRows.length ?? 0;
    final adjustedY = localPosition.dy - rowsTopOffset + scrollOffset;
    if (adjustedY < 0) {
      return null;
    }
    final rowIdx = (adjustedY / rowTotalHeight).floor();
    return rowIdx < rowCount ? rowIdx : null;
  }

  void _onRowHover(PointerHoverEvent event) {
    final rowIdx = _rowIndexAt(event.localPosition);
    if (rowIdx != _hoveredRowIndex) {
      // Repaint the affected rows via the grid's notifier instead of setState,
      // so the whole table (and _buildRows) is not rebuilt on every hover frame.
      _hoveredRowIndex = rowIdx;
      _stateManager?.notifyListeners();
    }
    _overRow.value = rowIdx != null;
  }

  void _onRowExit(PointerExitEvent event) {
    _overRow.value = false;
    if (_hoveredRowIndex != null) {
      _hoveredRowIndex = null;
      _stateManager?.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_allProcesses.isEmpty) {
      return emptyState();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        searchBar(),
        const Divider(height: 1),
        Expanded(
          // The grid is passed as `child` so it is built once and reused; only
          // the MouseRegion wrapper rebuilds when the cursor flag changes.
          child: ValueListenableBuilder<bool>(
            valueListenable: _overRow,
            builder: (context, overRow, child) => MouseRegion(
              cursor: overRow ? SystemMouseCursors.click : SystemMouseCursors.basic,
              onHover: _onRowHover,
              onExit: _onRowExit,
              child: child,
            ),
            child: PlutoGrid(
              rowColorCallback: (rowColorContext) {
                if (_rowSelectionKey(rowColorContext.row) == selectedProcessSelectionKey) {
                  return const Color(0xFFDCF5FF);
                }
                if (rowColorContext.rowIdx == _hoveredRowIndex) {
                  return Colors.grey.shade100;
                }
                return Colors.white;
              },
              columns: columns,
              rows: _rows,
              mode: PlutoGridMode.selectWithOneTap,
              configuration: PlutoGridConfiguration(
                style: PlutoGridStyleConfig(
                  rowHeight: 25,
                  columnHeight: 30,
                  cellTextStyle: TextStyle(fontSize: 13),
                  columnTextStyle: TextStyle(fontSize: 13, fontWeight: .bold),
                  enableCellBorderHorizontal: false,
                  enableCellBorderVertical: false,
                  activatedBorderColor: Colors.transparent,
                  gridBorderColor: Colors.transparent,
                  iconColor: Colors.transparent,
                ),
                columnSize: PlutoGridColumnSizeConfig(resizeMode: PlutoResizeMode.normal),
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
                if (event.row != null) {
                  setState(() {
                    selectedProcessSelectionKey = _rowSelectionKey(event.row!);
                  });

                  _stateManager?.clearCurrentCell();
                  _stateManager?.clearCurrentSelecting();

                  final processName = event.row!.cells['name']!.value as String;
                  final processIdStr = event.row!.cells['processId']!.value as String;
                  final sessionIdStr = event.row!.cells['sessionId']!.value as String;
                  final processId = processIdStr.isEmpty ? null : int.tryParse(processIdStr);
                  final sessionId = sessionIdStr.isEmpty ? null : int.tryParse(sessionIdStr);
                  final statTypeId = event.row!.cells['typeId']!.value as int;

                  final process = DataManager().findProcess(
                    statTypeId: statTypeId,
                    processName: processName,
                    processId: processId,
                    sessionId: sessionId,
                  );
                  widget.onProcessSelected?.call(process);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget emptyState() {
    return const ColoredBox(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.insert_drive_file_outlined,
              size: 48,
              color: Colors.black26,
            ),
            SizedBox(height: 12),
            Text(
              'No file opened',
              style: TextStyle(fontSize: 15, color: Colors.black45, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 4),
            Text(
              'Open a file to view processes',
              style: TextStyle(fontSize: 13, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Align(
          alignment: .center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search processes',
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                _updateGridRows();
              },
            ),
          ),
        ),
      ),
    );
  }

  /// The identity of the process a row stands for, in the same form as
  /// [Process.identityKey] so the two can be compared directly.
  String _rowSelectionKey(PlutoRow row) {
    final processId = row.cells['processId']!.value as String;
    final sessionId = row.cells['sessionId']!.value as String;
    final typeId = row.cells['typeId']!.value as int;
    final processName = row.cells['name']!.value as String;
    return '$typeId|$sessionId|$processId|$processName';
  }
}
