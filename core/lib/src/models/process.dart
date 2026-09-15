import 'package:vsd_core/src/models/display_time.dart';
import 'package:vsd_core/src/models/stat_type.dart';
import 'package:vsd_core/src/models/time_series.dart';

class Process {
  Process({
    required this.name,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.samples,
    required this.processId,
    required this.sessionId,
  });

  final String name;
  final StatType type;
  final int? processId;
  final int? sessionId;
  final DateTime startTime;
  DateTime endTime;
  int samples;
  final Map<String, TimeSeries> statisticData = {}; // Keyed by statistic name

  /// Stable identity used by [DataManager.findProcess]. Unique within a file.
  String get identityKey =>
      '${type.id}|${sessionId ?? ''}|${processId ?? ''}|$name';

  String get displayLabel => processId != null ? '$name $processId' : name;

  Map<String, dynamic> toMap() => {
    'name': name,
    'type_name': type.name,
    'type_id': type.id,
    'process_id': processId,
    'session_id': sessionId,
    'start_time': DisplayTime.format(startTime),
    'end_time': DisplayTime.format(endTime),
    'samples': samples,
  };
}
