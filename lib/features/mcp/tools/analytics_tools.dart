import 'package:vsd/domain/data_manager.dart';
import 'package:vsd/domain/models/file_time.dart';
import 'package:vsd/domain/models/time_series.dart';

/// Returns time-series data for a specific statistic on a process.
/// Downsamples to [maxPoints] points if the raw series is longer.
Map<String, dynamic> executeGetStatisticValues({
  required String processName,
  required int statTypeId,
  required String statName,
  int? processId,
  int? sessionId,
  int maxPoints = 200,
}) {
  final process = DataManager().findProcess(
    statTypeId: statTypeId,
    processName: processName,
    processId: processId,
    sessionId: sessionId,
  );
  if (process == null) {
    return _notFoundResponse(processName, statTypeId);
  }

  final ts = process.statisticData[statName];
  if (ts == null || !ts.hasData) {
    return {
      'error': 'Statistic "$statName" not found or has no data for process $processName',
    };
  }

  final allPoints = ts.points;
  final originalCount = allPoints.length;

  final List<DataPoint> displayPoints;
  final bool downsampled;
  if (originalCount > maxPoints) {
    downsampled = true;
    final stride = (originalCount / maxPoints).ceil().clamp(1, originalCount);
    displayPoints = [
      for (var i = 0; i < originalCount; i += stride) allPoints[i],
    ];
  } else {
    downsampled = false;
    displayPoints = allPoints;
  }

  return {
    'stat_name': statName,
    'units': ts.statistic.units,
    'downsampled': downsampled,
    'original_count': originalCount,
    'point_count': displayPoints.length,
    'points': displayPoints.map((p) => {'t': FileTime.format(p.timestamp), 'v': p.value}).toList(),
  };
}

/// Returns summary statistics (min, max, avg, stddev) for a specific statistic.
Map<String, dynamic> executeGetStatisticSummary({
  required String processName,
  required int statTypeId,
  required String statName,
  int? processId,
  int? sessionId,
}) {
  final process = DataManager().findProcess(
    statTypeId: statTypeId,
    processName: processName,
    processId: processId,
    sessionId: sessionId,
  );
  if (process == null) {
    return _notFoundResponse(processName, statTypeId);
  }

  final ts = process.statisticData[statName];
  if (ts == null || !ts.hasData) {
    return {'error': 'Statistic "$statName" not found or has no data'};
  }

  final n = ts.points.length;
  // ts.hasData guarantees points is non-empty, so average/min/max are non-null.
  final avg = ts.average!.toDouble();
  final sd = ts.stddev;

  return {
    'stat_name': statName,
    'units': ts.statistic.units,
    'point_count': n,
    'min': ts.min,
    'max': ts.max,
    'avg': avg,
    'stddev': sd,
  };
}

/// Compares two processes on a set of named statistics.
///
/// The process identifiers follow the same pattern as [executeGetStatisticSummary].
Map<String, dynamic> executeCompareProcesses({
  required String process1Name,
  required int process1TypeId,
  required String process2Name,
  required int process2TypeId,
  required List<String> statNames,
  int? process1Id,
  int? process1SessionId,
  int? process2Id,
  int? process2SessionId,
}) {
  final comparison = <String, dynamic>{};

  for (final statName in statNames) {
    final s1 = executeGetStatisticSummary(
      processName: process1Name,
      statTypeId: process1TypeId,
      statName: statName,
      processId: process1Id,
      sessionId: process1SessionId,
    );
    final s2 = executeGetStatisticSummary(
      processName: process2Name,
      statTypeId: process2TypeId,
      statName: statName,
      processId: process2Id,
      sessionId: process2SessionId,
    );

    comparison[statName] = {
      'process_1': {'name': process1Name, ...s1},
      'process_2': {'name': process2Name, ...s2},
    };
  }

  return {'comparison': comparison};
}

/// Finds the top [limit] statistics by [metric] value for a process.
///
/// [metric] must be one of: `'max'`, `'avg'`, `'min'`.
Map<String, dynamic> executeFindTopStatistics({
  required String processName,
  required int statTypeId,
  int? processId,
  int? sessionId,
  String metric = 'avg',
  int limit = 10,
}) {
  final process = DataManager().findProcess(
    statTypeId: statTypeId,
    processName: processName,
    processId: processId,
    sessionId: sessionId,
  );

  if (process == null) {
    return _notFoundResponse(processName, statTypeId);
  }

  final results = <Map<String, dynamic>>[];

  for (final stat in process.type.statistics) {
    final ts = process.statisticData[stat.name];
    if (ts == null || !ts.hasData) {
      continue;
    }

    // ts.hasData guarantees min/max/average are non-null.
    final double value;
    switch (metric) {
      case 'max':
        value = ts.max!.toDouble();
      case 'min':
        value = ts.min!.toDouble();
      default:
        value = ts.average!.toDouble();
    }

    results.add({
      'stat_name': stat.name,
      'value': value,
      'units': stat.units,
      'description': stat.description,
    });
  }

  // For 'min' metric, sort ascending so lowest values are "top".
  if (metric == 'min') {
    results.sort(
      (a, b) => (a['value'] as double).compareTo(b['value'] as double),
    );
  } else {
    results.sort(
      (a, b) => (b['value'] as double).compareTo(a['value'] as double),
    );
  }

  return {
    'process_name': processName,
    'metric': metric,
    'top_statistics': results.take(limit).toList(),
  };
}

Map<String, dynamic> _notFoundResponse(String name, int typeId) {
  return {'error': 'Process not found: $name (type_id=$typeId)'};
}
