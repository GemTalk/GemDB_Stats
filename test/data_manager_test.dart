import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/domain/data_manager.dart';

void main() {
  group('DataManager', () {
    test('loadStatTypes should parse stat types from file', () {
      final dataManager = DataManager();
      expect(dataManager.statTypes.isNotEmpty, true);
      expect(dataManager.statTypes.values.first.name, isNotEmpty);
      print(dataManager.processes.length);
    });
  });
}
