import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:vsd/domain/data_manager.dart';
import 'package:vsd/domain/models/process.dart';
import 'package:vsd/presentation/_reusable_components/case_insensitive_text_type.dart';

class ProcessTable extends StatefulWidget {
  const ProcessTable({super.key, this.onProcessSelected});

  final void Function(Process?)? onProcessSelected;

  @override
  State<ProcessTable> createState() => _ProcessTableState();
}

class _ProcessTableState extends State<ProcessTable> {
  PlutoGridStateManager? _stateManager;
  String? selectedProcessSelectionKey;
  int? _hoveredRowIndex;
  final List<PlutoRow> rows = DataManager().allProcesses.map((process) {
    return PlutoRow(
      cells: {
        'startTime': PlutoCell(value: DateFormat('yyyy/MM/dd HH:mm:ss').format(process.startTime)),
        'endTime': PlutoCell(value: DateFormat('yyyy/MM/dd HH:mm:ss').format(process.endTime)),
        'file': PlutoCell(value: 1),
        'samples': PlutoCell(value: process.samples),
        'processId': PlutoCell(value: (process.processId ?? '').toString()),
        'sessionId': PlutoCell(value: (process.sessionId ?? '').toString()),
        'type': PlutoCell(value: process.type.name),
        'typeId': PlutoCell(value: process.type.id), // Not displayed in the table, but used for finding the process
        'name': PlutoCell(value: process.name),
      },
    );
  }).toList();

  final List<PlutoColumn> columns = [
    PlutoColumn(
      title: 'Start Time',
      field: 'startTime',
      type: PlutoColumnType.text(),
      enableColumnDrag: false,
      enableContextMenu: false,
      width: 155,
    ),
    PlutoColumn(
      title: 'End Time',
      field: 'endTime',
      type: PlutoColumnType.text(),
      enableColumnDrag: false,
      enableContextMenu: false,
      width: 155,
    ),
    // PlutoColumn(
    //   title: 'File',
    //   field: 'file',
    //   type: PlutoColumnType.text(),
    //   enableColumnDrag: false,
    //   enableContextMenu: false,
    //   width: 50,
    // ),
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

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: (_hoveredRowIndex != null && _hoveredRowIndex! < rows.length)
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onHover: (event) {
        final scrollOffset = _stateManager?.scroll.vertical?.offset ?? 0;
        final rowsTopOffset = (_stateManager?.rowsTopOffset ?? 30) +
            PlutoGridSettings.gridBorderWidth;
        final rowTotalHeight = _stateManager?.rowTotalHeight ?? 26.0;
        final adjustedY =
            event.localPosition.dy - rowsTopOffset + scrollOffset;
        final rowIdx =
            adjustedY < 0 ? null : (adjustedY / rowTotalHeight).floor();
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
        rows: rows,
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
            iconSize: 0,
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
    );
  }

  String _rowSelectionKey(PlutoRow row) {
    final processId = row.cells['processId']!.value as String;
    final sessionId = row.cells['sessionId']!.value as String;
    final typeId = row.cells['typeId']!.value as int;
    final processName = row.cells['name']!.value as String;
    return '$typeId|$sessionId|$processId|$processName';
  }
}
