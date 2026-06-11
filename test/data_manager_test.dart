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

    test('loadFromFile parses a statmon file end-to-end', () async {
      final dm = DataManager();
      dm.statistics.addAll(statisticsMap);

      final progress = <double>[];
      await dm.loadFromFile('data/statmon76637.out', onProgress: progress.add);

      expect(progress, isNotEmpty);
      expect(dm.statTypes, isNotEmpty);
      expect(dm.allProcesses, isNotEmpty);

      final process = dm.allProcesses.first;
      expect(process.statisticData, isNotEmpty);

      final ts = process.statisticData.values.first;
      expect(ts.points, isNotEmpty);
      expect(ts.points.length, process.samples);

      // The points view should expose real timestamps in order
      final timestamps = ts.points.map((p) => p.timestamp).toList();
      expect(timestamps.first.millisecondsSinceEpoch, greaterThan(0));
      for (int i = 1; i < timestamps.length; i++) {
        expect(timestamps[i].isBefore(timestamps[i - 1]), isFalse);
      }

      // Non-float statistics should surface int values, not doubles
      final intSeries = process.statisticData.values.where((s) => s.statistic.type != 'float');
      for (final s in intSeries.take(5)) {
        expect(s.points.first.value, isA<int>());
      }
    });
  });
}
