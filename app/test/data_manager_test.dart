import 'package:flutter_test/flutter_test.dart';
import 'package:vsd_core/vsd_core.dart';

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

    test('parseZoneAbbreviation names the zone we could not resolve', () {
      expect(
        DataManager.parseZoneAbbreviation('STATMON "3"\nTime = "20/08/11 06:55:32 MEST"\n'),
        'MEST',
      );
      // A numeric offset needs no explaining.
      expect(
        DataManager.parseZoneAbbreviation('STATMON "4"\nTime = "2026-02-19T16:09:13.930-08:00"\n'),
        isNull,
      );
      expect(DataManager.parseZoneAbbreviation('STATMON "4"\n'), isNull);
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

      // Timestamps are stored as true instants: the first sample is epoch
      // 1771546154, which is 2026-02-20T00:09:14Z.
      expect(process.startTime, DateTime.utc(2026, 2, 20, 0, 9, 14));
      expect(process.startTime.millisecondsSinceEpoch, 1771546154000);

      // By default they display in the file's own zone, so the rendered time
      // is the server's wall clock and carries its real offset, not 'Z'.
      expect(DisplayTime.fileZone.offsetMs, -8 * 3600000);
      expect(DisplayTime.format(process.startTime), '2026-02-19T16:09:14.000-08:00');

      // Switching the display zone re-renders the same instant.
      DisplayTime.zone = const DisplayZone.utc();
      addTearDown(() => DisplayTime.zone = const DisplayZone.file());
      expect(DisplayTime.format(process.startTime), '2026-02-20T00:09:14.000+00:00');

      final ts = process.statisticData.values.first;
      expect(ts.points, isNotEmpty);
      expect(ts.points.length, process.samples);

      // The points view should expose real timestamps in order
      final timestamps = ts.points.map((p) => p.timestamp).toList();
      expect(timestamps.first.millisecondsSinceEpoch, 1771546154000);
      for (int i = 1; i < timestamps.length; i++) {
        expect(timestamps[i].isBefore(timestamps[i - 1]), isFalse);
      }

      // Non-float statistics should surface int values, not doubles
      final intSeries = process.statisticData.values.where((s) => s.statistic.type != 'float');
      for (final s in intSeries.take(5)) {
        expect(s.points.first.value, isA<int>());
      }
    });

    test('loading a file updates the file zone but keeps the selection', () async {
      final dm = DataManager();
      dm.statistics.addAll(statisticsMap);
      await dm.loadFromFile('test/test_data/statmon76637.out');

      DisplayTime.zone = const DisplayZone.utc();
      addTearDown(() => DisplayTime.zone = const DisplayZone.file());

      await dm.loadFromFile('test/test_data/statmon76637.out');

      // Only "File" follows the new file; what the user chose to read in
      // survives the load.
      expect(DisplayTime.zone, const DisplayZone.utc());
      expect(DisplayTime.fileZone.offsetMs, -8 * 3600000);
    });

    test('drops out-of-order/duplicate samples so every process is monotonic', () async {
      final dm = DataManager();
      dm.statistics.addAll(statisticsMap);
      await dm.loadFromFile('test/test_data/statmon76637.out');

      // The file carries a rogue trailing gs64stone record whose timestamp
      // equals the first sample's, appended after the final sample. It must be
      // dropped: every process keeps a consistent sample count, and each
      // statistic's timestamps stay strictly increasing (so the chart's
      // first/last-as-domain assumption holds).
      for (final process in dm.allProcesses) {
        for (final ts in process.statisticData.values) {
          expect(ts.points.length, process.samples);
          final timestamps = ts.points.map((p) => p.timestamp).toList();
          for (int i = 1; i < timestamps.length; i++) {
            expect(timestamps[i].isAfter(timestamps[i - 1]), isTrue);
          }
        }
      }

      final stone = dm.allProcesses.firstWhere((p) => p.name == 'gs64stone');
      expect(stone.samples, 38);
    });
  });
}
