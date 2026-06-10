import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vsd/domain/data_manager.dart';
import 'package:vsd/presentation/home_page.dart';
import 'package:vsd/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
