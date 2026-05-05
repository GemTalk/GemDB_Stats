import 'package:flutter/material.dart' hide SearchBar;
import 'package:vsd/domain/models/process.dart';
import 'package:vsd/domain/models/statistic.dart';
import 'package:vsd/presentation/components/pulldown_button.dart';
import 'package:vsd/presentation/components/search_bar.dart';

class StatisticsTable extends StatefulWidget {
  const StatisticsTable({
    required this.selectedProcess,
    super.key,
    this.onStatisticSelected,
  });

  final Process selectedProcess;
  final void Function(int?)? onStatisticSelected;

  @override
  State<StatisticsTable> createState() => _StatisticsTableState();
}

class _StatisticsTableState extends State<StatisticsTable> {
  final TextEditingController _searchController = TextEditingController();
  int? selectedIndex;
  String searchQuery = '';
  bool hideStatisticsWithNoData = false;

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
      final matchesSearch = searchQuery.isEmpty || entry.value.name.toLowerCase().contains(searchQuery.toLowerCase());
      if (!matchesSearch) {
        return false;
      }

      if (!hideStatisticsWithNoData) {
        return true;
      }

      return widget.selectedProcess.statisticData[entry.value.name]?.hasData ?? false;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Center(
            child: Row(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: [
                searchBar(),
                threeDotMenu(statistics),
              ],
            ),
          ),
        ),
        Divider(height: 1),
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

  Widget searchBar() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: SearchBar(
        controller: _searchController,
        hintText: 'Search statistics',
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  CustomPulldownButton threeDotMenu(List<Statistic> statistics) {
    return CustomPulldownButton(
      icon: Icons.more_horiz,
      items: [
        MacosPulldownMenuItem(
          label: 'Hide statistics with no data',
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 14,
                child: hideStatisticsWithNoData ? const Icon(Icons.check, size: 14) : null,
              ),
              const SizedBox(width: 8),
              const Text('Hide statistics with no data'),
            ],
          ),
          onTap: () {
            setState(() {
              hideStatisticsWithNoData = !hideStatisticsWithNoData;

              if (hideStatisticsWithNoData && selectedIndex != null) {
                final selectedStatistic = statistics[selectedIndex!];
                final selectedHasData = widget.selectedProcess.statisticData[selectedStatistic.name]?.hasData ?? false;
                if (!selectedHasData) {
                  selectedIndex = null;
                  widget.onStatisticSelected?.call(null);
                }
              }
            });
          },
        ),
      ],
    );
  }
}
