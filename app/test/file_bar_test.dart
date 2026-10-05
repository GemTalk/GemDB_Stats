import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsd/presentation/file_bar.dart';

const _longName = 'statmonitor_tanistone_production_cluster_2026-05-27T00-00-00.out.gz';
const _shown = 'statmonitor_tanistone_production_cluster_2026-05-27T00-00-00.out';

class _FakeFilePicker extends FilePicker {
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
  }) async => FilePickerResult([
    PlatformFile(name: _longName, path: '/stats/$_longName', size: 0),
  ]);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FilePicker.platform = _FakeFilePicker();
  });

  /// Shows a long file name in a bar [width] wide, with a stand-in for the
  /// 32-pixel menu button.
  Future<void> pumpBar(WidgetTester tester, double width, {bool leading = true}) async {
    tester.view
      ..physicalSize = Size(width, 200)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FileBar(
            onFileSelected: (_) {},
            leading: leading ? const SizedBox(key: Key('menu'), width: 32, height: 32) : null,
          ),
        ),
      ),
    );
    await tester.tap(find.text('No file selected'));
    await tester.pumpAndSettle();
  }

  for (final width in [1280.0, 600.0, 300.0]) {
    testWidgets('a long name fits a $width-pixel bar beside the menu', (tester) async {
      await pumpBar(tester, width);

      expect(tester.takeException(), isNull, reason: 'no overflow');
      final menu = tester.getRect(find.byKey(const Key('menu')));
      final name = tester.getRect(find.byType(GestureDetector).first);
      expect(name.left, greaterThanOrEqualTo(menu.right), reason: 'clear of the menu');
      expect(name.right, lessThanOrEqualTo(width));
      expect(name.center.dx, closeTo(width / 2, 0.5), reason: 'centered');
    });
  }

  testWidgets('a name too long for the bar ends in an ellipsis', (tester) async {
    await pumpBar(tester, 300);

    final text = tester.renderObject<RenderParagraph>(find.text(_shown));
    expect(text.didExceedMaxLines, isTrue);
  });

  testWidgets('without a menu, the name keeps the narrow margins', (tester) async {
    await pumpBar(tester, 300, leading: false);

    expect(tester.takeException(), isNull);
    final name = tester.getRect(find.byType(GestureDetector).first);
    expect(name.left, closeTo(12, 0.5));
    expect(name.right, closeTo(300 - 12, 0.5));
  });
}
