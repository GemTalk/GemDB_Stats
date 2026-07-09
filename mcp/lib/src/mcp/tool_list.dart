/// The set of tool names registered by [registerVsdTools].
class VsdTools {
  static const listProcesses = 'list_processes';
  static const getProcessDetails = 'get_process_details';
  static const getDatasetOverview = 'get_dataset_overview';
  static const getStatisticValues = 'get_statistic_values';
  static const getStatisticSummary = 'get_statistic_summary';
  static const compareProcesses = 'compare_processes';
  static const findTopStatistics = 'find_top_statistics';
  static const findStatEvents = 'find_stat_events';
  static const getValuesAtTime = 'get_values_at_time';
  static const listAnalysisGuides = 'list_analysis_guides';
  static const getAnalysisGuide = 'get_analysis_guide';

  /// Only registered when file tools are enabled (standalone server).
  static const loadFile = 'load_file';
}
