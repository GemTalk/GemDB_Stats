import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToolIconButton extends StatefulWidget {
  const ToolIconButton({
    required this.icon,
    required this.onTap,
    super.key,
    this.tooltip,
    this.isActive = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final bool isActive;

  @override
  State<ToolIconButton> createState() => _ToolIconButtonState();
}

class _ToolIconButtonState extends State<ToolIconButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    if (widget.isActive) {
      bgColor = const Color(0xFFDCF5FF);
    } else if (_pressed) {
      bgColor = const Color.fromRGBO(0, 0, 0, 0.1);
    } else if (_hovered) {
      bgColor = const Color(0xfff4f5f5);
    } else {
      bgColor = Colors.transparent;
    }

    Widget button = Container(
      height: 28,
      width: 28,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: FaIcon(widget.icon, color: Colors.black54, size: 14),
    );

    if (widget.tooltip != null) {
      button = Tooltip(message: widget.tooltip!, child: button);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        behavior: HitTestBehavior.opaque,
        child: button,
      ),
    );
  }
}
