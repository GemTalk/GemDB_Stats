class Statistic {
  Statistic({
    required this.name,
    required this.type,
    required this.level,
    required this.units,
    required this.isOs,
    required this.description,
  });

  String name;
  String type;
  String level;
  String units;
  bool isOs;
  String description;

  @override
  String toString() {
    return 'Statistic($name)';
  }
}
