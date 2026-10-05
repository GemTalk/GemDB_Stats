import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/presentation/menu/app_menu.dart';
import 'package:vsd/presentation/menu/app_menus.dart';
import 'package:vsd_core/vsd_core.dart';

/// A winter instant, so offsets don't shift under the tests with the seasons.
final _at = DateTime.utc(2026, 1, 15, 12);

List<AppSubmenu> _menus({
  bool showYearAndZone = true,
  DisplayZone zone = const DisplayZone.file(),
  VoidCallback? onToggleYearAndZone,
  void Function(DisplayZone)? onSelectZone,
}) => buildAppMenus(
  showYearAndZone: showYearAndZone,
  zone: zone,
  onToggleYearAndZone: onToggleYearAndZone ?? () {},
  onSelectZone: onSelectZone ?? (_) {},
  at: _at,
);

AppSubmenu _view(List<AppSubmenu> menus) => menus.firstWhere((m) => m.label == 'View');

void main() {
  test('the bar carries only the application menus', () {
    // The macOS application and Window menus belong to that renderer, not the
    // shared model — they have no meaning on Linux or Windows.
    expect(_menus().map((m) => m.label), ['View']);
  });

  test('View holds the toggle and the time zone submenu, set apart', () {
    final entries = _view(_menus()).entries;

    expect(entries, hasLength(3));
    expect(entries[0], isA<AppMenuItem>().having((i) => i.label, 'label', 'Show Year & Time Zone'));
    expect(entries[1], isA<AppMenuDivider>());
    expect(
      entries[2],
      isA<AppSubmenu>()
          .having((s) => s.label, 'label', 'Time Zone')
          // Not part of a check group, so it reserves no checkmark gutter.
          .having((s) => s.checked, 'checked', isNull),
    );
  });

  test('Show Year & Time Zone reflects and reports its state', () {
    var toggled = 0;

    AppMenuItem item({required bool showYearAndZone}) =>
        _view(_menus(showYearAndZone: showYearAndZone, onToggleYearAndZone: () => toggled++)).entries.first
            as AppMenuItem;

    expect(item(showYearAndZone: true).checked, isTrue);
    expect(item(showYearAndZone: false).checked, isFalse);

    item(showYearAndZone: true).onSelected();
    expect(toggled, 1);
  });

  test('the selected zone reaches the Time Zone submenu', () {
    final entries = (_view(_menus(zone: const DisplayZone.utc())).entries[2] as AppSubmenu).entries;
    final utc = entries.whereType<AppMenuItem>().firstWhere((i) => i.label == 'UTC');

    expect(utc.checked, isTrue);
  });
}
