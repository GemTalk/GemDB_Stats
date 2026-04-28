import 'package:flutter/material.dart' hide SearchBar;
import 'package:vsd/domain/models/process.dart';
import 'package:vsd/presentation/components/search_bar.dart';

class StatisticsTable extends StatefulWidget {
  const StatisticsTable({required this.selectedProcess, super.key, this.onStatisticSelected});

  final Process selectedProcess;
  final void Function(int?)? onStatisticSelected;

  @override
  State<StatisticsTable> createState() => _StatisticsTableState();
}

class _StatisticsTableState extends State<StatisticsTable> {
  final TextEditingController _searchController = TextEditingController();
  int? selectedIndex;
  String searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StatisticsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedProcess != oldWidget.selectedProcess) {
      selectedIndex = null;
      searchQuery = '';
      _searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final statistics = widget.selectedProcess.type.statistics;
    final filteredStatistics = statistics.asMap().entries.where((entry) {
      if (searchQuery.isEmpty) {
        return true;
      }

      return entry.value.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        SearchBar(
          controller: _searchController,
          hintText: 'Search statistics',
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredStatistics.length,
            itemBuilder: (context, index) {
              final statisticEntry = filteredStatistics[index];
              final statisticIndex = statisticEntry.key;
              final statistic = statisticEntry.value;
              final isSelected = selectedIndex == statisticIndex;
              final hasData = widget.selectedProcess.statisticData[statistic.name]?.hasData ?? false;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = statisticIndex;
                  });
                  widget.onStatisticSelected?.call(statisticIndex);
                },
                child: Container(
                  height: 25,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  color: isSelected ? const Color(0xFFDCF5FF) : Colors.transparent,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    statistic.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: hasData ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
