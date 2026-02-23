import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:vsd/domain/models/process.dart';
import 'package:vsd/presentation/process_table.dart';
import 'package:vsd/presentation/statistics_table.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MultiSplitView(
          axis: .vertical,
          initialAreas: [processTableArea(), statsTableArea()],
        ),
      ),
    );
  }

  Area processTableArea() {
    return Area(
      builder: (context, area) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: ProcessTable(
          onProcessSelected: (process) {
            setState(() {
              selectedProcess = process;
            });
          },
        ),
      ),
    );
  }

  Area statsTableArea() {
    return Area(
      builder: (context, area) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: selectedProcess != null
            ? StatisticsTable(
                statistics: selectedProcess!.type.statistics,
                onStatisticSelected: (statistic) {
                  setState(() {
                    selectedStatistic = statistic;
                  });
                },
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
