import 'package:flutter/services.dart';
import 'package:vsd/data/test.dart';
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

  Future<void> loadAll() async {
    await _instance.loadStatistics();
    _instance.loadStatTypes();
    _instance.loadProcesses();
  }

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
        final params = match.group(2)!.trim().split(RegExp(r'\s+'));

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

  void loadStatTypes() {
    final content = testData;

    final match = RegExp(r'StatTypes = \[(.*?)\]', dotAll: true).firstMatch(content);

    if (match != null) {
      final types = match.group(1)!.split(',');
      for (final type in types) {
        final typeMatch = RegExp(r'(\w+)\s*\(\s*(.*?)\s*\)\s*(\d+)', dotAll: true).firstMatch(type.trim());
        if (typeMatch != null) {
          final id = int.parse(typeMatch.group(3)!);
          final statNames = typeMatch.group(2)!.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

          // Look up Statistic objects by name
          final stats = <Statistic>[];
          for (final statName in statNames) {
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
  }

  void loadProcesses() {
    final content = testData;

    final processesRaw = content.split('ENDHEADER')[1].trim().split('\n');
    for (final line in processesRaw) {
      final parts = line.split(' ');

      final processName = parts[2];
      final statTypeId = int.parse(parts[0]);
      final processId = int.parse(parts[3]);
      final sessionId = parts.length > 4 ? parts[4] : '';
      final timestamp = DateTime.fromMillisecondsSinceEpoch(int.parse(parts[1]) * 1000);

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
        for (int i = 5; i < existingProcess.type.statistics.length; i++) {
          final stat = existingProcess.type.statistics[i];

          existingProcess.statisticData[stat.name]!.points.add(
            DataPoint(timestamp: timestamp, value: int.tryParse(parts[i]) ?? 0),
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
        for (int i = 5; i < newProcess.type.statistics.length; i++) {
          final stat = newProcess.type.statistics[i];

          newProcess.statisticData[stat.name] = TimeSeries(
            statistic: stat,
            points: [DataPoint(timestamp: timestamp, value: int.tryParse(parts[i]) ?? 0)],
          );
        }

        processes[processName]!.add(newProcess);
      }
    }
  }

  /// Find a process by its unique identifiers: StatTypeNum, ProcessName, ProcessId, SessionId
  Process? findProcess({
    required int statTypeId,
    required String processName,
    required int processId,
    required String sessionId,
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
