@TestOn('browser')
library;

import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsd/presentation/home_page.dart';
import 'package:vsd_core/vsd_core.dart';
import 'package:web/web.dart' as web;

// Plays the part of a VS Code extension hosting the app in a webview.

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

/// Messages the app posted to the "extension".
final _posted = <Object?>[];

void _installFakeVsCodeApi() {
  final api = JSObject()
    ..setProperty(
      'postMessage'.toJS,
      ((JSAny? message) => _posted.add(message.dartify())).toJS,
    );
  globalContext.setProperty('acquireVsCodeApi'.toJS, (() => api).toJS);
}

/// A URL the app can fetch, as a webview URI would be.
String _fileUrl() => web.URL.createObjectURL(
  web.Blob([utf8.encode(_statmon).toJS].toJS),
);

void main() {
  setUpAll(() async {
    _installFakeVsCodeApi();
    await DataManager().loadStatistics();
  });

  Future<void> waitFor(WidgetTester tester, Finder finder) async {
    for (var i = 0; i < 50 && finder.evaluate().isEmpty; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 20));
    }
  }

  testWidgets('opens the file the host sends, and asks the host to pick one', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view
      ..physicalSize = const Size(1440, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();
    expect(_posted, [
      {'type': 'ready'},
    ]);

    web.window.postMessage(
      {'type': 'open', 'url': _fileUrl(), 'name': 'statmon.out.gz'}.jsify(),
      '*'.toJS,
    );
    await waitFor(tester, find.text('ShrPcMonitor'));

    // The name the host gave, without .gz, and the file's processes.
    expect(find.text('statmon.out'), findsOneWidget);
    expect(find.text('ShrPcMonitor'), findsWidgets);

    // Embedded, the host has the files, so tapping the file bar asks it.
    await tester.tap(find.text('statmon.out'));
    await tester.pump();
    expect(_posted.last, {'type': 'pickFile'});
    // HomePage's menu bar holds macOS-only items; other platforms throw while
    // serializing it in tests, as in home_page_menu_test.dart.
  }, variant: TargetPlatformVariant.only(TargetPlatform.macOS));

  testWidgets('shows an error when the host sends a file it cannot read', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view
      ..physicalSize = const Size(1440, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    final missing = _fileUrl();
    web.URL.revokeObjectURL(missing);
    web.window.postMessage({'type': 'open', 'url': missing}.jsify(), '*'.toJS);
    await waitFor(tester, find.textContaining('Error loading file'));

    expect(find.textContaining('Could not read'), findsOneWidget);
  }, variant: TargetPlatformVariant.only(TargetPlatform.macOS));
}
