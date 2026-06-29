import 'package:vsd/domain/data_manager.dart';
import 'package:vsd/domain/models/file_time.dart';

/// Returns a list of all loaded processes with metadata.
Map<String, dynamic> executeListProcesses() {
  final dm = DataManager();
  if (dm.allProcesses.isEmpty) {
    return {
      'processes': <Map<String, dynamic>>[],
      'message': 'No data loaded. Open a statmon file first.',
    };
  }
  return {
    'processes': dm.allProcesses.map((p) => p.toMap()).toList(),
  };
}

/// Returns all statistics available for a specific process.
///
/// [processName], [statTypeId], [processId] and [sessionId] together
/// uniquely identify a process (matching [DataManager.findProcess]).
Map<String, dynamic> executeGetProcessDetails({
  required String processName,
  required int statTypeId,
  int? processId,
  int? sessionId,
}) {
  final dm = DataManager();
  final process = dm.findProcess(
    statTypeId: statTypeId,
    processName: processName,
    processId: processId,
    sessionId: sessionId,
  );

  if (process == null) {
    return {
      'error':
          'Process not found: $processName '
          '(type_id=$statTypeId, process_id=$processId, session_id=$sessionId)',
    };
  }

  return {
    'process': process.toMap(),
    'statistics': process.type.statistics.map((stat) {
      final ts = process.statisticData[stat.name];
      return {
        'name': stat.name,
        'units': stat.units,
        'description': stat.description,
        'level': stat.level,
        'type': stat.type,
        'has_data': ts?.hasData ?? false,
        if (ts?.hasData == true) 'min': ts!.min,
        if (ts?.hasData == true) 'max': ts!.max,
        if (ts?.hasData == true) 'avg': ts!.average,
      };
    }).toList(),
  };
}

/// Returns a high-level overview of all loaded data.
Map<String, dynamic> executeGetDatasetOverview() {
  final dm = DataManager();
  if (dm.allProcesses.isEmpty) {
    return {'message': 'No data loaded. Open a statmon file first.'};
  }

  final allTimes = dm.allProcesses.expand((p) => [p.startTime, p.endTime]).toList();
  final minTime = allTimes.reduce((a, b) => a.isBefore(b) ? a : b);
  final maxTime = allTimes.reduce((a, b) => a.isAfter(b) ? a : b);
  final duration = maxTime.difference(minTime);

  return {
    'process_count': dm.allProcesses.length,
    'process_names': dm.processes.keys.toList(),
    'stat_type_names': dm.statTypes.values.map((t) => t.name).toSet().toList(),
    'time_range': {
      'start': FileTime.format(minTime),
      'end': FileTime.format(maxTime),
      'duration_minutes': duration.inMinutes,
    },
    'total_samples': dm.allProcesses.fold<int>(0, (sum, p) => sum + p.samples),
  };
}
