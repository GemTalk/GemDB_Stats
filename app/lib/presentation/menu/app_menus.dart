import 'package:flutter/foundation.dart';
import 'package:vsd/presentation/menu/app_menu.dart';
import 'package:vsd/presentation/time_zone/time_zone_menu.dart';
import 'package:vsd_core/vsd_core.dart';

/// Application menus in bar order; platform menus are added by their renderer.
/// [at] fixes time zone offsets for stable DST-sensitive tests.
List<AppSubmenu> buildAppMenus({
  required bool showYearAndZone,
  required DisplayZone zone,
  required VoidCallback onToggleYearAndZone,
  required ValueChanged<DisplayZone> onSelectZone,
  DateTime? at,
}) => [
  AppSubmenu(
    label: 'View',
    entries: [
      AppMenuItem(
        label: 'Show Year & Time Zone',
        onSelected: onToggleYearAndZone,
        checked: showYearAndZone,
      ),
      const AppMenuDivider(),
      AppSubmenu(
        label: 'Time Zone',
        entries: buildTimeZoneMenuEntries(current: zone, onSelect: onSelectZone, at: at),
      ),
    ],
  ),
];
