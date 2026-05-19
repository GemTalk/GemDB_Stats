import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:vsd/domain/data_manager.dart';
import 'package:vsd/domain/models/process.dart';
import 'package:vsd/domain/models/time_series.dart';
import 'package:vsd/presentation/chart/multi_statistic_line_chart.dart';
import 'package:vsd/presentation/chart/statistic_line_chart.dart';
import 'package:vsd/presentation/file_bar.dart';
import 'package:vsd/presentation/process_table.dart';
import 'package:vsd/presentation/statistics_table/statistics_table.dart';
import 'package:vsd/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Process? selectedProcess;
  int? selectedStatistic;
  ({Set<int> primary, Set<int> secondary})? _multiChartSelection;
  bool _isLoading = false;
  String? _loadError;
  int _dataVersion = 0;

  Future<void> _handleFileSelected(String path) async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
      _loadError = null;
      selectedProcess = null;
      selectedStatistic = null;
      _multiChartSelection = null;
    });
    try {
      await DataManager().loadFromFile(path);
      setState(() {
        _isLoading = false;
        _dataVersion++;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _loadError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FileBar(onFileSelected: _handleFileSelected),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_loadError != null)
            Expanded(
              child: Center(
                child: Text(
                  'Error loading file: $_loadError',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          else
            Expanded(
              child: multiSplitViewTheme(
                child: MultiSplitView(
                  axis: .vertical,
                  initialAreas: [tablesArea(), statsChartArea()],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Area tablesArea() {
    return Area(
      builder: (context, area) => multiSplitViewTheme(
        child: MultiSplitView(
          axis: .horizontal,
          initialAreas: [
            processTableArea(),
            statsArea(),
          ],
        ),
      ),
    );
  }

  Area processTableArea() {
    return Area(
      builder: (context, area) => ProcessTable(
        key: ValueKey(_dataVersion),
        onProcessSelected: (process) {
          setState(() {
            selectedProcess = process;
            selectedStatistic = null;
            _multiChartSelection = null;
          });
        },
      ),
    );
  }

  Area statsArea() {
    return Area(
      size: 500,
      min: 350,
      builder: (context, area) => multiSplitViewTheme(
        child: MultiSplitView(
          axis: .vertical,
          initialAreas: [
            statsTableArea(),
            statsDescriptionArea(),
          ],
        ),
      ),
    );
  }

  Area statsTableArea() {
    return Area(
      flex: 3,
      builder: (context, area) => ColoredBox(
        color: Colors.white,
        child: selectedProcess != null
            ? StatisticsTable(
                selectedProcess: selectedProcess!,
                onStatisticSelected: (statistic) {
                  setState(() {
                    selectedStatistic = statistic;
                  });
                },
                onMultiChartSelectionChanged: (selection) {
                  setState(() {
                    _multiChartSelection = selection;
                  });
                },
              )
            : _buildEmptyState(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'Select a process to view statistics',
        style: TextStyle(fontSize: 13),
      ),
    );
  }

  Area statsDescriptionArea() {
    return Area(
      builder: (context, area) => selectedStatistic != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                selectedProcess!.type.statistics[selectedStatistic!].description,
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Area statsChartArea() {
    return Area(
      builder: (context, area) {
        if (_multiChartSelection != null) {
          final sel = _multiChartSelection!;
          if (sel.primary.isEmpty && sel.secondary.isEmpty) {
            return const Align(
              alignment: Alignment.center,
              child: Text(
                'Select statistics to compare',
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
            );
          }

          List<({String name, List<DataPoint> points})> toSeries(Set<int> indices) =>
              indices.where((i) => i < selectedProcess!.type.statistics.length).map((i) {
                final stat = selectedProcess!.type.statistics[i];
                final ts = selectedProcess!.statisticData[stat.name];
                return (name: stat.name, points: ts?.points ?? <DataPoint>[]);
              }).toList();

          return MultiStatisticLineChart(
            primarySeries: toSeries(sel.primary),
            secondarySeries: toSeries(sel.secondary),
          );
        }

        if (selectedProcess == null || selectedStatistic == null) {
          return const SizedBox.shrink();
        }

        final statistic = selectedProcess!.type.statistics[selectedStatistic!];
        final series = selectedProcess!.statisticData[statistic.name];
        final hasData = series?.hasData ?? false;

        return hasData && series != null
            ? StatisticLineChart(
                points: series.points,
                statisticName: statistic.name,
              )
            : const Align(
                alignment: Alignment.center,
                child: Text(
                  'No data',
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
              );
      },
    );
  }
}
