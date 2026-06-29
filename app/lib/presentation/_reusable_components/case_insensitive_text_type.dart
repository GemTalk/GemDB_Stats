import 'package:pluto_grid/pluto_grid.dart';

class CaseInsensitiveTextType implements PlutoColumnType {
  @override
  final dynamic defaultValue = '';

  @override
  bool isValid(dynamic value) => value is String || value is num;

  @override
  int compare(dynamic a, dynamic b) {
    if (a == null && b == null) {
      return 0;
    }
    if (a == null) {
      return -1;
    }
    if (b == null) {
      return 1;
    }
    return a.toString().toLowerCase().compareTo(b.toString().toLowerCase());
  }

  @override
  dynamic makeCompareValue(dynamic v) => v.toString().toLowerCase();
}
