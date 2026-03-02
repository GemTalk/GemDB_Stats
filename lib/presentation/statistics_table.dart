import 'package:flutter/material.dart';
import 'package:vsd/domain/models/statistic.dart';

class StatisticsTable extends StatefulWidget {
  const StatisticsTable({required this.statistics, super.key, this.onStatisticSelected});

  final List<Statistic> statistics;
  final void Function(int?)? onStatisticSelected;

  @override
  State<StatisticsTable> createState() => _StatisticsTableState();
}

class _StatisticsTableState extends State<StatisticsTable> {
  int? selectedIndex;

  @override
  void didUpdateWidget(StatisticsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.statistics != oldWidget.statistics) {
      selectedIndex = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.statistics.length,
      itemBuilder: (context, index) {
        final isSelected = selectedIndex == index;
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
            child: Text(widget.statistics[index].name, style: const TextStyle(fontSize: 13)),
          ),
        );
      },
    );
  }
}
