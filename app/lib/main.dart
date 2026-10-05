import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vsd/presentation/home_page.dart';
import 'package:vsd/theme.dart';
import 'package:vsd_core/vsd_core.dart';

void main() async {
  // The app has no routes, so it leaves the page's URL alone. In a VS Code
  // webview the page and its <base href> are on different origins, and the
  // history update Flutter would make throws a SecurityError.
  setUrlStrategy(null);
  WidgetsFlutterBinding.ensureInitialized();
  DisplayTime.ensureTimeZoneData();
  await DataManager().loadStatistics();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadTheme(
      data: ShadThemeData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: HomePage(),
      ),
    );
  }
}
