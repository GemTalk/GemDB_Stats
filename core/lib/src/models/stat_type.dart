import 'package:vsd_core/src/models/statistic.dart';

/// The type of a process that represents the statistics avaliable for it
class StatType {
  /// [columns] gives the field of a data line that holds each statistic. By
  /// default the statistics follow the six header fields of a current file.
  StatType({
    required this.id,
    required this.name,
    required this.statistics,
    List<int>? columns,
  }) : columns = columns ?? [for (var i = 0; i < statistics.length; i++) 6 + i];

  int id;
  String name;
  List<Statistic> statistics;
  final List<int> columns;

  @override
  String toString() =>
      '''
StatType(id: $id, name: $name, statistics: [
  ${statistics.map((s) => s.name).join(', ')}
])''';
}
