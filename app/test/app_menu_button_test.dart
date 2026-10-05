import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/presentation/home_page.dart';
import 'package:vsd/presentation/menu/app_menu.dart';
import 'package:vsd/presentation/menu/app_menu_button.dart';
import 'package:vsd/theme.dart';
import 'package:vsd_core/vsd_core.dart';

void main() {
  /// A desktop-sized surface; HomePage's chrome overflows the 800x600 default.
  Future<void> pumpHomePage(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1440, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(theme: theme, home: const HomePage()));
    await tester.pumpAndSettle();
  }

  Future<void> open(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  Future<void> openMenu(WidgetTester tester) async {
    await tester.tap(find.byType(AppMenuButton));
    await tester.pumpAndSettle();
  }

  Future<void> press(WidgetTester tester, LogicalKeyboardKey key) async {
    await tester.sendKeyEvent(key);
    await tester.pumpAndSettle();
  }

  /// Zone rows carry their current offset, which moves with DST, so they are
  /// matched on the city rather than a label that changes twice a year. Region
  /// lists outgrow the screen and scroll, so the row is brought into view.
  Future<void> openZone(WidgetTester tester, String city) async {
    await tester.ensureVisible(find.textContaining(city));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining(city));
    await tester.pumpAndSettle();
  }

  tearDown(() {
    DisplayTime.zone = const DisplayZone.file();
    DisplayTime.fileZone = FileZone.unknown;
  });

  /// The platforms Flutter ships no menu delegate for — where PlatformMenuBar
  /// silently rendered nothing, which is the bug this widget exists to fix.
  final desktop = TargetPlatformVariant({TargetPlatform.linux, TargetPlatform.windows});

  testWidgets('the time zone picker works off macOS', (tester) async {
    await pumpHomePage(tester);

    expect(find.byType(AppMenuButton), findsOneWidget);
    expect(find.text('Time Zone'), findsNothing);

    await openMenu(tester);
    await open(tester, 'Time Zone');
    await open(tester, 'UTC');

    expect(DisplayTime.zone, const DisplayZone.utc());
    // Choosing an item closes the whole cascade.
    expect(find.text('Time Zone'), findsNothing);
  }, variant: desktop);

  testWidgets("the menus' items sit directly in the hamburger", (tester) async {
    await pumpHomePage(tester);
    await openMenu(tester);

    // Not under a View row, as they would be in a menu bar.
    expect(find.text('View'), findsNothing);
    expect(find.text('Show Year & Time Zone'), findsOneWidget);
    expect(find.text('Time Zone'), findsOneWidget);
  }, variant: desktop);

  testWidgets('a deep selection marks the trail to itself', (tester) async {
    await pumpHomePage(tester);

    await openMenu(tester);
    await open(tester, 'Time Zone');
    await open(tester, 'Other');
    await open(tester, 'Europe');
    await openZone(tester, 'Paris');

    expect(DisplayTime.zone, const DisplayZone.named('Europe/Paris'));

    // Reopening shows the checkmark at every level down to the leaf, so the
    // selection stays findable two submenus deep.
    await openMenu(tester);
    await open(tester, 'Time Zone');
    expect(checkedRow(tester, find.text('Other')), isTrue);

    await open(tester, 'Other');
    expect(checkedRow(tester, find.text('Europe')), isTrue);
    expect(checkedRow(tester, find.text('Asia')), isFalse);

    await open(tester, 'Europe');
    expect(checkedRow(tester, find.textContaining('Paris')), isTrue);
  }, variant: desktop);

  testWidgets('Show Year & Time Zone toggles and shows its state', (tester) async {
    await pumpHomePage(tester);

    await openMenu(tester);
    expect(checkedRow(tester, find.text('Show Year & Time Zone')), isTrue);

    await open(tester, 'Show Year & Time Zone');

    await openMenu(tester);
    expect(checkedRow(tester, find.text('Show Year & Time Zone')), isFalse);
  }, variant: desktop);

  testWidgets('a submenu opens beside its row, first rows level', (tester) async {
    await pumpHomePage(tester);

    await openMenu(tester);
    await open(tester, 'Time Zone');

    final parent = tester.getTopLeft(find.text('Time Zone'));
    final child = tester.getTopLeft(find.text('UTC'));
    // VS Code sets a submenu 4px above its row, which with the 1px border and
    // 4px padding leaves its first row 1px lower. UTC is the row below that.
    expect(child.dy - parent.dy, 1 + 24);
    expect(child.dx, greaterThan(parent.dx));
  }, variant: desktop);

  testWidgets('hovering a submenu row opens it after a pause', (tester) async {
    await pumpHomePage(tester);
    await openMenu(tester);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: tester.getCenter(find.byType(AppMenuButton)));
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(find.text('Time Zone')));

    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('UTC'), findsNothing);

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
    expect(find.text('UTC'), findsOneWidget);
  }, variant: desktop);

  testWidgets('a keyboard move cancels a submenu the pointer was opening', (tester) async {
    await pumpHomePage(tester);
    await openMenu(tester);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: tester.getCenter(find.byType(AppMenuButton)));
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(find.text('Time Zone')));
    await tester.pump(const Duration(milliseconds: 100));

    // Up to Show Year & Time Zone, inside Time Zone's hover delay.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('UTC'), findsNothing);
  }, variant: desktop);

  testWidgets('the keyboard walks the cascade', (tester) async {
    await pumpHomePage(tester);
    await openMenu(tester);

    // Down lands on Show Year & Time Zone, then skips the separator to Time
    // Zone; Right opens it on its first zone.
    await press(tester, LogicalKeyboardKey.arrowDown);
    await press(tester, LogicalKeyboardKey.arrowDown);
    await press(tester, LogicalKeyboardKey.arrowRight);
    expect(find.text('UTC'), findsOneWidget);

    await press(tester, LogicalKeyboardKey.arrowDown);
    await press(tester, LogicalKeyboardKey.enter);

    // UTC, the second zone.
    expect(DisplayTime.zone, const DisplayZone.utc());
    expect(find.text('Time Zone'), findsNothing);
  }, variant: desktop);

  testWidgets('Escape closes one level at a time', (tester) async {
    await pumpHomePage(tester);
    await openMenu(tester);
    await open(tester, 'Time Zone');

    await press(tester, LogicalKeyboardKey.escape);
    expect(find.text('UTC'), findsNothing);
    expect(find.text('Time Zone'), findsOneWidget);

    await press(tester, LogicalKeyboardKey.escape);
    expect(find.text('Time Zone'), findsNothing);
  }, variant: desktop);

  testWidgets('tapping outside closes the menu', (tester) async {
    await pumpHomePage(tester);
    await openMenu(tester);
    await open(tester, 'Time Zone');

    await tester.tapAt(const Offset(1200, 600));
    await tester.pumpAndSettle();

    expect(find.text('Time Zone'), findsNothing);
    expect(find.text('UTC'), findsNothing);
  }, variant: desktop);

  testWidgets('an open menu takes up new menus in place', (tester) async {
    final menus = ValueNotifier(_zoneMenus('old'));
    addTearDown(menus.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: ValueListenableBuilder(
              valueListenable: menus,
              builder: (context, value, _) => AppMenuButton(menus: value),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(AppMenuButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zone'));
    await tester.pumpAndSettle();
    expect(find.text('File (old)'), findsOneWidget);

    // As when a file finishes loading under the open menu.
    menus.value = _zoneMenus('new');
    await tester.pumpAndSettle();

    expect(find.text('File (old)'), findsNothing);
    expect(find.text('File (new)'), findsOneWidget);
  });
}

/// One menu with a submenu whose label carries [offset], standing in for the
/// File zone's label that changes with each loaded file.
List<AppSubmenu> _zoneMenus(String offset) => [
  AppSubmenu(
    label: 'View',
    entries: [
      AppSubmenu(
        label: 'Zone',
        entries: [AppMenuItem(label: 'File ($offset)', onSelected: () {})],
      ),
    ],
  ),
];

/// Whether the open menu row holding [label] carries a checkmark.
bool checkedRow(WidgetTester tester, Finder label) => tester
    .widgetList(
      find.descendant(
        of: find.ancestor(of: label, matching: find.byType(Row)),
        matching: find.byIcon(Icons.check),
      ),
    )
    .isNotEmpty;
