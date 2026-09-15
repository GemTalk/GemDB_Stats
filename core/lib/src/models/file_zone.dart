/// The time zone a statmon file recorded in its header's `Time` field.
class FileZone {
  const FileZone({this.offsetMs, this.abbreviation});

  /// No file loaded, or the header carried no usable Time field.
  static const unknown = FileZone();

  /// Numeric UTC offset from the header, e.g. `-08:00` -> -8h in ms.
  /// Null if the header used an unresolvable name.
  final int? offsetMs;

  /// The zone abbreviation as written in the header. Display only.
  final String? abbreviation;
}
