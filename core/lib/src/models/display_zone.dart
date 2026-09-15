import 'package:timezone/timezone.dart' as tz;
import 'package:vsd_core/src/models/display_time.dart';

/// A zone used when rendering timestamps.
///
/// Timestamps are stored as instants; [DisplayZone.file] reads
/// [DisplayTime.fileZone] at call time so a newly loaded file updates the
/// "File" zone without changing the user's selection.
sealed class DisplayZone {
  const DisplayZone();

  const factory DisplayZone.file() = FileDisplayZone;
  const factory DisplayZone.utc() = UtcDisplayZone;
  const factory DisplayZone.systemLocal() = SystemLocalDisplayZone;
  const factory DisplayZone.named(String location) = NamedDisplayZone;

  /// The UTC offset in effect in this zone at [instant].
  Duration offsetAt(DateTime instant);

  /// [instant] rendered so its field getters (`year`, `hour`, ...) read as this
  /// zone's wall clock. Safe to hand straight to `intl`'s `DateFormat`.
  DateTime wallClock(DateTime instant);

  /// Inverse of [wallClock]: [fields] carries wall-clock field values, and the
  /// result is the instant they name in this zone.
  DateTime instantFrom(DateTime fields);

  /// The zone abbreviation in effect at [instant] ("PDT", "+0530").
  String abbreviationAt(DateTime instant);

  /// Short name for menus and status text.
  String get label;

  /// The parenthetical detail this zone resolves to at [instant], e.g.
  /// `(EDT, UTC-04:00)`.
  ///
  /// Zones whose "abbreviation" is just the numeric offset — Kathmandu reports
  /// `+0545` — would otherwise say it twice, so those get the offset alone.
  /// Exposed separately from [describeAt] for callers that supply their own
  /// name, such as the menu's city-only entries.
  String detailAt(DateTime instant) {
    final offset = 'UTC${DisplayTime.offsetSuffix(offsetAt(instant))}';
    final abbr = abbreviationAt(instant);
    return abbr.startsWith('+') || abbr.startsWith('-')
        ? '($offset)'
        : '($abbr, $offset)';
  }

  /// Menu/status label naming this zone and the offset it resolves to at
  /// [instant], e.g. `Europe/Paris (CEST, UTC+02:00)`.
  String describeAt(DateTime instant) => '$label ${detailAt(instant)}';
}

/// Whatever zone the loaded file recorded.
/// Falls back to the viewer's own zone when the header cannot be resolved.
class FileDisplayZone extends DisplayZone {
  const FileDisplayZone();

  int? get _offsetMs => DisplayTime.fileZone.offsetMs;

  @override
  Duration offsetAt(DateTime instant) {
    final offsetMs = _offsetMs;
    return offsetMs == null
        ? instant.toLocal().timeZoneOffset
        : Duration(milliseconds: offsetMs);
  }

  @override
  DateTime wallClock(DateTime instant) {
    final offsetMs = _offsetMs;
    return offsetMs == null
        ? instant.toLocal()
        : instant.toUtc().add(Duration(milliseconds: offsetMs));
  }

  @override
  DateTime instantFrom(DateTime fields) {
    final offsetMs = _offsetMs;
    return offsetMs == null
        ? _asLocalFields(fields).toUtc()
        : fields.subtract(Duration(milliseconds: offsetMs));
  }

  @override
  String abbreviationAt(DateTime instant) => _offsetMs == null
      ? instant.toLocal().timeZoneName
      : DisplayTime.offsetSuffix(offsetAt(instant));

  @override
  String get label => 'File';

  /// When the header named a zone we could not resolve we are silently showing
  /// the viewer's own clock, so say so rather than leave "File" a mystery.
  @override
  String describeAt(DateTime instant) {
    if (_offsetMs != null) {
      return super.describeAt(instant);
    }
    final abbr = DisplayTime.fileZone.abbreviation;
    return abbr == null
        ? 'File (local, no zone in header)'
        : 'File (local, header said $abbr)';
  }

  @override
  bool operator ==(Object other) => other is FileDisplayZone;

  @override
  int get hashCode => (FileDisplayZone).hashCode;
}

class UtcDisplayZone extends DisplayZone {
  const UtcDisplayZone();

  @override
  Duration offsetAt(DateTime instant) => Duration.zero;

  @override
  DateTime wallClock(DateTime instant) => instant.toUtc();

  @override
  DateTime instantFrom(DateTime fields) => fields.toUtc();

  @override
  String abbreviationAt(DateTime instant) => 'UTC';

  @override
  String get label => 'UTC';

  /// "UTC (UTC+00:00)" says the same thing three times.
  @override
  String describeAt(DateTime instant) => 'UTC';

  @override
  bool operator ==(Object other) => other is UtcDisplayZone;

  @override
  int get hashCode => (UtcDisplayZone).hashCode;
}

/// The zone this machine is set to, DST included.
class SystemLocalDisplayZone extends DisplayZone {
  const SystemLocalDisplayZone();

  @override
  Duration offsetAt(DateTime instant) => instant.toLocal().timeZoneOffset;

  @override
  DateTime wallClock(DateTime instant) => instant.toLocal();

  @override
  DateTime instantFrom(DateTime fields) => _asLocalFields(fields).toUtc();

  @override
  String abbreviationAt(DateTime instant) => instant.toLocal().timeZoneName;

  @override
  String get label => 'This Computer';

  @override
  bool operator ==(Object other) => other is SystemLocalDisplayZone;

  @override
  int get hashCode => (SystemLocalDisplayZone).hashCode;
}

/// A named IANA zone such as `America/Los_Angeles`
class NamedDisplayZone extends DisplayZone {
  const NamedDisplayZone(this.location);

  final String location;

  tz.Location get _location {
    DisplayTime.ensureTimeZoneData();
    return tz.getLocation(location);
  }

  @override
  Duration offsetAt(DateTime instant) =>
      tz.TZDateTime.from(instant, _location).timeZoneOffset;

  @override
  DateTime wallClock(DateTime instant) =>
      tz.TZDateTime.from(instant, _location);

  @override
  DateTime instantFrom(DateTime fields) => tz.TZDateTime(
    _location,
    fields.year,
    fields.month,
    fields.day,
    fields.hour,
    fields.minute,
    fields.second,
    fields.millisecond,
  ).toUtc();

  @override
  String abbreviationAt(DateTime instant) =>
      tz.TZDateTime.from(instant, _location).timeZoneName;

  @override
  String get label => location;

  @override
  bool operator ==(Object other) =>
      other is NamedDisplayZone && other.location == location;

  @override
  int get hashCode => location.hashCode;
}

/// Rebuilds [fields] as a device-local DateTime carrying the same wall-clock
/// field values, so `.toUtc()` resolves them through the machine's zone rules.
DateTime _asLocalFields(DateTime fields) => DateTime(
  fields.year,
  fields.month,
  fields.day,
  fields.hour,
  fields.minute,
  fields.second,
  fields.millisecond,
);
