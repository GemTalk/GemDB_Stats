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
}
