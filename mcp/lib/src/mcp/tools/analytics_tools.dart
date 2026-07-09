import 'dart:math' as math;

import 'package:vsd_core/vsd_core.dart';

/// Returns time-series data for a specific statistic on a process.
/// When [startTime]/[endTime] are given, only points inside the window are
/// returned. Downsamples to [maxPoints] points if the series is longer.
Map<String, dynamic> executeGetStatisticValues({
  required String processName,
  required int statTypeId,
  required String statName,
  int? processId,
  int? sessionId,
  int maxPoints = 200,
  DateTime? startTime,
  DateTime? endTime,
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

  final allPoints = _windowedPoints(ts, startTime, endTime);
  if (allPoints.isEmpty) {
    return {
      'stat_name': statName,
      'point_count': 0,
      'note':
          'No samples in the requested time window; the process has data '
          'from ${FileTime.format(process.startTime)} '
          'to ${FileTime.format(process.endTime)}.',
    };
  }
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

/// Returns summary statistics (min, max, avg, stddev) for a specific
/// statistic, optionally restricted to the [startTime]/[endTime] window.
Map<String, dynamic> executeGetStatisticSummary({
  required String processName,
  required int statTypeId,
  required String statName,
  int? processId,
  int? sessionId,
  DateTime? startTime,
  DateTime? endTime,
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

  final windowed = startTime != null || endTime != null;
  if (!windowed) {
    // Whole-series fast path: TimeSeries computes these without boxing points.
    // ts.hasData guarantees points is non-empty, so average/min/max are non-null.
    return {
      'stat_name': statName,
      'units': ts.statistic.units,
      'point_count': ts.points.length,
      'min': ts.min,
      'max': ts.max,
      'avg': ts.average!.toDouble(),
      'stddev': ts.stddev,
    };
  }

  final points = _windowedPoints(ts, startTime, endTime);
  if (points.isEmpty) {
    return {
      'stat_name': statName,
      'point_count': 0,
      'note': 'No samples in the requested time window.',
    };
  }
  var minV = points.first.value;
  var maxV = points.first.value;
  var sum = 0.0;
  for (final p in points) {
    if (p.value < minV) minV = p.value;
    if (p.value > maxV) maxV = p.value;
    sum += p.value;
  }
  final avg = sum / points.length;
  var variance = 0.0;
  for (final p in points) {
    final d = p.value - avg;
    variance += d * d;
  }
  return {
    'stat_name': statName,
    'units': ts.statistic.units,
    'point_count': points.length,
    'window_start': FileTime.format(points.first.timestamp),
    'window_end': FileTime.format(points.last.timestamp),
    'min': minV,
    'max': maxV,
    'avg': avg,
    'stddev': points.length > 1 ? math.sqrt(variance / points.length) : 0.0,
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

/// Finds when a statistic was "active" and returns the exact activity
/// intervals, so timing questions ("when did it finish", "how long did it
/// take") can be answered without downsampling artifacts.
///
/// [mode] selects the activity detector:
/// - `'nonzero'` (default): active while the value is above [threshold]
///   (default 0). Right for stats that sit at zero between events, e.g.
///   ProgressCount or WaitingForSessionToVote.
/// - `'change'`: active while the value differs from the previous sample.
///   Right for counters and levels that plateau between events, e.g.
///   ReclaimCount or FreePages.
Map<String, dynamic> executeFindStatEvents({
  required String processName,
  required int statTypeId,
  required String statName,
  int? processId,
  int? sessionId,
  String mode = 'nonzero',
  num threshold = 0,
  DateTime? startTime,
  DateTime? endTime,
  int maxIntervals = 50,
}) {
  if (mode != 'nonzero' && mode != 'change') {
    return {'error': 'Unknown mode "$mode"; use "nonzero" or "change".'};
  }
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

  final points = _windowedPoints(ts, startTime, endTime);
  if (points.isEmpty) {
    return {
      'stat_name': statName,
      'intervals': <Map<String, dynamic>>[],
      'note': 'No samples in the requested time window.',
    };
  }

  final intervals = <Map<String, dynamic>>[];
  int? runStart; // index of first active sample of the current run
  num runMax = 0;
  DateTime? runMaxTime;

  void closeRun(int lastActiveIndex) {
    final start = runStart!;
    final first = points[start];
    final last = points[lastActiveIndex];
    intervals.add({
      'start': FileTime.format(first.timestamp),
      'end': FileTime.format(last.timestamp),
      'duration_seconds': last.timestamp.difference(first.timestamp).inMilliseconds / 1000,
      'sample_count': lastActiveIndex - start + 1,
      'max_value': runMax,
      'max_value_time': FileTime.format(runMaxTime!),
      if (mode == 'change') 'value_before': start > 0 ? points[start - 1].value : first.value,
      if (mode == 'change') 'value_after': last.value,
      // The stat was still active at the last sample of the (windowed)
      // series, so the real end may lie beyond the available data.
      if (lastActiveIndex == points.length - 1) 'truncated': true,
    });
    runStart = null;
  }

  for (var i = 0; i < points.length; i++) {
    final p = points[i];
    final active = mode == 'change' ? i > 0 && p.value != points[i - 1].value : p.value > threshold;
    if (active) {
      if (runStart == null) {
        runStart = i;
        runMax = p.value;
        runMaxTime = p.timestamp;
      } else if (p.value > runMax) {
        runMax = p.value;
        runMaxTime = p.timestamp;
      }
    } else if (runStart != null) {
      closeRun(i - 1);
    }
  }
  if (runStart != null) {
    closeRun(points.length - 1);
  }

  final total = intervals.length;
  final capped = total > maxIntervals ? intervals.sublist(0, maxIntervals) : intervals;
  return {
    'stat_name': statName,
    'units': ts.statistic.units,
    'mode': mode,
    if (mode == 'nonzero') 'threshold': threshold,
    'samples_examined': points.length,
    'series_start': FileTime.format(points.first.timestamp),
    'series_end': FileTime.format(points.last.timestamp),
    'interval_count': total,
    if (total > maxIntervals)
      'note':
          'Showing $maxIntervals of $total intervals. Narrow the time '
          'window, raise max_intervals, or use mode/threshold to reduce noise.',
    'intervals': capped,
  };
}

/// Samples one or more statistics of a process at a specific moment,
/// returning the value at-or-before [time] (and the next sample after it).
/// Answers "what was X when Y happened" without pulling whole series.
Map<String, dynamic> executeGetValuesAtTime({
  required String processName,
  required int statTypeId,
  required List<String> statNames,
  required DateTime time,
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

  final values = <Map<String, dynamic>>[];
  for (final statName in statNames) {
    final ts = process.statisticData[statName];
    if (ts == null || ts.points.isEmpty) {
      values.add({'stat_name': statName, 'error': 'Statistic not found or has no data'});
      continue;
    }
    final points = ts.points;
    final idx = _lastIndexAtOrBefore(points, time);
    if (idx < 0) {
      values.add({
        'stat_name': statName,
        'error':
            'Requested time is before the first sample '
            '(${FileTime.format(points.first.timestamp)})',
      });
      continue;
    }
    final sample = points[idx];
    values.add({
      'stat_name': statName,
      'units': ts.statistic.units,
      'value': sample.value,
      'sample_time': FileTime.format(sample.timestamp),
      if (idx + 1 < points.length)
        'next_sample': {
          'value': points[idx + 1].value,
          'time': FileTime.format(points[idx + 1].timestamp),
        },
    });
  }

  return {
    'process_name': processName,
    'requested_time': FileTime.format(time),
    'values': values,
  };
}

/// Points of [ts] restricted to the inclusive [startTime]/[endTime] window.
List<DataPoint> _windowedPoints(TimeSeries ts, DateTime? startTime, DateTime? endTime) {
  final points = ts.points;
  if (startTime == null && endTime == null) {
    return points;
  }
  var from = 0;
  var to = points.length; // exclusive
  if (startTime != null) {
    from = _lastIndexAtOrBefore(points, startTime);
    // _lastIndexAtOrBefore lands on the sample at or before startTime; step
    // forward if that sample is strictly before the window.
    if (from < 0 || points[from].timestamp.isBefore(startTime)) {
      from++;
    }
  }
  if (endTime != null) {
    to = _lastIndexAtOrBefore(points, endTime) + 1;
  }
  if (from >= to) {
    return const [];
  }
  return points.sublist(from, to);
}

/// Binary search: index of the last point whose timestamp is <= [time],
/// or -1 if all points are after [time]. Timestamps are strictly increasing.
int _lastIndexAtOrBefore(List<DataPoint> points, DateTime time) {
  var lo = 0;
  var hi = points.length - 1;
  var result = -1;
  while (lo <= hi) {
    final mid = (lo + hi) ~/ 2;
    if (points[mid].timestamp.isAfter(time)) {
      hi = mid - 1;
    } else {
      result = mid;
      lo = mid + 1;
    }
  }
  return result;
}

Map<String, dynamic> _notFoundResponse(String name, int typeId) {
  return {'error': 'Process not found: $name (type_id=$typeId)'};
}
