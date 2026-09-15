import 'package:test/test.dart';
import 'package:vsd_core/vsd_core.dart';

void main() {
  // Every test states the zone it needs; reset so ordering can't leak one.
  tearDown(() {
    DisplayTime.zone = const DisplayZone.file();
    DisplayTime.fileZone = FileZone.unknown;
  });

  group('DisplayTime.format', () {
    test('renders the instant in the file zone and round-trips', () {
      DisplayTime.fileZone = const FileZone(offsetMs: -3 * 3600000);
      final t = DateTime.utc(2026, 5, 21, 3, 0, 3);
      expect(DisplayTime.format(t), '2026-05-21T00:00:03.000-03:00');
      expect(DisplayTime.parse(DisplayTime.format(t)), t);
    });

    test('renders UTC with an explicit +00:00, never Z', () {
      DisplayTime.zone = const DisplayZone.utc();
      final t = DateTime.utc(2026, 5, 21, 3, 0, 3);
      expect(DisplayTime.format(t), '2026-05-21T03:00:03.000+00:00');
      expect(DisplayTime.parse(DisplayTime.format(t)), t);
    });

    test('a named zone formats the same zone at two offsets across DST', () {
      DisplayTime.zone = const DisplayZone.named('America/New_York');
      // EST in January, EDT in July: one zone, two offsets. This is the whole
      // point of resolving a name rather than freezing a number.
      expect(
        DisplayTime.format(DateTime.utc(2026, 1, 1, 12)),
        '2026-01-01T07:00:00.000-05:00',
      );
      expect(
        DisplayTime.format(DateTime.utc(2026, 7, 1, 12)),
        '2026-07-01T08:00:00.000-04:00',
      );
    });

    test('round-trips on both sides of a DST transition', () {
      DisplayTime.zone = const DisplayZone.named('America/New_York');
      for (final t in [
        DateTime.utc(2026, 1, 1, 12),
        DateTime.utc(2026, 7, 1, 12),
      ]) {
        expect(DisplayTime.parse(DisplayTime.format(t)), t);
      }
    });
  });

  group('DisplayTime.parse', () {
    test('an explicit offset names an absolute instant', () {
      DisplayTime.fileZone = const FileZone(offsetMs: -3 * 3600000);
      expect(
        DisplayTime.parse('2026-05-21T00:00:03+05:30'),
        DateTime.utc(2026, 5, 20, 18, 30, 3),
      );
      expect(
        DisplayTime.parse('2026-05-21T00:00:03Z'),
        DateTime.utc(2026, 5, 21, 0, 0, 3),
      );
    });

    test('without an offset the value is read in the display zone', () {
      DisplayTime.fileZone = const FileZone(offsetMs: -3 * 3600000);
      final inFileZone = DateTime.utc(2026, 5, 21, 3, 0, 3);
      expect(DisplayTime.parse('2026-05-21T00:00:03'), inFileZone);
      expect(DisplayTime.parse('2026-05-21 00:00:03'), inFileZone);

      DisplayTime.zone = const DisplayZone.utc();
      expect(
        DisplayTime.parse('2026-05-21T00:00:03'),
        DateTime.utc(2026, 5, 21, 0, 0, 3),
      );
    });

    test('a named zone reads offset-less input through its DST rules', () {
      DisplayTime.zone = const DisplayZone.named('America/New_York');
      expect(
        DisplayTime.parse('2026-07-01T08:00:00'),
        DateTime.utc(2026, 7, 1, 12),
      );
      expect(
        DisplayTime.parse('2026-01-01T07:00:00'),
        DateTime.utc(2026, 1, 1, 12),
      );
    });

    test('accepts a bare date as midnight in the display zone', () {
      DisplayTime.zone = const DisplayZone.utc();
      expect(DisplayTime.parse('2026-05-21'), DateTime.utc(2026, 5, 21));

      DisplayTime.zone = const DisplayZone.file();
      DisplayTime.fileZone = const FileZone(offsetMs: -3 * 3600000);
      expect(DisplayTime.parse('2026-05-21'), DateTime.utc(2026, 5, 21, 3));
    });

    test('returns null for garbage', () {
      expect(DisplayTime.parse('not a time'), isNull);
    });
  });

  group('file zone fallback', () {
    test('falls back to the viewer zone when the header named one', () {
      DisplayTime.fileZone = const FileZone(abbreviation: 'MEST');
      final t = DateTime.utc(2026, 5, 21, 3, 0, 3);
      // Machine-independent: whatever this machine's zone is, the fallback
      // must agree with it and still round-trip.
      expect(DisplayTime.wallClock(t), t.toLocal());
      expect(DisplayTime.parse(DisplayTime.format(t)), t);
    });

    test('says why File shows local time', () {
      DisplayTime.fileZone = const FileZone(abbreviation: 'MEST');
      expect(DisplayTime.zoneLabel, 'File (local, header said MEST)');

      DisplayTime.fileZone = FileZone.unknown;
      expect(DisplayTime.zoneLabel, 'File (local, no zone in header)');
    });
  });

  group('labels', () {
    test('name each zone with the offset it resolves to', () {
      DisplayTime.fileZone = const FileZone(offsetMs: -8 * 3600000);
      expect(
        DisplayTime.labelFor(const DisplayZone.file()),
        'File (UTC-08:00)',
      );
      expect(DisplayTime.labelFor(const DisplayZone.utc()), 'UTC');
      expect(
        DisplayTime.labelFor(
          const DisplayZone.named('Asia/Kolkata'),
          at: DateTime.utc(2026, 1, 1),
        ),
        'Asia/Kolkata (IST, UTC+05:30)',
      );
      // Zones whose "abbreviation" is just a numeric offset shouldn't say it
      // twice.
      expect(
        DisplayTime.labelFor(
          const DisplayZone.named('Asia/Kathmandu'),
          at: DateTime.utc(2026, 1, 1),
        ),
        'Asia/Kathmandu (UTC+05:45)',
      );
      expect(
        DisplayTime.labelFor(
          const DisplayZone.named('America/New_York'),
          at: DateTime.utc(2026, 7, 1),
        ),
        'America/New_York (EDT, UTC-04:00)',
      );
    });
  });

  group('zone identity', () {
    test('equal zones compare equal so menu checkmarks work', () {
      expect(const DisplayZone.file(), const DisplayZone.file());
      expect(const DisplayZone.utc(), isNot(const DisplayZone.file()));
      expect(
        const DisplayZone.named('Europe/Paris'),
        const DisplayZone.named('Europe/Paris'),
      );
      expect(
        const DisplayZone.named('Europe/Paris'),
        isNot(const DisplayZone.named('Europe/Berlin')),
      );
    });
  });

  group('availableZoneNames', () {
    test('lists the IANA database, sorted', () {
      final names = DisplayTime.availableZoneNames();
      expect(names, contains('America/Los_Angeles'));
      expect(names, contains('Europe/Berlin'));
      expect(names.length, greaterThan(300));
      expect(names, orderedEquals(List.of(names)..sort()));
    });
  });
}
