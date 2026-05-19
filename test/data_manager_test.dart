import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/domain/data_manager.dart';

import 'test_data/statistics_map.dart';
import 'test_data/test_statmon.dart';

void main() {
  group('DataManager', () {
    test('parseStatTypes', () {
      final statTypes = DataManager.parseStatTypes(testStatMon, statisticsMap);
      expect(statTypes.isNotEmpty, true);
      expect(statTypes.values.first.name, isNotEmpty);

      // Expect the "Linux_System" stat type to have 56 statistics, 
      // excluding the first 3 which are StatTypeNum, Time, and ProcessName.
      final linux = statTypes[128];
      expect(linux, isNotNull);
      expect(linux!.statistics.length, 56-3);
    });
  });
}
