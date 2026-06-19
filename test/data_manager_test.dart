import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/domain/data_manager.dart';
import 'package:vsd/domain/models/file_time.dart';

import 'test_data/statistics_map.dart';
import 'test_data/test_statmon.dart';

void main() {
  group('DataManager', () {
    test('parseStatTypes', () {
      final statTypes = DataManager.parseStatTypes(testStatMon, statisticsMap);
      expect(statTypes.isNotEmpty, true);
      expect(statTypes.values.first.name, isNotEmpty);

      // Expect the "Linux_System" stat type to have 56 fields, excluding the
      // first 6 header fields (StatTypeNum, Time, ProcessName, ProcessId,
      // SessionId, CacheSerialNum) which aren't statistics.
      final linux = statTypes[128];
      expect(linux, isNotNull);
      expect(linux!.statistics.length, 56 - 6);
    });

    test('parseUtcOffsetMs reads the header timezone offset', () {
      expect(
        DataManager.parseUtcOffsetMs('STATMON "4"\nTime = "2026-02-19T16:09:13.930-08:00"\n'),
        -8 * 3600000,
      );
      expect(
        DataManager.parseUtcOffsetMs('STATMON "3"\nTime = "05/21/2026 00:00:02 -03"\n'),
        -3 * 3600000,
      );
      expect(
        DataManager.parseUtcOffsetMs('STATMON "4"\nTime = "2025-09-23T23:28:11.543+00:00"\n'),
        0,
      );
      expect(
        DataManager.parseUtcOffsetMs('STATMON "4"\nTime = "2026-02-19T16:09:13.930+05:30"\n'),
        (5 * 60 + 30) * 60000,
      );
      // Named timezones can't be resolved; falls back to viewer-local
      expect(
        DataManager.parseUtcOffsetMs('STATMON "3"\nTime = "20/08/11 06:55:32 MEST"\n'),
        isNull,
      );
    });

    test('loadFromFile parses a statmon file end-to-end', () async {
      final dm = DataManager();
      dm.statistics.addAll(statisticsMap);

      final progress = <double>[];
      await dm.loadFromFile('test/test_data/statmon76637.out', onProgress: progress.add);

      expect(progress, isNotEmpty);
      expect(dm.statTypes, isNotEmpty);
      expect(dm.allProcesses, isNotEmpty);

      final process = dm.allProcesses.first;
      expect(process.statisticData, isNotEmpty);

      // Times display in the file's recorded timezone (-08:00 in this file),
      // not the viewer's: first sample is epoch 1771546154 = 16:09:14 -08:00.
      expect(process.startTime, DateTime.utc(2026, 2, 19, 16, 9, 14));

      // Exported times carry the file's real UTC offset, not 'Z'
      expect(FileTime.utcOffsetMs, -8 * 3600000);
      expect(FileTime.format(process.startTime), '2026-02-19T16:09:14.000-08:00');

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
