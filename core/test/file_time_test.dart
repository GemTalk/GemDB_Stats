import 'package:test/test.dart';
import 'package:vsd_core/vsd_core.dart';

void main() {
  group('FileTime.parse', () {
    tearDown(() => FileTime.utcOffsetMs = 0);

    test('round-trips format output regardless of file offset', () {
      FileTime.utcOffsetMs = -3 * 3600000;
      final t = DateTime.utc(2026, 5, 21, 0, 0, 3);
      expect(FileTime.format(t), '2026-05-21T00:00:03.000-03:00');
      expect(FileTime.parse(FileTime.format(t)), t);
    });

    test('ignores any trailing offset and keeps the wall-clock time', () {
      final t = DateTime.utc(2026, 5, 21, 0, 0, 3);
      expect(FileTime.parse('2026-05-21T00:00:03+05:30'), t);
      expect(FileTime.parse('2026-05-21T00:00:03Z'), t);
      expect(FileTime.parse('2026-05-21T00:00:03'), t);
      expect(FileTime.parse('2026-05-21 00:00:03'), t);
    });

    test('accepts a bare date as midnight', () {
      expect(FileTime.parse('2026-05-21'), DateTime.utc(2026, 5, 21));
    });

    test('returns null for garbage', () {
      expect(FileTime.parse('not a time'), isNull);
    });
  });
}
