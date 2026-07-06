/// Public API of the `vsd_core` package: the shared statmon data layer,
/// parsing ([DataManager]) plus the domain models. Imported by both the Flutter
/// app (`../app`) and the standalone MCP server (`../mcp`).
library;

export 'src/data_manager.dart';
export 'src/models/file_time.dart';
export 'src/models/process.dart';
export 'src/models/stat_type.dart';
export 'src/models/statistic.dart';
export 'src/models/time_series.dart';
