/// The set of tool names registered by [registerVsdTools].
class VsdTools {
  static const listProcesses = 'list_processes';
  static const getProcessDetails = 'get_process_details';
  static const getDatasetOverview = 'get_dataset_overview';
  static const getStatisticValues = 'get_statistic_values';
  static const getStatisticSummary = 'get_statistic_summary';
  static const compareProcesses = 'compare_processes';
  static const findTopStatistics = 'find_top_statistics';

  /// Only registered when file tools are enabled (standalone server).
  static const loadFile = 'load_file';
}
