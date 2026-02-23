import 'package:flutter/material.dart';
import 'package:vsd/domain/data_manager.dart';
import 'package:vsd/presentation/home_page.dart';
import 'package:vsd/theme.dart';

void main() {
  // Initialize data manager to load data before UI builds
  DataManager().loadData();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: theme,
    );
  }
}
