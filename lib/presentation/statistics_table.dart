import 'package:flutter/material.dart';
import 'package:vsd/domain/models/process.dart';

class StatisticsTable extends StatefulWidget {
  const StatisticsTable({required this.selectedProcess, super.key, this.onStatisticSelected});

  final Process selectedProcess;
  final void Function(int?)? onStatisticSelected;

  @override
  State<StatisticsTable> createState() => _StatisticsTableState();
}

class _StatisticsTableState extends State<StatisticsTable> {
  int? selectedIndex;

  @override
  void didUpdateWidget(StatisticsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedProcess != oldWidget.selectedProcess) {
      selectedIndex = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.selectedProcess.type.statistics.length,
      itemBuilder: (context, index) {
        final isSelected = selectedIndex == index;
        final hasData =
            widget.selectedProcess.statisticData[widget.selectedProcess.type.statistics[index].name]?.hasData ?? false;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            widget.onStatisticSelected?.call(index);
          },
          child: Container(
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: isSelected ? Color(0xFFDCF5FF) : Colors.transparent,
            alignment: Alignment.centerLeft,
            child: Text(
              widget.selectedProcess.type.statistics[index].name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: !hasData ? .normal : FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
