import 'dart:convert';
import 'dart:typed_data';

import 'package:vsd_core/src/models/display_time.dart';
import 'package:vsd_core/src/models/file_zone.dart';
import 'package:vsd_core/src/models/process.dart';
import 'package:vsd_core/src/models/stat_type.dart';
import 'package:vsd_core/src/models/statistic.dart';
import 'package:vsd_core/src/models/time_series.dart';
import 'package:vsd_core/src/stat_definitions.g.dart';

import 'platform/parse_host_web.dart'
    if (dart.library.io) 'platform/parse_host_io.dart'
    as host;

class DataManager {
  factory DataManager() {
    return _instance;
  }

  DataManager._internal();
  static final DataManager _instance = DataManager._internal();

  final Map<int, StatType> statTypes = {}; // Keyed by stat type ID
  final Map<String, List<Process>> processes =
      {}; // Keyed by process name, contains list of processes
  final Map<String, Statistic> statistics = {}; // Keyed by statistic name

  /// Get all processes flattened into a single list
  List<Process> get allProcesses {
    return processes.values.expand((list) => list).toList();
  }

  /// Load and parse data from a statmon file (optionally gzip-compressed).
  ///
  /// Not available on the web, which has no file system; use [loadFromBytes].
  Future<void> loadFromFile(String path, {void Function(double)? onProgress}) {
    return _load(host.fileReader(path), onProgress: onProgress);
  }

  /// Load and parse the contents of a statmon file (optionally
  /// gzip-compressed, detected from the bytes). Works on every platform.
  Future<void> loadFromBytes(
    Uint8List bytes, {
    void Function(double)? onProgress,
  }) {
    return _load(() => bytes, onProgress: onProgress);
  }

  Future<void> _load(
    Uint8List Function() read, {
    void Function(double)? onProgress,
  }) async {
    statTypes.clear();
    processes.clear();
    DisplayTime.fileZone = FileZone.unknown;

    // On native platforms this runs on an isolate so the UI isn't blocked.
    final result = await host.runParse(
      _parseJob(read, Map.from(statistics)),
      onProgress: onProgress,
    );
    statTypes.addAll(result.statTypes);
    processes.addAll(result.processes);
    // Only the file's own zone changes here; the user's display-zone
    // selection deliberately survives a file load.
    DisplayTime.fileZone = FileZone(
      offsetMs: result.fileUtcOffsetMs,
      abbreviation: result.fileZoneAbbreviation,
    );
  }

  // Static so the job closure captures only [read] and [statistics]: it may be
  // sent to another isolate.
  static Future<_ParseResult> Function(void Function(double) progress)
  _parseJob(Uint8List Function() read, Map<String, Statistic> statistics) {
    return (progress) async {
      progress(0.02);
      final bytes = read();
      final content = utf8.decode(
        _isGzip(bytes) ? host.decodeGzip(bytes) : bytes,
      );
      if (!content.contains('ENDHEADER')) {
        throw const FormatException(
          'Not a valid statmon file: missing ENDHEADER',
        );
      }
      progress(0.05);
      final parsedStatTypes = parseStatTypes(content, statistics);
      progress(0.1);
      final parsed = await _parseProcesses(
        content,
        parsedStatTypes,
        onProgress: (p) => progress(0.1 + 0.9 * p),
      );
      return (
        statTypes: parsedStatTypes,
        processes: parsed,
        fileUtcOffsetMs: parseUtcOffsetMs(content),
        fileZoneAbbreviation: parseZoneAbbreviation(content),
      );
    };
  }

  static bool _isGzip(Uint8List bytes) =>
      bytes.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b;

