import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLastDirectoryKey = 'last_file_directory';

class FileBar extends StatefulWidget {
  const FileBar({super.key, this.onFileSelected});

  final ValueChanged<String>? onFileSelected;

  @override
  State<FileBar> createState() => _FileBarState();
}

class _FileBarState extends State<FileBar> {
  String? _fileName;
  bool _isHovering = false;

  Future<void> _pickFile() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDir = prefs.getString(_kLastDirectoryKey);

    final result = await FilePicker.platform.pickFiles(
      initialDirectory: lastDir,
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      var name = result.files.single.name;

      await prefs.setString(_kLastDirectoryKey, File(path).parent.path);

      final String content;
      if (path.endsWith('.gz')) {
        final compressed = await File(path).readAsBytes();
        content = utf8.decode(gzip.decode(compressed));
        name = name.substring(0, name.length - 3);
      } else {
        content = await File(path).readAsString();
      }

      setState(() {
        _fileName = name;
      });
      widget.onFileSelected?.call(content);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: .08)),
        ),
      ),
      child: fileNameDisplay(colorScheme),
    );
  }

  Widget fileNameDisplay(ColorScheme colorScheme) {
    return Center(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: _pickFile,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            height: 26,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: _isHovering ? colorScheme.primary.withValues(alpha: 0.02) : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _isHovering ? colorScheme.primary.withValues(alpha: 0.15) : Colors.black.withValues(alpha: .08),
              ),
            ),
            child: Row(
              spacing: 8,
              mainAxisAlignment: .center,
              children: [
                Icon(
                  Icons.insert_drive_file_outlined,
                  size: 18,
                  color: _fileName != null ? colorScheme.primary : Colors.black54,
                ),
                Text(
                  _fileName ?? 'No file selected',
                  style: TextStyle(
                    fontSize: 13,
                    color: _fileName != null ? colorScheme.onSurface : Colors.black54,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
