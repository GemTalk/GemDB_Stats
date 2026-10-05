import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:vsd/presentation/menu/app_menu.dart';

const _checked = '✓ ';
const _unchecked = '   ';

bool get usesPlatformMenuBar => !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

/// [menus] wrapped in the macOS application and Window menus.
///
/// FlutterMenuPlugin replaces `NSApp.mainMenu` wholesale when it installs
/// these, so everything MainMenu.xib provided — About, Hide, Quit, Minimize —
/// has to be restated here or it is gone from the running app.
List<PlatformMenuItem> platformMenusFrom(List<AppSubmenu> menus) => [
  _applicationMenu(),
  ...menus.map(_submenu),
  _windowMenu(),
];

PlatformMenu _applicationMenu() => PlatformMenu(
  label: 'GemDB Stats',
  menus: [
    PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.about),
    PlatformMenuItemGroup(
      members: [
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.servicesSubmenu),
      ],
    ),
    PlatformMenuItemGroup(
      members: [
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.hide),
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.hideOtherApplications),
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.showAllApplications),
      ],
    ),
    PlatformMenuItemGroup(
      members: [
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.quit),
      ],
    ),
  ],
);

PlatformMenu _windowMenu() => PlatformMenu(
  label: 'Window',
  menus: [
    PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.minimizeWindow),
    PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.zoomWindow),
    PlatformMenuItemGroup(
      members: [
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.arrangeWindowsInFront),
      ],
    ),
  ],
);

PlatformMenu _submenu(AppSubmenu menu) =>
    PlatformMenu(label: _label(menu.label, menu.checked), menus: _entries(menu.entries));

/// Divider-separated runs become groups, which is how the platform channel
/// spells a separator: a group serializes with a divider on each side, and the
/// platform drops the leading and trailing ones.
List<PlatformMenuItem> _entries(List<AppMenuEntry> entries) {
  final result = <PlatformMenuItem>[];
  var run = <PlatformMenuItem>[];
  var afterDivider = false;

  void flush() {
    if (run.isEmpty) {
      return;
    }
    if (afterDivider) {
      result.add(PlatformMenuItemGroup(members: run));
    } else {
      result.addAll(run);
    }
    run = <PlatformMenuItem>[];
  }

  for (final entry in entries) {
    switch (entry) {
      case AppMenuDivider():
        flush();
        afterDivider = true;
      case AppMenuItem(:final label, :final checked, :final onSelected):
        run.add(PlatformMenuItem(label: _label(label, checked), onSelected: onSelected));
      case AppSubmenu():
        run.add(_submenu(entry));
    }
  }
  flush();

  return result;
}

String _label(String label, bool? checked) => switch (checked) {
  null => label,
  true => '$_checked$label',
  false => '$_unchecked$label',
};
