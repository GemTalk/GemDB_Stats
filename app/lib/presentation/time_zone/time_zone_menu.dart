import 'package:flutter/foundation.dart';
import 'package:vsd/presentation/menu/app_menu.dart';
import 'package:vsd_core/vsd_core.dart';

/// Builds the View ▸ Time Zone submenu.
///
/// The three common choices are shown first. All other IANA zones are grouped
/// under "Other" by region so the menu stays compact. The selection is marked
/// at each visible level so it remains easy to find. [at] fixes the instant
/// used for offset resolution, keeping tests stable across DST changes.
List<AppMenuEntry> buildTimeZoneMenuEntries({
  required DisplayZone current,
  required ValueChanged<DisplayZone> onSelect,
  DateTime? at,
}) {
  final instant = at ?? DateTime.now().toUtc();

  AppMenuItem item(DisplayZone zone) => AppMenuItem(
    label: DisplayTime.labelFor(zone, at: instant),
    onSelected: () => onSelect(zone),
    checked: zone == current,
  );

  return [
    item(const DisplayZone.file()),
    item(const DisplayZone.utc()),
    item(const DisplayZone.systemLocal()),
    const AppMenuDivider(),
    AppSubmenu(
      // No ellipsis: this opens a submenu, not a dialog.
      label: 'Other',
      entries: _regionMenus(current, instant, onSelect),
      checked: current is NamedDisplayZone,
    ),
  ];
}

/// One submenu per region prefix ("Europe", "America", ...), alphabetically.
List<AppMenuEntry> _regionMenus(
  DisplayZone current,
  DateTime instant,
  ValueChanged<DisplayZone> onSelect,
) {
  final selected = current is NamedDisplayZone ? current.location : null;

  final byRegion = <String, List<String>>{};
  for (final name in DisplayTime.availableZoneNames()) {
    // "Factory" is a tzdb placeholder, not a place anyone is in.
    if (!name.contains('/')) {
      continue;
    }
    final region = name.substring(0, name.indexOf('/'));
    byRegion.putIfAbsent(region, () => []).add(name);
  }

  return [
    for (final region in byRegion.keys.toList()..sort())
      AppSubmenu(
        label: region,
        entries: [
          for (final name in byRegion[region]!)
            AppMenuItem(
              label: _zoneItemLabel(name, instant),
              onSelected: () => onSelect(DisplayZone.named(name)),
              checked: name == selected,
            ),
        ],
        checked: selected != null && selected.startsWith('$region/'),
      ),
  ];
}

/// Strips the already-shown region prefix, e.g. `America/Argentina/Buenos_Aires`
/// becomes `Argentina/Buenos Aires (-03:00)`.
String _zoneItemLabel(String name, DateTime instant) {
  final city = name.substring(name.indexOf('/') + 1).replaceAll('_', ' ');
  return '$city ${DisplayZone.named(name).detailAt(instant)}';
}
