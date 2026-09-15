import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/presentation/home_page.dart';
import 'package:vsd_core/vsd_core.dart';

/// The exact list instance PlatformMenuBar holds — not a `cast` view, which
/// would be a fresh wrapper on every call and defeat the identity check.
List<PlatformMenuItem> _menus(WidgetTester tester) =>
    tester.widget<PlatformMenuBar>(find.byType(PlatformMenuBar)).menus;

PlatformMenu _timeZoneMenu(List<PlatformMenuItem> menus) => menus
    .whereType<PlatformMenu>()
    .firstWhere((m) => m.label == 'View')
    .menus
    .whereType<PlatformMenuItemGroup>()
    .expand((g) => g.members)
    .whereType<PlatformMenu>()
    .firstWhere((m) => m.label == 'Time Zone');

void main() {
  /// A desktop-sized surface; HomePage's chrome overflows the 800x600 default.
  Future<void> pumpHomePage(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1440, 900)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();
  }

  tearDown(() {
    DisplayTime.zone = const DisplayZone.file();
    DisplayTime.fileZone = FileZone.unknown;
  });

  // The menu bar uses PlatformProvidedMenuItems, which only exist on macOS;
  // widget tests otherwise run as Android and throw while serializing. The
  // variant sets and resets the override around each body, which the framework
  // checks for before tearDown runs.
  final macOS = TargetPlatformVariant.only(TargetPlatform.macOS);

  testWidgets('an unrelated rebuild reuses the menu instances', (tester) async {
    await pumpHomePage(tester);

    final before = _menus(tester);

    // Force a rebuild that changes nothing the menu shows — the shape of a
    // file-load progress tick, which fires ~100 times per load.
    tester.element(find.byType(HomePage)).markNeedsBuild();
    await tester.pump();

    // Identical instances: PlatformMenuBar compares descendants by identity,
    // so this is what keeps 300+ zone items off the platform channel.
    final after = _menus(tester);
    expect(identical(before, after), isTrue);
  }, variant: macOS);

  testWidgets('changing the zone rebuilds the menu with a new checkmark', (
    tester,
  ) async {
    await pumpHomePage(tester);

    final before = _menus(tester);
    final timeZoneMenu = _timeZoneMenu(before);

    // "UTC" is the second of the three fixed choices.
    expect(timeZoneMenu.menus[1].label, endsWith('UTC'));
    expect(timeZoneMenu.menus[1].label, isNot(startsWith('✓ ')));
    timeZoneMenu.menus[1].onSelected!();
    await tester.pump();

    expect(DisplayTime.zone, const DisplayZone.utc());
    final after = _menus(tester);
    expect(identical(before, after), isFalse);

    expect(_timeZoneMenu(after).menus[1].label, startsWith('✓ '));
  }, variant: macOS);

  testWidgets('Show Year & Time Zone is a checkable View item', (tester) async {
    await pumpHomePage(tester);

    PlatformMenuItem item() =>
        _menus(tester).whereType<PlatformMenu>().firstWhere((m) => m.label == 'View').menus.first;

    expect(item().label, '✓ Show Year & Time Zone');
    item().onSelected!();
    await tester.pump();
    expect(item().label, 'Show Year & Time Zone');
  }, variant: macOS);
}