  /// Load and parse statistics definitions from the embedded vsd.stats.tcl.
  ///
  /// The definitions ship base64-encoded in [statDefinitionsB64] so this
  /// pure-Dart package needs no Flutter asset bundle. See
  /// `tool/gen_stat_definitions.dart` to regenerate.
  Future<void> loadStatistics() async {
    final content = utf8.decode(base64.decode(statDefinitionsB64));

    // Parse statDocs for descriptions
    final Map<String, String> statDocs = {};
    final docsStartIndex = content.indexOf('array set statDocs {');
    if (docsStartIndex != -1) {
      // Find the matching closing brace by counting braces
      final startBrace = content.indexOf(
        '{',
        docsStartIndex + 'array set statDocs'.length,
      );
      int braceCount = 1;
      int endBrace = startBrace + 1;

      while (braceCount > 0 && endBrace < content.length) {
        if (content[endBrace] == '{') {
          braceCount++;
        } else if (content[endBrace] == '}') {
          braceCount--;
        }
        endBrace++;
      }

      final docsContent = content.substring(startBrace + 1, endBrace - 1);

      // Match each {StatName} "Description" pair
      final docEntries = RegExp(
        r'\{([^}]+)\}\s*"([^"]*(?:""[^"]*)*)"',
        dotAll: true,
      ).allMatches(docsContent);

      for (final match in docEntries) {
        final name = match.group(1)!.trim();
        final description = match.group(2)!.trim();
        statDocs[name] = description;
      }
    }

    // Parse statDefinitions for type, level, units, isOs
    final defsStartIndex = content.indexOf('array set statDefinitions {');
    if (defsStartIndex != -1) {
      // Find the matching closing brace by counting braces
      final startBrace = content.indexOf(
        '{',
        defsStartIndex + 'array set statDefinitions'.length,
      );
      int braceCount = 1;
      int endBrace = startBrace + 1;

      while (braceCount > 0 && endBrace < content.length) {
        if (content[endBrace] == '{') {
          braceCount++;
        } else if (content[endBrace] == '}') {
          braceCount--;
        }
        endBrace++;
      }

      final defsContent = content.substring(startBrace + 1, endBrace - 1);

      // Match each {StatName} {type level units isOs} pair
      final defEntries = RegExp(
        r'\{([^}]+)\}\s*\{([^}]+)\}',
        dotAll: true,
      ).allMatches(defsContent);

      for (final match in defEntries) {
        final name = match.group(1)!.trim();
        final params = RegExp(r'"[^"]*"|\S+')
            .allMatches(match.group(2)!.trim())
            .map((m) => m.group(0)!.replaceAll('"', ''))
            .toList();

        if (params.length >= 4) {
          final type = params[0];
          final level = params[1];
          final units = params[2];
          final isOs = params[3] == 'true';
          final description = statDocs[name] ?? '';

          statistics[name] = Statistic(
            name: name,
            type: type,
            level: level,
            units: units,
            isOs: isOs,
            description: description,
          );
        }
      }
    }
  }

  static Map<int, StatType> parseStatTypes(
    String content,
    Map<String, Statistic> statistics,
  ) {
    final statTypes = <int, StatType>{};
    final match = RegExp(
      r'StatTypes = \[(.*?)\]',
      dotAll: true,
    ).firstMatch(content);

    if (match != null) {
      final types = match.group(1)!.split(',');
      for (final type in types) {
        final typeMatch = RegExp(
          r'(\w+)\s*\(\s*(.*?)\s*\)\s*(\d+)',
          dotAll: true,
        ).firstMatch(type.trim());
        if (typeMatch != null) {
          final id = int.parse(typeMatch.group(3)!);
          final statNames = typeMatch
              .group(2)!
              .trim()
              .split(RegExp(r'\s+'))
              .where((s) => s.isNotEmpty)
              .toList();

          // Look up Statistic objects by name, skipping the first 6 header fields
          // (StatTypeNum, Time, ProcessName, ProcessId, SessionId, CacheSerialNum)
          final stats = <Statistic>[];
          for (final statName in statNames.skip(6)) {
            if (statistics.containsKey(statName)) {
              stats.add(statistics[statName]!);
            }
          }

          statTypes[id] = StatType(
            id: id,
            name: typeMatch.group(1)!,
            statistics: stats,
          );
        }
      }
    }

    return statTypes;
  }

  static String? _headerTimeField(String content) {
    final header = content.substring(
      0,
      content.length < 4096 ? content.length : 4096,
    );
    return RegExp(
      r'^Time\s*=\s*"(.*)"',
      multiLine: true,
    ).firstMatch(header)?.group(1);
  }

  /// Parse the UTC offset recorded in the file header's Time field, e.g.
  /// `Time = "05/21/2026 00:00:02 -03"` or `Time = "2026-02-19T16:09:13.930-08:00"`.
  /// Returns null when the header carries no numeric offset (e.g. a named
  /// timezone like "MEST"), in which case the viewer's timezone is used.
  static int? parseUtcOffsetMs(String content) {
    final timeLine = _headerTimeField(content);
    if (timeLine == null) {
      return null;
    }
    final offset = RegExp(
      r'([+-])(\d{1,2}):?(\d{2})?\s*$',
    ).firstMatch(timeLine);
    if (offset == null) {
      return null;
    }
    final sign = offset.group(1) == '-' ? -1 : 1;
    final hours = int.parse(offset.group(2)!);
    final minutes = int.parse(offset.group(3) ?? '0');
    return sign * (hours * 60 + minutes) * 60 * 1000;
  }

  /// The zone abbreviation in the header's Time field, e.g. `MEST` in
  /// `Time = "20/08/11 06:55:32 MEST"`. Display only: an abbreviation is
  /// ambiguous, so it tells the user why times fall back to their own zone
  /// rather than resolving to one. Null when the header gave a numeric offset.
  static String? parseZoneAbbreviation(String content) {
    final timeLine = _headerTimeField(content);
    if (timeLine == null || parseUtcOffsetMs(content) != null) {
      return null;
    }
    return RegExp(r'\s([A-Za-z]{2,5})\s*$').firstMatch(timeLine)?.group(1);
  }

