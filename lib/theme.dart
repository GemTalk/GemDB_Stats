import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

final theme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Color(0xFF03DAC6),
    onSecondary: Colors.black,
    error: Color(0xFFB00020),
    onError: Colors.white,
    surface: Color(0xFFF7F7F7),
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: const Color(0xFFF7F7F7),
);

MultiSplitViewTheme multiSplitViewTheme({required MultiSplitView child}) => MultiSplitViewTheme(
  data: MultiSplitViewThemeData(
    dividerThickness: 1,
    dividerHandleBuffer: 4,
    dividerPainter: DividerPainters.background(
      color: Colors.black.withValues(alpha: .08),
      highlightedColor: Colors.black.withValues(alpha: 0.2),
    ),
  ),
  child: child,
);
