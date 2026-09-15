import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vsd/presentation/home_page.dart';
import 'package:vsd/theme.dart';
import 'package:vsd_core/vsd_core.dart';

void main() async {
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
