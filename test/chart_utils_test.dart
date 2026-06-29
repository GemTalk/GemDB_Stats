import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/presentation/chart/chart_utils.dart';

void main() {
  group('nearestInWindowIndex', () {
    // Timestamps 0,10,20,...,90 — sorted ascending, the full window.
    final xs = [for (var i = 0; i < 10; i++) (i * 10).toDouble()];

    test('returns null for an empty list', () {
      expect(nearestInWindowIndex([], 5, 0, 100), isNull);
    });

    test('finds the single point when in window', () {
      expect(nearestInWindowIndex([42], 40, 0, 100), 0);
    });

    test('returns null when the only point is outside the window', () {
      expect(nearestInWindowIndex([42], 40, 0, 30), isNull);
    });

    test('snaps to an exact match', () {
      expect(nearestInWindowIndex(xs, 50, 0, 90), 5);
    });

    test('picks the closer of two neighbors', () {
      expect(nearestInWindowIndex(xs, 52, 0, 90), 5); // 50 is closer than 60
      expect(nearestInWindowIndex(xs, 58, 0, 90), 6); // 60 is closer than 50
    });

    test('resolves an exact tie to the earlier index', () {
      expect(nearestInWindowIndex(xs, 55, 0, 90), 5); // equidistant 50/60 -> 50
    });

    test('clamps to the first/last point past the ends', () {
      expect(nearestInWindowIndex(xs, -100, 0, 90), 0);
      expect(nearestInWindowIndex(xs, 1000, 0, 90), 9);
    });

    test('only snaps to points inside a restricted window', () {
      // Window [25, 65] excludes 0,10,20 and 70,80,90.
      // Target 22 is nearest to 20 (out of window) — must snap to 30 instead.
      expect(nearestInWindowIndex(xs, 22, 25, 65), 3); // -> 30
      // Target 68 is nearest to 70 (out of window) — must snap to 60.
      expect(nearestInWindowIndex(xs, 68, 25, 65), 6); // -> 60
    });

    test('returns null when the window contains no points', () {
      // Window [11, 19] sits in the gap between 10 and 20.
      expect(nearestInWindowIndex(xs, 15, 11, 19), isNull);
    });
  });
}
