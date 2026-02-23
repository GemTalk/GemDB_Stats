import 'package:vsd/domain/models/stat_type.dart';

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

  String name;
  StatType type;
  DateTime startTime;
  DateTime endTime;
  int samples;
  int processId;
  String sessionId;
}
