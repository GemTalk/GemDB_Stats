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
  final int processId;
  final String sessionId;
  final DateTime startTime;
  DateTime endTime;
  int samples;
  final Map<String, TimeSeries> statisticData = {}; // Keyed by statistic name
}
