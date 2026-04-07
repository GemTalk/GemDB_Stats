import 'package:flutter/material.dart';
import 'package:vsd/domain/data_manager.dart';
import 'package:vsd/presentation/home_page.dart';
import 'package:vsd/theme.dart';

void main() async {
  // Initialize data manager to load data before UI builds
  WidgetsFlutterBinding.ensureInitialized();
  await DataManager().loadAll();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: HomePage(),
    );
  }
}
