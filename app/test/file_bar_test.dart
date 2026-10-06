import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/presentation/file_bar.dart';

const _longName = 'statmonitor_tanistone_production_cluster_2026-05-27T00-00-00.out.gz';
const _shown = 'statmonitor_tanistone_production_cluster_2026-05-27T00-00-00.out';

void main() {
  /// Shows a long file name in a bar [width] wide, with a stand-in for the
  /// 32-pixel menu button and, if [trailing], the 28-pixel chat button.
  Future<void> pumpBar(
    WidgetTester tester,
    double width, {
    bool leading = true,
    bool trailing = false,
  }) async {
    tester.view
      ..physicalSize = Size(width, 200)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FileBar(
            fileName: _longName,
            onTap: () {},
            leading: leading ? const SizedBox(key: Key('menu'), width: 32, height: 32) : null,
            trailing: trailing ? const SizedBox(key: Key('chat'), width: 28, height: 28) : null,
          ),
        ),
      ),
    );
    await tester.pump();
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

  for (final width in [1280.0, 600.0, 300.0]) {
    testWidgets('a long name and the chat button fit a $width-pixel bar', (tester) async {
      await pumpBar(tester, width, trailing: true);

      expect(tester.takeException(), isNull, reason: 'no overflow');
      final menu = tester.getRect(find.byKey(const Key('menu')));
      final name = tester.getRect(find.byType(GestureDetector).first);
      final chat = tester.getRect(find.byKey(const Key('chat')));
      expect(name.left, greaterThanOrEqualTo(menu.right), reason: 'clear of the menu');
      expect(chat.left, greaterThanOrEqualTo(name.right), reason: 'beside the name');
      expect(chat.right, lessThanOrEqualTo(width));
      // The chat button stays beside the name, so the two are centered
      // together, as before the menu button was added.
      expect((name.left + chat.right) / 2, closeTo(width / 2, 0.5), reason: 'centered together');
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
