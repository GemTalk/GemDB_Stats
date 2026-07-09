/// Timezone context of the currently loaded statmon file.
///
/// Timestamps are stored shifted to the file's recorded timezone and exposed
/// as UTC DateTimes so they format as the server's wall-clock time. When
/// exporting, the misleading 'Z' suffix is replaced with the file's real
/// UTC offset. Set by DataManager when a file loads.
class FileTime {
  static int utcOffsetMs = 0;

  /// Format a file-timezone wall-clock DateTime as ISO-8601 with the file's
  /// real UTC offset, e.g. `2026-05-21T00:00:03.000-03:00`.
  static String format(DateTime t) {
    final abs = utcOffsetMs.abs();
    final sign = utcOffsetMs < 0 ? '-' : '+';
    final hh = (abs ~/ 3600000).toString().padLeft(2, '0');
    final mm = ((abs % 3600000) ~/ 60000).toString().padLeft(2, '0');
    return t.toIso8601String().replaceFirst('Z', '$sign$hh:$mm');
  }

  /// Inverse of [format]: parses an ISO-8601 string back into the internal
  /// wall-clock-as-UTC representation. Any trailing offset (or 'Z') is
  /// ignored, because internally timestamps already carry the file's
  /// wall-clock time. Returns null if [s] is not a valid ISO-8601 timestamp.
  static DateTime? parse(String s) {
    final wallClock = s.trim().replaceFirst(
      RegExp(r'(Z|[+-]\d{2}:?\d{2})$'),
      '',
    );
    final parsed = DateTime.tryParse('${wallClock}Z') ??
        DateTime.tryParse('${wallClock}T00:00:00Z');
    return parsed?.toUtc();
  }
}
