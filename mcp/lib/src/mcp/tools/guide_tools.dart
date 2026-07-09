import 'package:vsd_mcp/src/mcp/guides/analysis_guides.dart';

/// Returns the name/title/description of every registered analysis guide.
Map<String, dynamic> executeListAnalysisGuides() {
  return {
    'guides': analysisGuides
        .map(
          (g) => {
            'name': g.name,
            'title': g.title,
            'description': g.description,
          },
        )
        .toList(),
  };
}

/// Returns the full content of the guide named [name].
Map<String, dynamic> executeGetAnalysisGuide(String name) {
  final guide = findAnalysisGuide(name);
  if (guide == null) {
    return {
      'error':
          'No analysis guide named "$name". '
          'Available: ${analysisGuides.map((g) => g.name).join(', ')}',
    };
  }
  return {
    'name': guide.name,
    'title': guide.title,
    'content': guide.content,
  };
}
