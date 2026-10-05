import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsd/presentation/home_page.dart';
import 'package:vsd_core/vsd_core.dart';

// Also run in a browser (`flutter test --platform chrome`), so it can't read
// fixture files: the statmon file is built inline.
const _statmon = '''
STATMON "4"
Time = "2026-02-19T16:09:13.930-08:00"
StatTypes = [
Shrpc  ( StatTypeNum Time ProcessName ProcessId SessionId CacheSerialNum DataPageReads ) 1
]
ENDHEADER
1 1771546154 ShrPcMonitor 18322 -1 0 10
1 1771546155 ShrPcMonitor 18322 -1 0 12
''';

/// Returns a file the way the web picker does: a stream and no path.
class _FakeFilePicker extends FilePicker {
  bool? withReadStream;
  int calls = 0;

  /// When set, the picker stays open until this completes.
  Completer<void>? open;

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = false,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async {
    this.withReadStream = withReadStream;
    calls++;
    await open?.future;
    final bytes = Uint8List.fromList(utf8.encode(_statmon));
    return FilePickerResult([
      PlatformFile(
        name: 'statmon.out',
        size: bytes.length,
        readStream: Stream.value(bytes),
      ),
    ]);
  }
}

void main() {
  setUpAll(() => DataManager().loadStatistics());

  testWidgets('a picked file with a stream and no path loads and lists its processes', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final picker = _FakeFilePicker();
    FilePicker.platform = picker;
    tester.view
      ..physicalSize = const Size(1440, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('No file selected'));
    // On the VM the parse runs on a real isolate, outside the fake clock; on
    // the web it runs here and yields on fake timers, so advance both.
    for (var i = 0; i < 50 && find.text('ShrPcMonitor').evaluate().isEmpty; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 20));
    }

    // The picker is asked for a stream only where there's no file system.
    expect(picker.withReadStream, kIsWeb);
    expect(find.text('statmon.out'), findsOneWidget);
    expect(find.text('ShrPcMonitor'), findsWidgets);
    // HomePage's menu bar holds macOS-only items; other platforms throw while
    // serializing it in tests, as in home_page_menu_test.dart.
  }, variant: TargetPlatformVariant.only(TargetPlatform.macOS));

  testWidgets('a second click while the picker is open opens no second picker', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final picker = _FakeFilePicker()..open = Completer<void>();
    FilePicker.platform = picker;
    tester.view
      ..physicalSize = const Size(1440, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('No file selected'));
    await tester.pump();
    await tester.tap(find.text('No file selected'));
    await tester.pump();
    expect(picker.calls, 1);

    picker.open!.complete();
    for (var i = 0; i < 50 && find.text('ShrPcMonitor').evaluate().isEmpty; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 20));
    }
    expect(find.text('ShrPcMonitor'), findsWidgets);
  }, variant: TargetPlatformVariant.only(TargetPlatform.macOS));
}
