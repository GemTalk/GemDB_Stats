import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/presentation/time_zone/time_zone_menu.dart';
import 'package:vsd_core/vsd_core.dart';

/// A winter instant, so offsets don't shift under the tests with the seasons.
final _at = DateTime.utc(2026, 1, 15, 12);

List<PlatformMenuItem> _items(DisplayZone current, {void Function(DisplayZone)? onSelect}) => buildTimeZoneMenuItems(
  current: current,
  onSelect: onSelect ?? (_) {},
  at: _at,
);

/// The three fixed choices plus "Other", with groups flattened.
List<PlatformMenuItem> _topLevel(List<PlatformMenuItem> items) => [
  for (final item in items)
    if (item is PlatformMenuItemGroup) ...item.members else item,
];

List<String> _labels(List<PlatformMenuItem> items) => _topLevel(items).map((i) => i.label).toList();

PlatformMenu _other(List<PlatformMenuItem> items) => _topLevel(items).whereType<PlatformMenu>().single;

/// The region submenus, which live one level down under "Other".
List<PlatformMenu> _regions(List<PlatformMenuItem> items) => _other(items).menus.cast<PlatformMenu>();

/// Matched on the suffix, since a selected region carries the '✓ ' prefix.
PlatformMenu _region(List<PlatformMenuItem> items, String name) =>
    _regions(items).firstWhere((m) => m.label.endsWith(name));

/// Every label in the submenu, to the leaves.
List<String> _allLabels(List<PlatformMenuItem> items) => [
  for (final item in _topLevel(items)) ...[
    item.label,
    if (item is PlatformMenu)
      for (final region in item.menus) ...[
        region.label,
        if (region is PlatformMenu) ...region.menus.map((m) => m.label),
      ],
  ],
];

void main() {
  tearDown(() => DisplayTime.fileZone = FileZone.unknown);

  test('keeps the common choices up front and the rest behind Other', () {
    final items = _items(const DisplayZone.file());
    final labels = _labels(items);

    // Only four entries compete for attention at this level.
    expect(labels, hasLength(4));
    expect(labels[0], endsWith('File (local, no zone in header)'));
    expect(labels[1], endsWith('UTC'));
    expect(labels[2], contains('This Computer'));
    expect(labels[3].trim(), 'Other');

    final regions = _regions(items);
    expect(
      regions.map((m) => m.label.trim()),
      containsAll(<String>[
        'Africa',
        'America',
        'Asia',
        'Australia',
        'Europe',
        'Pacific',
      ]),
    );
    // Alphabetical, and never empty — an empty submenu renders as disabled.
    expect(
      regions.map((m) => m.label.trim()).toList(),
      orderedEquals(regions.map((m) => m.label.trim()).toList()..sort()),
    );
    for (final region in regions) {
      expect(region.menus, isNotEmpty, reason: region.label);
    }
  });

  test('every IANA zone is reachable from the menu bar', () {
    final labels = _allLabels(_items(const DisplayZone.utc()));
    final zoneCount = DisplayTime.availableZoneNames().where((n) => n.contains('/')).length;
    // 3 fixed choices + "Other" + the regions themselves + every zone.
    final regionCount = _regions(_items(const DisplayZone.utc())).length;
    expect(labels, hasLength(4 + regionCount + zoneCount));
  });

  test('region items drop the prefix their parent already carries', () {
    final losAngeles = _region(
      _items(const DisplayZone.utc()),
      'America',
    ).menus.map((m) => m.label).firstWhere((l) => l.contains('Los Angeles'));
    expect(losAngeles.trim(), 'Los Angeles (PST, UTC-08:00)');

    // Multi-segment names keep everything after the region.
    final buenosAires = _region(
      _items(const DisplayZone.utc()),
      'America',
    ).menus.map((m) => m.label).firstWhere((l) => l.contains('Buenos Aires'));
    expect(buenosAires.trim(), startsWith('Argentina/Buenos Aires ('));
  });

  test('exactly one item is checked, whichever zone is selected', () {
    final zones = [
      const DisplayZone.file(),
      const DisplayZone.utc(),
      const DisplayZone.systemLocal(),
      const DisplayZone.named('Europe/Paris'),
    ];
    for (final zone in zones) {
      final checked = _allLabels(_items(zone)).where((l) => l.startsWith('✓ '));
      // A named zone also marks the trail to it — Other, then the region — so
      // a checkmark two levels down is still findable.
      final expected = zone is NamedDisplayZone ? 3 : 1;
      expect(checked, hasLength(expected), reason: 'for $zone');
    }
  });

  test('a named selection marks its own region, not a neighbouring one', () {
    final items = _items(const DisplayZone.named('Europe/Paris'));
    expect(_other(items).label, startsWith('✓ '));
    expect(_region(items, 'Europe').label, startsWith('✓ '));
    expect(_region(items, 'Asia').label, isNot(startsWith('✓ ')));
    expect(
      _region(items, 'Europe').menus.map((m) => m.label).where((l) => l.startsWith('✓ ')),
      hasLength(1),
    );
  });

  test('the File item carries the loaded file offset', () {
    DisplayTime.fileZone = const FileZone(offsetMs: -8 * 3600000);
    expect(_labels(_items(const DisplayZone.file())).first, '✓ File (UTC-08:00)');
  });

  test('selecting a zone reports it back', () {
    DisplayZone? picked;
    final items = _items(const DisplayZone.utc(), onSelect: (z) => picked = z);

    _region(items, 'Europe').menus.firstWhere((m) => m.label.contains('Paris')).onSelected!();
    expect(picked, const DisplayZone.named('Europe/Paris'));

    _topLevel(items).first.onSelected!();
    expect(picked, const DisplayZone.file());
  });
}
