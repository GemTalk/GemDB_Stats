import 'package:flutter/widgets.dart';
import 'package:vsd_core/vsd_core.dart';

/// PlatformMenuItem has no `checked` property, so a checkmark is a label
/// prefix. Unchecked rows are padded to the same width so a radio group
/// aligns (approximately — the menu font is proportional).
const _checked = '✓ ';
const _unchecked = '   ';

String _mark(bool isSelected) => isSelected ? _checked : _unchecked;

/// Builds the View ▸ Time Zone submenu.
///
/// The three common choices are shown first. All other IANA zones are grouped
/// under "Other" by region so the menu stays compact. The selection is marked
/// at each visible level so it remains easy to find. [at] fixes the instant
/// used for offset resolution, keeping tests stable across DST changes.
List<PlatformMenuItem> buildTimeZoneMenuItems({
  required DisplayZone current,
  required ValueChanged<DisplayZone> onSelect,
  DateTime? at,
}) {
  final instant = at ?? DateTime.now().toUtc();

  PlatformMenuItem item(DisplayZone zone) => PlatformMenuItem(
    label: '${_mark(zone == current)}${DisplayTime.labelFor(zone, at: instant)}',
    onSelected: () => onSelect(zone),
  );

  return [
    item(const DisplayZone.file()),
    item(const DisplayZone.utc()),
    item(const DisplayZone.systemLocal()),
    PlatformMenuItemGroup(
      members: [
        PlatformMenu(
          // No ellipsis: this opens a submenu, not a dialog.
          label: '${_mark(current is NamedDisplayZone)}Other',
          menus: _regionMenus(current, instant, onSelect),
        ),
      ],
    ),
  ];
}

/// One submenu per region prefix ("Europe", "America", ...), alphabetically.
List<PlatformMenu> _regionMenus(
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
      PlatformMenu(
        label: '${_mark(selected != null && selected.startsWith('$region/'))}$region',
        menus: [
          for (final name in byRegion[region]!)
            PlatformMenuItem(
              label: '${_mark(name == selected)}${_zoneItemLabel(name, instant)}',
              onSelected: () => onSelect(DisplayZone.named(name)),
            ),
        ],
      ),
  ];
}

/// Strips the already-shown region prefix, e.g. `America/Argentina/Buenos_Aires`
/// becomes `Argentina/Buenos Aires (-03:00)`.
String _zoneItemLabel(String name, DateTime instant) {
  final city = name.substring(name.indexOf('/') + 1).replaceAll('_', ' ');
  return '$city ${DisplayZone.named(name).detailAt(instant)}';
}
