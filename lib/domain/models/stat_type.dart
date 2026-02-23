class StatType {
  StatType({required this.id, required this.name, required this.statistics});
  int id;
  String name;
  List<String> statistics;

  @override
  String toString() =>
      'StatType(id: $id, name: $name, statistics: $statistics)';
}
