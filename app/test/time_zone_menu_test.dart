import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/presentation/menu/app_menu.dart';
import 'package:vsd/presentation/time_zone/time_zone_menu.dart';
import 'package:vsd_core/vsd_core.dart';

/// A winter instant, so offsets don't shift under the tests with the seasons.
final _at = DateTime.utc(2026, 1, 15, 12);

List<AppMenuEntry> _items(DisplayZone current, {void Function(DisplayZone)? onSelect}) =>
    buildTimeZoneMenuEntries(current: current, onSelect: onSelect ?? (_) {}, at: _at);

/// The three fixed choices plus "Other", with separators dropped.
List<AppMenuEntry> _topLevel(List<AppMenuEntry> items) => [
  for (final item in items)
    if (item is! AppMenuDivider) item,
];

List<String> _labels(List<AppMenuEntry> items) => _topLevel(items).map(_labelOf).toList();

String _labelOf(AppMenuEntry entry) => switch (entry) {
  AppMenuItem(:final label) => label,
  AppSubmenu(:final label) => label,
  AppMenuDivider() => '',
};

bool? _checkedOf(AppMenuEntry entry) => switch (entry) {
  AppMenuItem(:final checked) => checked,
  AppSubmenu(:final checked) => checked,
  AppMenuDivider() => null,
};

AppSubmenu _other(List<AppMenuEntry> items) => _topLevel(items).whereType<AppSubmenu>().single;

/// The region submenus, which live one level down under "Other".
List<AppSubmenu> _regions(List<AppMenuEntry> items) => _other(items).entries.cast<AppSubmenu>();

AppSubmenu _region(List<AppMenuEntry> items, String name) => _regions(items).firstWhere((m) => m.label == name);

/// Every entry in the submenu, to the leaves, separators excluded.
List<AppMenuEntry> _allEntries(List<AppMenuEntry> items) => [
  for (final item in _topLevel(items)) ...[
    item,
    if (item is AppSubmenu)
      for (final region in item.entries) ...[
        region,
        if (region is AppSubmenu) ...region.entries,
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
    expect(labels[3], 'Other');

    // "Other" is set apart from the three fixed choices.
    expect(items[3], isA<AppMenuDivider>());

    final regions = _regions(items);
    expect(
      regions.map((m) => m.label),
      containsAll(<String>['Africa', 'America', 'Asia', 'Australia', 'Europe', 'Pacific']),
    );
    // Alphabetical, and never empty — an empty submenu renders as disabled.
    expect(
      regions.map((m) => m.label).toList(),
      orderedEquals(regions.map((m) => m.label).toList()..sort()),
    );
    for (final region in regions) {
      expect(region.entries, isNotEmpty, reason: region.label);
    }
  });

  test('every IANA zone is reachable from the menu bar', () {
    final entries = _allEntries(_items(const DisplayZone.utc()));
    final zoneCount = DisplayTime.availableZoneNames().where((n) => n.contains('/')).length;
    // 3 fixed choices + "Other" + the regions themselves + every zone.
    final regionCount = _regions(_items(const DisplayZone.utc())).length;
    expect(entries, hasLength(4 + regionCount + zoneCount));
  });

  test('region items drop the prefix their parent already carries', () {
    final losAngeles = _region(
      _items(const DisplayZone.utc()),
      'America',
    ).entries.map(_labelOf).firstWhere((l) => l.contains('Los Angeles'));
    expect(losAngeles, 'Los Angeles (PST, UTC-08:00)');

    // Multi-segment names keep everything after the region.
    final buenosAires = _region(
      _items(const DisplayZone.utc()),
      'America',
    ).entries.map(_labelOf).firstWhere((l) => l.contains('Buenos Aires'));
    expect(buenosAires, startsWith('Argentina/Buenos Aires ('));
  });

  test('exactly one item is checked, whichever zone is selected', () {
    final zones = [
      const DisplayZone.file(),
      const DisplayZone.utc(),
      const DisplayZone.systemLocal(),
      const DisplayZone.named('Europe/Paris'),
    ];
    for (final zone in zones) {
      final checked = _allEntries(_items(zone)).where((e) => _checkedOf(e) ?? false);
      // A named zone also marks the trail to it — Other, then the region — so
      // a checkmark two levels down is still findable.
      final expected = zone is NamedDisplayZone ? 3 : 1;
      expect(checked, hasLength(expected), reason: 'for $zone');
    }
  });

  test('a named selection marks its own region, not a neighbouring one', () {
    final items = _items(const DisplayZone.named('Europe/Paris'));
    expect(_other(items).checked, isTrue);
    expect(_region(items, 'Europe').checked, isTrue);
    expect(_region(items, 'Asia').checked, isFalse);
    expect(
      _region(items, 'Europe').entries.where((e) => _checkedOf(e) ?? false),
      hasLength(1),
    );
  });

  test('the File item carries the loaded file offset', () {
    DisplayTime.fileZone = const FileZone(offsetMs: -8 * 3600000);
    final file = _topLevel(_items(const DisplayZone.file())).first;
    expect(_labelOf(file), 'File (UTC-08:00)');
    expect(_checkedOf(file), isTrue);
  });

  test('selecting a zone reports it back', () {
    DisplayZone? picked;
    final items = _items(const DisplayZone.utc(), onSelect: (z) => picked = z);

    final paris = _region(items, 'Europe').entries.whereType<AppMenuItem>().firstWhere(
      (m) => m.label.contains('Paris'),
    );
    paris.onSelected();
    expect(picked, const DisplayZone.named('Europe/Paris'));

    (_topLevel(items).first as AppMenuItem).onSelected();
    expect(picked, const DisplayZone.file());
  });
}
