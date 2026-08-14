// Regenerates lib/src/stat_definitions.g.dart from tool/vsd.stats.tcl.
//
// The GemStone statistic definitions are embedded as a base64 constant so the
// pure-Dart package can ship them without a Flutter asset bundle. Run this
// after editing tool/vsd.stats.tcl:
//
//   dart run tool/gen_stat_definitions.dart
import 'dart:convert';
import 'dart:io';

void main() {
  final scriptDir = File.fromUri(Platform.script).parent.path;
  final src = File('$scriptDir/vsd.stats.tcl');
  final out = File('$scriptDir/../lib/src/stat_definitions.g.dart');

  final b64 = base64.encode(src.readAsBytesSync());
  const chunk = 100;
  final lines = <String>[];
  for (var i = 0; i < b64.length; i += chunk) {
    lines.add(
      b64.substring(i, i + chunk > b64.length ? b64.length : i + chunk),
    );
  }
  final body = lines.map((l) => "    '$l'").join('\n');

  out.writeAsStringSync('''
// GENERATED FILE — do not edit by hand.
//
// Contents of tool/vsd.stats.tcl (the GemStone statistic definitions),
// base64-encoded so this pure-Dart package can embed the definitions without a
// Flutter asset bundle. Decoded and parsed by DataManager.loadStatistics().
//
// To regenerate after editing tool/vsd.stats.tcl:
//   dart run tool/gen_stat_definitions.dart
const String statDefinitionsB64 =
$body;
''');
  stderr.writeln('Wrote ${out.path} (${b64.length} base64 chars).');
}
