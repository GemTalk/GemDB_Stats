import 'package:vsd_core/vsd_core.dart';

/// Returns a list of loaded processes with metadata.
///
/// [nameFilter] keeps only processes whose name contains it
/// (case-insensitive). At most [limit] entries are returned — datasets can
/// hold thousands of process instances, far more than fits in an LLM
/// context — and the result always carries the total match count so the
/// caller knows when to narrow the filter.
Map<String, dynamic> executeListProcesses({
  String? nameFilter,
  int limit = 100,
}) {
  final dm = DataManager();
  if (dm.allProcesses.isEmpty) {
    return {
      'processes': <Map<String, dynamic>>[],
      'message': 'No data loaded. Open a statmon file first.',
    };
  }

  var matches = dm.allProcesses;
  final needle = nameFilter?.trim().toLowerCase() ?? '';
  if (needle.isNotEmpty) {
    matches = matches
        .where((p) => p.name.toLowerCase().contains(needle))
        .toList();
  }

  final cap = limit < 1 ? 100 : limit;
  final capped = matches.length > cap ? matches.sublist(0, cap) : matches;
  return {
    'total_matching': matches.length,
    'returned': capped.length,
    if (capped.length < matches.length)
      'note':
          'Showing ${capped.length} of ${matches.length} matching processes. '
          'Narrow with name_filter or raise limit.',
    'processes': capped.map((p) => p.toMap()).toList(),
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

  final allTimes = dm.allProcesses
      .expand((p) => [p.startTime, p.endTime])
      .toList();
  final minTime = allTimes.reduce((a, b) => a.isBefore(b) ? a : b);
  final maxTime = allTimes.reduce((a, b) => a.isAfter(b) ? a : b);
  final duration = maxTime.difference(minTime);

  return {
    'process_count': dm.allProcesses.length,
    'process_names': dm.processes.keys.toList(),
    'stat_type_names': dm.statTypes.values.map((t) => t.name).toSet().toList(),
    'time_range': {
      'start': DisplayTime.format(minTime),
      'end': DisplayTime.format(maxTime),
      'duration_minutes': duration.inMinutes,
      'time_zone': DisplayTime.zoneLabel,
    },
    'total_samples': dm.allProcesses.fold<int>(0, (sum, p) => sum + p.samples),
  };
}
