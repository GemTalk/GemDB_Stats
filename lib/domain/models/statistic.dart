/// A class representing a statistic, parsed from vsd.stats.tcl
/// 
/// `name` is the name of the statistic
/// `type` is one of the following: "counter", "counter64", "uvalue" "svalue" "float" "uvalue64"
/// `level` is one of the following: "common" "advanced" "wizard"
/// `units` is a string that describes what the stat measures. Try to use the same unit string of other stats.
/// `isOs` is "true" if the statistic comes from the operating system and is "false" if not.
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
