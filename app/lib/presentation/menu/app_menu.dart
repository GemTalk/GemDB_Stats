import 'package:flutter/foundation.dart';

sealed class AppMenuEntry {
  const AppMenuEntry();
}

class AppMenuItem extends AppMenuEntry {
  const AppMenuItem({required this.label, required this.onSelected, this.checked});

  final String label;
  final VoidCallback onSelected;
  final bool? checked;
}

class AppSubmenu extends AppMenuEntry {
  const AppSubmenu({required this.label, required this.entries, this.checked});

  final String label;
  final List<AppMenuEntry> entries;
  final bool? checked;
}

class AppMenuDivider extends AppMenuEntry {
  const AppMenuDivider();
}
