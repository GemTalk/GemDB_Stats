import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:vsd_core/src/models/display_zone.dart';
import 'package:vsd_core/src/models/file_zone.dart';

/// Global display-time context.
///
/// UTC timestamps are the source of truth; this class converts them into the
/// user's current display zone and keeps that choice stable across file loads.
class DisplayTime {
  /// What the currently loaded file's header recorded. Set by `DataManager`.
  static FileZone fileZone = FileZone.unknown;

  /// The zone timestamps are displayed in. Never reset on file load.
  static DisplayZone zone = const DisplayZone.file();

  static bool _tzReady = false;

  /// Initializes the bundled tz database. Idempotent and safe to call early.
  /// Must not run in the parse isolate: tz data is isolate-global.
  static void ensureTimeZoneData() {
    if (_tzReady) {
      return;
    }
    tzdata.initializeTimeZones();
    _tzReady = true;
  }

  /// [instant] with its field getters reading as [zone]'s wall clock.
  static DateTime wallClock(DateTime instant) => zone.wallClock(instant);

  /// [wallClock] for a raw epoch-millisecond value, as the charts hold them.
  static DateTime wallClockFromMs(int epochMs) =>
      zone.wallClock(DateTime.fromMillisecondsSinceEpoch(epochMs, isUtc: true));

  /// Format [instant] as ISO-8601 in [zone], always with an explicit numeric
  /// offset, e.g. `2026-05-21T00:00:03.000-03:00`.
  ///
  /// The offset is never abbreviated to `Z`, so the result round-trips through
  /// [parse] in every zone, including across a DST transition.
  static String format(DateTime instant) {
    final w = zone.wallClock(instant);
    // Re-box the wall-clock fields as UTC to borrow Dart's ISO formatter for
    // the date/time part, then swap its 'Z' for the real offset. TZDateTime's
    // own toIso8601String() writes the offset without a colon.
    final iso = DateTime.utc(
      w.year,
      w.month,
      w.day,
      w.hour,
      w.minute,
      w.second,
      w.millisecond,
    ).toIso8601String();
    return iso.substring(0, iso.length - 1) +
        offsetSuffix(zone.offsetAt(instant));
  }

  static final _hasExplicitOffset = RegExp(r'(Z|[+-]\d{2}:?\d{2})$');

  /// Parse an ISO-8601 timestamp into a true instant.
  ///
  /// A trailing offset (or `Z`) names an exact instant and is honoured. Without
  /// one, the value is read as a wall clock in the current display [zone].
  /// Returns null if [s] is not a valid ISO-8601 timestamp.
  static DateTime? parse(String s) {
    final t = s.trim();
    if (_hasExplicitOffset.hasMatch(t)) {
      return DateTime.tryParse(t)?.toUtc();
    }
    // Dart's ISO grammar nests the zone inside the time part, so a bare date
    // needs the time appended before the 'Z' will parse.
    final fields =
        DateTime.tryParse('${t}Z') ?? DateTime.tryParse('${t}T00:00:00Z');
    return fields == null ? null : zone.instantFrom(fields);
  }

  /// The zone abbreviation in effect at [instant] ("PDT", "UTC", "+0530").
  static String abbreviationAt(DateTime instant) =>
      zone.abbreviationAt(instant);

  /// Name of the current zone, with the offset it resolves to.
  static String get zoneLabel => labelFor(zone);

  /// Menu/status label for [z], e.g. `File (UTC-08:00)` or
  /// `Europe/Paris (CEST, UTC+02:00)`. Defaults [at] to now, so callers that
  /// only ever label the present don't have to say so.
  static String labelFor(DisplayZone z, {DateTime? at}) =>
      z.describeAt(at ?? DateTime.now().toUtc());

  /// Every IANA zone name the picker can offer, sorted.
  static List<String> availableZoneNames() {
    ensureTimeZoneData();
    return tz.timeZoneDatabase.locations.keys.toList()..sort();
  }

  /// Renders [offset] as `+HH:MM` / `-HH:MM`.
  static String offsetSuffix(Duration offset) {
    final abs = offset.abs();
    final sign = offset.isNegative ? '-' : '+';
    final hh = abs.inHours.toString().padLeft(2, '0');
    final mm = (abs.inMinutes % 60).toString().padLeft(2, '0');
    return '$sign$hh:$mm';
  }
}
