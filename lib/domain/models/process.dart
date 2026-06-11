import 'package:vsd/domain/models/file_time.dart';
import 'package:vsd/domain/models/stat_type.dart';
import 'package:vsd/domain/models/time_series.dart';

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

  Map<String, dynamic> toMap() => {
    'name': name,
    'type_name': type.name,
    'type_id': type.id,
    'process_id': processId,
    'session_id': sessionId,
    'start_time': FileTime.format(startTime),
    'end_time': FileTime.format(endTime),
    'samples': samples,
  };
}
