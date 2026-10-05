import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

const _kLastDirectoryKey = 'last_file_directory';

class FileBar extends StatefulWidget {
  const FileBar({super.key, this.onFileSelected, this.leading, this.trailing});

  /// Called with the picked file. On the web it carries a stream of the
  /// file's bytes and no path; elsewhere it carries a path and no stream.
  final ValueChanged<PlatformFile>? onFileSelected;

  /// Pinned to the left edge, clear of the centered file name.
  final Widget? leading;
  final Widget? trailing;

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
      initialDirectory: kIsWeb ? null : lastDir,
      // Streamed, not read whole first: the load can start, and show its
      // progress, as soon as the file is picked.
      withReadStream: kIsWeb,
    );

    if (result != null) {
      final file = result.files.single;
      var name = file.name;

      // The web has no file system, so there is no folder to remember.
      if (!kIsWeb && file.path != null) {
        await prefs.setString(_kLastDirectoryKey, p.dirname(file.path!));
      }

      if (name.endsWith('.gz')) {
        name = name.substring(0, name.length - 3);
      }

      setState(() {
        _fileName = name;
      });
      widget.onFileSelected?.call(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: 36,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: .08)),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                fileNameDisplay(colorScheme),
                if (widget.trailing != null) widget.trailing!,
              ],
            ),
          ),
          if (widget.leading != null) Positioned(left: 2, child: widget.leading!),
        ],
      ),
    );
  }

  Widget fileNameDisplay(ColorScheme colorScheme) {
    return MouseRegion(
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
    );
  }
}
