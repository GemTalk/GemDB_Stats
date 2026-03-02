import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:vsd/domain/models/process.dart';
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
      body: multiSplitViewTheme(
        child: MultiSplitView(
          axis: .vertical,
          initialAreas: [processTableArea(), statisticsArea()],
        ),
      ),
    );
  }

  Area processTableArea() {
    return Area(
      builder: (context, area) => ProcessTable(
        onProcessSelected: (process) {
          setState(() {
            selectedProcess = process;
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
      builder: (context, area) => selectedProcess != null
          ? StatisticsTable(
              statistics: selectedProcess!.type.statistics,
              onStatisticSelected: (statistic) {
                setState(() {
                  selectedStatistic = statistic;
                });
              },
            )
          : const SizedBox.shrink(),
    );
  }

  Area statsInfoArea() {
    return Area(
      builder: (context, area) => selectedStatistic != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                selectedProcess!.type.statistics[selectedStatistic!].description,
                style: const TextStyle(fontSize: 16),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
