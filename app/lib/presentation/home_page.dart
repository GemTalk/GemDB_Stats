import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:vsd/features/ai_assistant/presentation/components/ai_assistant_panel.dart';
import 'package:vsd/presentation/_reusable_components/tool_icon_button.dart';
import 'package:vsd/presentation/chart/multi_chart_controller.dart';
import 'package:vsd/presentation/chart/multi_statistic_line_chart.dart';
import 'package:vsd/presentation/chart/series_legend.dart';
import 'package:vsd/presentation/chart/statistic_line_chart.dart';
import 'package:vsd/presentation/file_bar.dart';
import 'package:vsd/presentation/process_table.dart';
import 'package:vsd/presentation/statistics_table/statistics_table.dart';
import 'package:vsd/presentation/time_zone/time_zone_menu.dart';
import 'package:vsd/theme.dart';
import 'package:vsd_core/vsd_core.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Process? selectedProcess;
  int? selectedStatistic;
  final MultiChartController _multiChart = MultiChartController();
  double? _loadProgress;
  String? _loadError;
  int _dataVersion = 0;
  bool _aiPanelOpen = false;
  bool _showYearAndZone = true;
  DisplayZone _zone = const DisplayZone.file();
  late MultiSplitViewController _mainController;
  late MultiSplitViewController _chartPaneController;
  bool _legendOpen = false;

  // Menus are rebuilt on every setState, but the platform menu is expensive to
  // serialize. Cache the built menu and only refresh it when the visible items
  // actually change.
  ({bool showYearAndZone, DisplayZone zone, int dataVersion})? _menuCacheKey;
  List<PlatformMenu>? _menuCache;

  List<PlatformMenu> get platformMenus {
    final key = (showYearAndZone: _showYearAndZone, zone: _zone, dataVersion: _dataVersion);
    if (_menuCacheKey != key) {
      _menuCacheKey = key;
      _menuCache = _buildPlatformMenus();
    }
    return _menuCache!;
  }

  List<PlatformMenu> _buildPlatformMenus() => [
    PlatformMenu(
      label: 'GemDB Stats',
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
          label: _showYearAndZone ? '✓ Show Year & Time Zone' : 'Show Year & Time Zone',
          onSelected: () => setState(() => _showYearAndZone = !_showYearAndZone),
        ),
        PlatformMenuItemGroup(
          members: [
            PlatformMenu(
              label: 'Time Zone',
              menus: buildTimeZoneMenuItems(current: _zone, onSelect: _setZone),
            ),
          ],
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
    _chartPaneController = MultiSplitViewController();
    _chartPaneController.areas = [chartArea()];
    _multiChart.addListener(_syncLegendPane);
  }

  @override
  void dispose() {
    _multiChart.removeListener(_syncLegendPane);
    _mainController.dispose();
    _chartPaneController.dispose();
    _multiChart.dispose();
    super.dispose();
  }

  /// Keeps the legend in sync with MultiChart mode without rebuilding the split
  /// view, preserving chart state and divider positions across selection changes.
  void _syncLegendPane() {
    if (_legendOpen == _multiChart.active) {
      return;
    }
    _legendOpen = _multiChart.active;
    if (_legendOpen) {
      _chartPaneController.addArea(seriesLegendArea());
    } else {
      _chartPaneController.removeAreaAt(1);
    }
  }

  void _toggleAiPanel() {
    if (_aiPanelOpen) {
      _mainController.removeAreaAt(1);
    } else {
      _mainController.addArea(aiPanelArea());
    }
    setState(() => _aiPanelOpen = !_aiPanelOpen);
  }

  /// Updates the displayed timezone and keeps the app, MCP tools, and AI in sync.
  void _setZone(DisplayZone zone) {
    DisplayTime.zone = zone;
    setState(() => _zone = zone);
  }

  Future<void> _handleFileSelected(String path) async {
    // _loadProgress is null when not loading
    if (_loadProgress != null) {
      return;
    }

    _multiChart.reset();

    setState(() {
      _loadProgress = 0.0;
      _loadError = null;
      selectedProcess = null;
      selectedStatistic = null;
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
        key: ValueKey((_dataVersion, _showYearAndZone)),
        showYearAndZone: _showYearAndZone,
        displayZone: _zone,
        onProcessSelected: (process) {
          setState(() {
            selectedProcess = process;
            selectedStatistic = null;
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
                multiChart: _multiChart,
                onStatisticSelected: (statistic) {
                  setState(() {
                    selectedStatistic = statistic;
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
      builder: (context, area) => multiSplitViewTheme(
        child: MultiSplitView(
          axis: Axis.horizontal,
          controller: _chartPaneController,
        ),
      ),
    );
  }

  Area chartArea() {
    return Area(
      builder: (context, area) => AnimatedBuilder(
        animation: _multiChart,
        builder: (context, _) => chartContent(),
      ),
    );
  }

  Area seriesLegendArea() {
    return Area(
      size: 220,
      min: 160,
      builder: (context, area) => SeriesLegend(controller: _multiChart),
    );
  }

  Widget chartContent() {
    if (_multiChart.active) {
      if (_multiChart.isEmpty) {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            'Select statistics to compare',
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
        );
      }

      return MultiStatisticLineChart(
        primarySeries: _multiChart.seriesFor(_multiChart.primary),
        secondarySeries: _multiChart.seriesFor(_multiChart.secondary),
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
  }
}
