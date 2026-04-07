import 'package:vsd/domain/models/statistic.dart';

/// The type of a process that represents the statistics avaliable for it
class StatType {
  StatType({required this.id, required this.name, required this.statistics});
  int id;
  String name;
  List<Statistic> statistics;

  @override
  String toString() => 'StatType(id: $id, name: $name, statistics: $statistics)';
}
