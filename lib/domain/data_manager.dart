import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:vsd/domain/models/file_time.dart';
import 'package:vsd/domain/models/process.dart';
import 'package:vsd/domain/models/stat_type.dart';
import 'package:vsd/domain/models/statistic.dart';
import 'package:vsd/domain/models/time_series.dart';

class DataManager {
  factory DataManager() {
    return _instance;
  }

  DataManager._internal();
  static final DataManager _instance = DataManager._internal();

  final Map<int, StatType> statTypes = {}; // Keyed by stat type ID
  final Map<String, List<Process>> processes = {}; // Keyed by process name, contains list of processes
  final Map<String, Statistic> statistics = {}; // Keyed by statistic name

  /// Get all processes flattened into a single list
  List<Process> get allProcesses {
    return processes.values.expand((list) => list).toList();
  }

  /// Load and parse data from a statmon file (optionally gzip-compressed)
  Future<void> loadFromFile(String path, {void Function(double)? onProgress}) async {
    statTypes.clear();
    processes.clear();
    FileTime.utcOffsetMs = 0;

    // Use an isolate to read, decompress and parse the file without blocking the UI
    final receivePort = ReceivePort();
    await Isolate.spawn<_ParseArgs>(
      (_ParseArgs args) {
        try {
          args.sendPort.send(0.02);
          final bytes = File(args.path).readAsBytesSync();
          final content = args.path.endsWith('.gz') ? utf8.decode(gzip.decode(bytes)) : utf8.decode(bytes);
          if (!content.contains('ENDHEADER')) {
            args.sendPort.send('Not a valid statmon file: missing ENDHEADER');
            return;
          }
          args.sendPort.send(0.05);
          final parsedStatTypes = parseStatTypes(content, args.statistics);
          args.sendPort.send(0.1);
          final parsed = _parseProcesses(
            content,
            parsedStatTypes,
            utcOffsetMs: parseUtcOffsetMs(content),
            onProgress: (p) => args.sendPort.send(0.1 + 0.9 * p),
          );
          // Isolate.exit transfers ownership of the result without copying it,
          // unlike sendPort.send which deep-copies the whole object graph.
          Isolate.exit(args.sendPort, (
            statTypes: parsedStatTypes,
            processes: parsed.processes,
            utcOffsetMs: parsed.utcOffsetMs,
          ));
        } catch (e) {
          args.sendPort.send(e.toString());
        }
      },
      (sendPort: receivePort.sendPort, path: path, statistics: Map.from(statistics)),
    );

    // Listen for messages from the isolate
    await for (final message in receivePort) {
      if (message is double) {
        onProgress?.call(message);
      } else if (message is String) {
        receivePort.close();
        throw FormatException(message);
      } else {
        final result =
            message as ({Map<int, StatType> statTypes, Map<String, List<Process>> processes, int utcOffsetMs});
        statTypes.addAll(result.statTypes);
        processes.addAll(result.processes);
        FileTime.utcOffsetMs = result.utcOffsetMs;
        receivePort.close();
        break;
      }
    }
  }

