import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/presentation/menu/app_menu.dart';
import 'package:vsd/presentation/menu/platform_menu_renderer.dart';

/// No platform variant is needed anywhere in this file: `PlatformProvidedMenuItem`
/// only asserts while serializing to the channel, which happens when a
/// `PlatformMenuBar` mounts — not while building the items.
List<PlatformMenuItem> _render(List<AppMenuEntry> entries) =>
    (platformMenusFrom([AppSubmenu(label: 'Menu', entries: entries)])[1] as PlatformMenu).menus;

AppMenuItem _item(String label, {bool? checked}) => AppMenuItem(label: label, onSelected: () {}, checked: checked);

void main() {
  test('the application and Window menus bracket the app menus', () {
    final menus = platformMenusFrom([const AppSubmenu(label: 'View', entries: [])]);

    expect(menus.map((m) => m.label), ['GemDB Stats', 'View', 'Window']);
  });

  test('the application menu still provides Quit', () {
    // FlutterMenuPlugin replaces NSApp.mainMenu wholesale, so dropping these
    // would ship a macOS build with no ⌘Q — the nib does not survive.
    final application = platformMenusFrom([]).first as PlatformMenu;
    final provided = application.menus
        .expand((e) => e is PlatformMenuItemGroup ? e.members : [e])
        .whereType<PlatformProvidedMenuItem>()
        .map((i) => i.type);

    expect(provided, contains(PlatformProvidedMenuItemType.quit));
    expect(provided, contains(PlatformProvidedMenuItemType.about));
    expect(provided, contains(PlatformProvidedMenuItemType.hide));
  });

  test('checked state becomes a label prefix', () {
    final menus = _render([
      _item('On', checked: true),
      _item('Off', checked: false),
      _item('Plain'),
    ]);

    expect(menus[0].label, '✓ On');
    // Padded to the same width, so the group stays aligned.
    expect(menus[1].label, '   Off');
    // Not in a check group at all, so no gutter is reserved.
    expect(menus[2].label, 'Plain');
  });

  test('a submenu carries its own checked state', () {
    final menus = _render([
      const AppSubmenu(label: 'Other', entries: [], checked: true),
    ]);

    expect(menus.single.label, '✓ Other');
  });

  test('a divider splits the entries into groups', () {
    final menus = _render([
      _item('First'),
      const AppMenuDivider(),
      _item('Second'),
      _item('Third'),
    ]);

    // Entries before the first divider stay bare; later runs become groups,
    // which is how the channel spells a separator.
    expect(menus, hasLength(2));
    expect(menus[0], isA<PlatformMenuItem>().having((i) => i.label, 'label', 'First'));
    expect(
      menus[1],
      isA<PlatformMenuItemGroup>().having((g) => g.members.map((m) => m.label), 'members', [
        'Second',
        'Third',
      ]),
    );
  });

  test('selecting a rendered item reaches the model callback', () {
    var picked = '';
    final menus = _render([
      AppMenuItem(label: 'Pick me', onSelected: () => picked = 'picked'),
    ]);

    menus.single.onSelected!();
    expect(picked, 'picked');
  });
}
