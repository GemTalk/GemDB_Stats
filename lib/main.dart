import 'package:flutter/material.dart';
import 'package:vsd/domain/data_manager.dart';
import 'package:vsd/presentation/process_table.dart';
import 'package:vsd/theme.dart';

void main() {
  DataManager().loadData(); // Initialize data manager to load data before UI builds
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: ProcessTable(),
                ),
              ),
              // Expanded(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(8),
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      theme: theme,
    );
  }
}