  /// Load and parse statistics definitions from vsd.stats.tcl
  Future<void> loadStatistics() async {
    final content = await rootBundle.loadString('assets/vsd.stats.tcl');

    // Parse statDocs for descriptions
    final Map<String, String> statDocs = {};
    final docsStartIndex = content.indexOf('array set statDocs {');
    if (docsStartIndex != -1) {
      // Find the matching closing brace by counting braces
      final startBrace = content.indexOf('{', docsStartIndex + 'array set statDocs'.length);
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
      final startBrace = content.indexOf('{', defsStartIndex + 'array set statDefinitions'.length);
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
        final params = RegExp(
          r'"[^"]*"|\S+',
        ).allMatches(match.group(2)!.trim()).map((m) => m.group(0)!.replaceAll('"', '')).toList();

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

  static Map<int, StatType> parseStatTypes(String content, Map<String, Statistic> statistics) {
    final statTypes = <int, StatType>{};
    final match = RegExp(r'StatTypes = \[(.*?)\]', dotAll: true).firstMatch(content);

    if (match != null) {
      final types = match.group(1)!.split(',');
      for (final type in types) {
        final typeMatch = RegExp(r'(\w+)\s*\(\s*(.*?)\s*\)\s*(\d+)', dotAll: true).firstMatch(type.trim());
        if (typeMatch != null) {
          final id = int.parse(typeMatch.group(3)!);
          final statNames = typeMatch.group(2)!.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();

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

  /// Parse the UTC offset recorded in the file header's Time field, e.g.
  /// `Time = "05/21/2026 00:00:02 -03"` or `Time = "2026-02-19T16:09:13.930-08:00"`.
  /// Returns null when the header carries no numeric offset (e.g. a named
  /// timezone like "MEST"), in which case the viewer's timezone is used.
  static int? parseUtcOffsetMs(String content) {
    final header = content.substring(0, content.length < 4096 ? content.length : 4096);
    final timeLine = RegExp(r'^Time\s*=\s*"(.*)"', multiLine: true).firstMatch(header);
    if (timeLine == null) {
      return null;
    }
    final offset = RegExp(r'([+-])(\d{1,2}):?(\d{2})?\s*$').firstMatch(timeLine.group(1)!);
    if (offset == null) {
      return null;
    }
    final sign = offset.group(1) == '-' ? -1 : 1;
    final hours = int.parse(offset.group(2)!);
    final minutes = int.parse(offset.group(3) ?? '0');
    return sign * (hours * 60 + minutes) * 60 * 1000;
  }

  static ({Map<String, List<Process>> processes, int utcOffsetMs}) _parseProcesses(
    String content,
    Map<int, StatType> statTypes, {
    int? utcOffsetMs,
    void Function(double)? onProgress,
  }) {
    final processes = <String, List<Process>>{};
    final processesRaw = content.split('ENDHEADER')[1].trim().split('\n');
    final total = processesRaw.length;
    final step = (total / 100).ceil().clamp(1, total);
    for (int i = 0; i < processesRaw.length; i++) {
      if (onProgress != null && i % step == 0) {
        onProgress(i / total);
      }
      final line = processesRaw[i];
      final parts = line.split(' ');

      final processName = parts[2];
      final statTypeId = int.parse(parts[0]);
      // Session ID and Process ID are null if they're not positive
      final processId = int.parse(parts[3]) > 0 ? int.parse(parts[3]) : null;
      final sessionId = int.parse(parts[4]) > 0 ? int.parse(parts[4]) : null;
      // Shift timestamps to the file's recorded timezone and treat them as
      // UTC wall-clock values, so times display as the server saw them
      // regardless of the viewer's timezone.
      final rawMs = int.parse(parts[1]) * 1000;
      utcOffsetMs ??= DateTime.fromMillisecondsSinceEpoch(rawMs).timeZoneOffset.inMilliseconds;
      final timestampMs = rawMs + utcOffsetMs;
      final timestamp = DateTime.fromMillisecondsSinceEpoch(timestampMs, isUtc: true);

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
        // Update end time if process already exists (handles multiple entries for same process)
        existingProcess.endTime = timestamp;
        existingProcess.samples += 1;

        // Add new data points to existing process
        for (int statIdx = 0; statIdx < existingProcess.type.statistics.length; statIdx++) {
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
        for (int statIdx = 0; statIdx < newProcess.type.statistics.length; statIdx++) {
          final stat = newProcess.type.statistics[statIdx];

          newProcess.statisticData[stat.name] = TimeSeries(statistic: stat)
            ..add(timestampMs, _parseStatValue(parts[statIdx + 6], stat.type).toDouble());
        }

        processes[processName]!.add(newProcess);
      }
    }

    return (processes: processes, utcOffsetMs: utcOffsetMs ?? 0);
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

typedef _ParseArgs = ({SendPort sendPort, String path, Map<String, Statistic> statistics});

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
