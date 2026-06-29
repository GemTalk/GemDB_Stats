import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:vsd/domain/data_manager.dart';
import 'package:vsd/domain/models/process.dart';
import 'package:vsd/domain/models/time_series.dart';
import 'package:vsd/features/ai_assistant/presentation/components/ai_assistant_panel.dart';
import 'package:vsd/presentation/_reusable_components/tool_icon_button.dart';
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
  double? _loadProgress;
  String? _loadError;
  int _dataVersion = 0;
  bool _aiPanelOpen = false;
  bool _showYear = true;
  late MultiSplitViewController _mainController;

  List<PlatformMenu> get platformMenus => [
    PlatformMenu(
      label: 'vsd',
      menus: [
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.about),
        PlatformMenuItemGroup(
          members: [
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.servicesSubmenu),
          ],
        ),
        PlatformMenuItemGroup(
          members: [
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.hide),
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.hideOtherApplications),
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.showAllApplications),
          ],
        ),
        PlatformMenuItemGroup(
          members: [
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.quit),
          ],
        ),
      ],
    ),
    PlatformMenu(
      label: 'View',
      menus: [
        PlatformMenuItem(
          label: _showYear ? '✓ Show Year' : 'Show Year',
          onSelected: () => setState(() => _showYear = !_showYear),
        ),
      ],
    ),
    PlatformMenu(
      label: 'Window',
      menus: [
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.minimizeWindow),
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.zoomWindow),
        PlatformMenuItemGroup(
          members: [
            PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.arrangeWindowsInFront),
          ],
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _mainController = MultiSplitViewController();
    _mainController.areas = [mainContentArea()];
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  void _toggleAiPanel() {
    if (_aiPanelOpen) {
      _mainController.removeAreaAt(1);
    } else {
      _mainController.addArea(aiPanelArea());
    }
    setState(() => _aiPanelOpen = !_aiPanelOpen);
  }

  Future<void> _handleFileSelected(String path) async {
    // _loadProgress is null when not loading
    if (_loadProgress != null) {
      return;
    }

    setState(() {
      _loadProgress = 0.0;
      _loadError = null;
      selectedProcess = null;
      selectedStatistic = null;
      _multiChartSelection = null;
    });
    try {
      await DataManager().loadFromFile(
        path,
        onProgress: (p) {
          if (mounted) {
            setState(() => _loadProgress = p);
          }
        },
      );
      setState(() {
        _loadProgress = null;
        _dataVersion++;
      });
    } catch (e) {
      setState(() {
        _loadProgress = null;
        _loadError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: platformMenus,
      child: Scaffold(
        body: Column(
          children: [
            FileBar(
              onFileSelected: _handleFileSelected,
              trailing: ToolIconButton(
                icon: FontAwesomeIcons.message,
                tooltip: 'Toggle Chat',
                onTap: _toggleAiPanel,
              ),
            ),
            if (_loadProgress != null)
              progressIndicator()
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
                    axis: Axis.horizontal,
                    controller: _mainController,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget progressIndicator() {
    return Expanded(
      child: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(value: _loadProgress),
              const SizedBox(height: 8),
              Text(
                '${(_loadProgress! * 100).round()}%',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Area mainContentArea() {
    return Area(
      builder: (context, area) => multiSplitViewTheme(
        child: MultiSplitView(
          axis: Axis.vertical,
          initialAreas: [tablesArea(), statsChartArea()],
        ),
      ),
    );
  }

  Area aiPanelArea() {
    return Area(
      size: 320,
      min: 220,
      builder: (context, area) => AiAssistantPanel(onClose: _toggleAiPanel),
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
        key: ValueKey((_dataVersion, _showYear)),
        showYear: _showYear,
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
      size: 600,
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
            : Center(
                child: Text(
                  'Select a process to view statistics',
                  style: TextStyle(fontSize: 13, color: Colors.black45),
                ),
              ),
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
