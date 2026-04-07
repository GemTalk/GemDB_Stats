import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:vsd/domain/models/process.dart';
import 'package:vsd/presentation/file_bar.dart';
import 'package:vsd/presentation/process_table.dart';
import 'package:vsd/presentation/statistics_table.dart';
import 'package:vsd/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Process? selectedProcess;
  int? selectedStatistic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FileBar(),
          Expanded(
            child: multiSplitViewTheme(
              child: MultiSplitView(
                axis: .vertical,
                initialAreas: [processTableArea(), statisticsArea()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Area processTableArea() {
    return Area(
      builder: (context, area) => ProcessTable(
        onProcessSelected: (process) {
          setState(() {
            selectedProcess = process;
            selectedStatistic = null;
          });
        },
      ),
    );
  }

  Area statisticsArea() {
    return Area(
      builder: (context, area) => multiSplitViewTheme(
        child: MultiSplitView(
          axis: .horizontal,
          initialAreas: [statsTableArea(), statsInfoArea()],
        ),
      ),
    );
  }

  Area statsTableArea() {
    return Area(
      builder: (context, area) => ColoredBox(
        color: Colors.white,
        child: selectedProcess != null
            ? StatisticsTable(
                statistics: selectedProcess!.type.statistics,
                onStatisticSelected: (statistic) {
                  setState(() {
                    selectedStatistic = statistic;
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

  Area statsInfoArea() {
    return Area(
      builder: (context, area) => selectedStatistic != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                selectedProcess!.type.statistics[selectedStatistic!].description,
                style: const TextStyle(fontSize: 13),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
