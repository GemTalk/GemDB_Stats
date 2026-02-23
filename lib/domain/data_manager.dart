import 'package:vsd/data/test.dart';
import 'package:vsd/domain/models/stat_type.dart';
import 'package:vsd/domain/models/process.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();

  final Map<int, StatType> statTypes = {}; // Keyed by stat type ID
  final Map<String, Process> processes = {}; // Keyed by process name

  DataManager._internal();

  factory DataManager() {
    return _instance;
  }

  void loadData() {
    print('DataManager loading data...');
    _instance.loadStatTypes();
    _instance.loadProcesses();
  }

  void loadStatTypes() {
    final content = testData;

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
          statTypes[id] = StatType(
            id: id,
            name: typeMatch.group(1)!,
            statistics: typeMatch
                .group(2)!
                .split('\n')
                .map((s) => s.trim())
                .toList(),
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
      final timestamp = DateTime.fromMillisecondsSinceEpoch(
        int.parse(parts[1]) * 1000,
      );

      if (processes.containsKey(processName)) {
        // Update end time if process already exists (handles multiple entries for same process)
        processes[processName]!.endTime = timestamp;
        processes[processName]!.samples += 1;
        continue;
      } else {
        // Otherwise, create new process entry
        processes[processName] = Process(
          name: parts[2],
          type: statTypes[int.parse(parts[0])]!,
          startTime: timestamp,
          endTime: timestamp,
          samples: 1,
          processId: int.parse(parts[3]),
          sessionId: '',
        );
      }
    }
  }
}