  /// Parses the sample lines after ENDHEADER. Async only so it can yield to
  /// the event loop between chunks: on the web this runs on the UI thread.
  static Future<Map<String, List<Process>>> _parseProcesses(
    String content,
    Map<int, StatType> statTypes, {
    void Function(double)? onProgress,
  }) async {
    final processes = <String, List<Process>>{};
    final processesRaw = content.split('ENDHEADER')[1].trim().split('\n');
    final total = processesRaw.length;
    final step = (total / 100).ceil().clamp(1, total);
    for (int i = 0; i < processesRaw.length; i++) {
      if (i % step == 0) {
        onProgress?.call(i / total);
        await Future<void>.delayed(Duration.zero);
      }
      final line = processesRaw[i];
      final parts = line.split(' ');

      final processName = parts[2];
      final statTypeId = int.parse(parts[0]);
      // Session ID and Process ID are null if they're not positive
      final processId = int.parse(parts[3]) > 0 ? int.parse(parts[3]) : null;
      final sessionId = int.parse(parts[4]) > 0 ? int.parse(parts[4]) : null;
      // Timestamps are stored as true instants; the zone they are shown in is
      // applied only when formatting, by DisplayTime.
      final timestampMs = int.parse(parts[1]) * 1000;
      final timestamp = DateTime.fromMillisecondsSinceEpoch(
        timestampMs,
        isUtc: true,
      );

      // Initialize list for this process name if it doesn't exist
      if (!processes.containsKey(processName)) {
        processes[processName] = [];
      }

      // Find existing process with matching StatTypeNum, ProcessName, ProcessId, SessionId
      Process? existingProcess;
      for (final process in processes[processName]!) {
        if (process.type.id == statTypeId &&
            process.name == processName &&
            process.processId == processId &&
            process.sessionId == sessionId) {
          existingProcess = process;
          break;
        }
      }

      if (existingProcess != null) {
        // Samples for a process are expected to be strictly increasing in time.
        // statmonitor can occasionally emit an out-of-order or duplicate record
        // (e.g. a stale sample re-appended at the end of the file); skip it so
        // the sample count stays accurate and the chart's domain (which assumes
        // points are chronologically ordered) isn't collapsed by a rogue point.
        if (timestampMs <= existingProcess.endTime.millisecondsSinceEpoch) {
          continue;
        }

        // Update end time if process already exists (handles multiple entries for same process)
        existingProcess.endTime = timestamp;
        existingProcess.samples += 1;

        // Add new data points to existing process
        for (
          int statIdx = 0;
          statIdx < existingProcess.type.statistics.length;
          statIdx++
        ) {
          final stat = existingProcess.type.statistics[statIdx];

          existingProcess.statisticData[stat.name]!.add(
            timestampMs,
            _parseStatValue(parts[statIdx + 6], stat.type).toDouble(),
          );
        }
      } else {
        // Otherwise, create new process entry
        final newProcess = Process(
          name: processName,
          type: statTypes[statTypeId]!,
          startTime: timestamp,
          endTime: timestamp,
          samples: 1,
          processId: processId,
          sessionId: sessionId,
        );

        // Initialize TimeSeries for each statistic in the StatType
        for (
          int statIdx = 0;
          statIdx < newProcess.type.statistics.length;
          statIdx++
        ) {
          final stat = newProcess.type.statistics[statIdx];

          newProcess.statisticData[stat.name] = TimeSeries(statistic: stat)
            ..add(
              timestampMs,
              _parseStatValue(parts[statIdx + 6], stat.type).toDouble(),
            );
        }

        processes[processName]!.add(newProcess);
      }
    }

    return processes;
  }

  /// Find a process by its unique identifiers: StatTypeNum, ProcessName, ProcessId, SessionId
  Process? findProcess({
    required int statTypeId,
    required String processName,
    required int? processId,
    required int? sessionId,
  }) {
    final processList = processes[processName];
    if (processList == null) {
      return null;
    }

    for (final process in processList) {
      if (process.type.id == statTypeId &&
          process.name == processName &&
          process.processId == processId &&
          process.sessionId == sessionId) {
        return process;
      }
    }
    return null;
  }
}

typedef _ParseResult = ({
  Map<int, StatType> statTypes,
  Map<String, List<Process>> processes,
  int? fileUtcOffsetMs,
  String? fileZoneAbbreviation,
});

/// Parses a raw string value from the data file into the correct [num] type.
///
/// For "float" statistics the file stores the IEEE 754 bit pattern of a
/// 32-bit float as a plain integer string. We parse that integer and then
/// reinterpret its lower 32 bits as a [double] via [ByteData]. All other
/// statistic types are stored as regular integers.
num _parseStatValue(String raw, String type) {
  if (type == 'float') {
    final bits = int.tryParse(raw);
    if (bits == null) {
      return 0.0;
    }
    final bd = ByteData(4);
    bd.setUint32(0, bits & 0xFFFFFFFF);
    return bd.getFloat32(0);
  }
  return int.tryParse(raw) ?? 0;
}
