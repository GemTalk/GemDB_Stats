import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/presentation/home_page.dart';
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

  tearDown(() {
    DisplayTime.zone = const DisplayZone.file();
    DisplayTime.fileZone = FileZone.unknown;
  });

  // The variant selects the branch under test: HomePage renders the native
  // menu on macOS and the in-app one everywhere else.
  final macOS = TargetPlatformVariant.only(TargetPlatform.macOS);
  final linux = TargetPlatformVariant.only(TargetPlatform.linux);

  testWidgets('macOS takes the native menu and reuses the menu instances', (tester) async {
    await pumpHomePage(tester);

    expect(find.byType(AppMenuButton), findsNothing);

    /// The exact list instance PlatformMenuBar holds — not a `cast` view, which
    /// would be a fresh wrapper on every call and defeat the identity check.
    List<PlatformMenuItem> menus() => tester.widget<PlatformMenuBar>(find.byType(PlatformMenuBar)).menus;

    final before = menus();

    // Force a rebuild that changes nothing the menu shows — the shape of a
    // file-load progress tick, which fires ~100 times per load.
    tester.element(find.byType(HomePage)).markNeedsBuild();
    await tester.pump();

    // Identical instances: PlatformMenuBar compares descendants by identity,
    // so this is what keeps 300+ zone items off the platform channel.
    expect(identical(before, menus()), isTrue);
  }, variant: macOS);

  testWidgets('elsewhere takes the in-app menu and reuses the widget', (tester) async {
    await pumpHomePage(tester);

    // PlatformMenuBar renders nothing off macOS, and asserts on its provided
    // items in debug, so the two branches have to be exclusive.
    expect(find.byType(PlatformMenuBar), findsNothing);

    AppMenuButton menuButton() => tester.widget<AppMenuButton>(find.byType(AppMenuButton));

    final before = menuButton();

    tester.element(find.byType(HomePage)).markNeedsBuild();
    await tester.pump();

    // The same instance lets Element.updateChild skip the ~400-item subtree.
    expect(identical(before, menuButton()), isTrue);
  }, variant: linux);
}
