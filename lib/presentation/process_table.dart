import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:vsd/domain/data_manager.dart';
import 'package:vsd/domain/models/process.dart';

class ProcessTable extends StatefulWidget {
  const ProcessTable({super.key, this.onProcessSelected});

  final void Function(Process?)? onProcessSelected;

  @override
  State<ProcessTable> createState() => _ProcessTableState();
}

class _ProcessTableState extends State<ProcessTable> {
  final List<PlutoRow> rows = DataManager().processes.values.map((process) {
    return PlutoRow(
      cells: {
        'startTime': PlutoCell(value: DateFormat('MM/dd HH:mm:ss').format(process.startTime)),
        'endTime': PlutoCell(value: DateFormat('MM/dd HH:mm:ss').format(process.endTime)),
        'file': PlutoCell(value: 1),
        'samples': PlutoCell(value: process.samples),
        'processId': PlutoCell(value: process.processId.toString()),
        'sessionId': PlutoCell(value: process.sessionId),
        'type': PlutoCell(value: process.type.name),
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
      width: 125,
    ),
    PlutoColumn(
      title: 'End Time',
      field: 'endTime',
      type: PlutoColumnType.text(),
      enableColumnDrag: false,
      enableContextMenu: false,
      width: 125,
    ),
    PlutoColumn(
      title: 'File',
      field: 'file',
      type: PlutoColumnType.text(),
      enableColumnDrag: false,
      enableContextMenu: false,
      width: 50,
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
      width: 100,
    ),
    PlutoColumn(
      title: 'Type',
      field: 'type',
      type: PlutoColumnType.text(),
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
    return PlutoGrid(
      columns: columns,
      rows: rows,
      mode: PlutoGridMode.selectWithOneTap,
      configuration: PlutoGridConfiguration(
        style: PlutoGridStyleConfig(
          rowHeight: 25,
          columnHeight: 30,
          cellTextStyle: TextStyle(fontSize: 14),
          columnTextStyle: TextStyle(fontSize: 14, fontWeight: .bold),
          enableCellBorderHorizontal: false,
          enableCellBorderVertical: false,
          activatedBorderColor: Colors.transparent,
          iconSize: 0,
        ),
        columnSize: PlutoGridColumnSizeConfig(resizeMode: PlutoResizeMode.none),
        enterKeyAction: PlutoGridEnterKeyAction.toggleEditing,
        tabKeyAction: PlutoGridTabKeyAction.normal,
        enableMoveDownAfterSelecting: true,
        enableMoveHorizontalInEditing: false,
      ),
      onLoaded: (PlutoGridOnLoadedEvent event) {
        event.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
        event.stateManager.setEditing(false);
      },
      onSelected: (PlutoGridOnSelectedEvent event) {
        if (event.row != null) {
          final processName = event.row!.cells['name']!.value as String;
          final process = DataManager().processes[processName];
          widget.onProcessSelected?.call(process);
        } else {
          widget.onProcessSelected?.call(null);
        }
      },
    );
  }
}
