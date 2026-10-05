import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vsd/presentation/menu/app_menu.dart';

// Colors are VS Code's Light Modern theme, and metrics its menu stylesheet,
// both as vscode.dev renders them.
const _background = Color(0xFFFFFFFF);
const _foreground = Color(0xFF3B3B3B);
const _border = Color(0xFFCECECE);
const _separator = Color(0x333B3B3B);

/// `list.hoverBackground`, which VS Code uses for the keyboard highlight too.
const _highlight = Color(0xFFF2F2F2);
const _shadow = Color(0x24000000);
const _slider = Color(0x66646464);
const _sliderHover = Color(0xB3646464);
const _sliderActive = Color(0x99000000);
const _scrollShadow = Color(0xFFDDDDDD);

const _fontSize = 13.0;
const _radius = 8.0;

/// Above the first row and below the last.
const _padding = 4.0;

/// CSS `min-width`, which excludes the border.
const _minWidth = 160.0;
const _rowHeight = 24.0;
const _rowInset = 4.0;
const _rowRadius = 6.0;

/// 2em: the check column, and the label's padding on either side.
const _gutter = 26.0;

/// VS Code's chevron is a 16px codicon padded 1.8em either side, which sets
/// the row's natural width.
const _chevronBox = 16.0;
const _chevronPadding = 28.8;

/// Material's chevron is drawn smaller within its box than the codicon, so
/// it is sized to the codicon's height and set so its tip lands where the
/// codicon's does, 13.3px in from the row's edge.
const _chevronSize = 20.0;
const _chevronInset = 6.6;

/// Sized to the codicon check's width at 13px.
const _checkSize = 14.5;

const _separatorExtent = 11.0;

/// CSS blurs `0 0 12px` at a sigma of 6; Flutter derives sigma as
/// `0.57735 * blurRadius + 0.5`.
const _shadowBlur = 9.5;
const _fadeIn = Duration(milliseconds: 83);

final _scrollbarTheme = ScrollbarThemeData(
  thumbVisibility: const WidgetStatePropertyAll(true),
  trackVisibility: const WidgetStatePropertyAll(false),
  thickness: const WidgetStatePropertyAll(7),
  radius: const Radius.circular(4),
  crossAxisMargin: 0,
  mainAxisMargin: 0,
  thumbColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.dragged)) {
      return _sliderActive;
    }
    return states.contains(WidgetState.hovered) ? _sliderHover : _slider;
  }),
);

/// One panel of a menu cascade, drawn as VS Code draws its menus.
///
/// It only renders; which row is highlighted and what opens next is up to
/// the owner, through the callbacks.
class MenuPanel extends StatefulWidget {
  const MenuPanel({
    required this.entries,
    required this.focused,
    required this.onHover,
    required this.onTap,
    required this.onEnter,
    this.reveal = false,
    this.submenu = false,
    super.key,
  });

  final List<AppMenuEntry> entries;

  /// The highlighted row, as an index into [entries].
  final int? focused;

  /// Whether a change of [focused] scrolls it into view, as a keyboard move
  /// does and a pointer move doesn't.
  final bool reveal;

  /// Submenus fade in and cast a shadow; the root menu does neither.
  final bool submenu;

  final ValueChanged<int> onHover;
  final ValueChanged<int> onTap;

  /// The pointer came into the panel.
  final VoidCallback onEnter;

  @override
  State<MenuPanel> createState() => MenuPanelState();
}

class MenuPanelState extends State<MenuPanel> with SingleTickerProviderStateMixin {
  late final _fade = AnimationController(
    vsync: this,
    duration: _fadeIn,
    value: widget.submenu ? 0 : 1,
  )..forward();
  final _scroll = ScrollController();
  late TextStyle _style;
  late double _width;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _style = Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontSize: _fontSize,
      fontWeight: FontWeight.w400,
      height: 1,
      letterSpacing: 0,
      color: _foreground,
      decoration: TextDecoration.none,
    );
    _width = _naturalWidth(MediaQuery.textScalerOf(context));
  }

  @override
  void didUpdateWidget(MenuPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final focused = widget.focused;
    if (widget.reveal && focused != null && focused != oldWidget.focused) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _reveal(focused));
    }
  }

  @override
  void dispose() {
    _fade.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /// Where row [index] sits, in [ancestor]'s coordinates: the full inner
  /// width, as VS Code anchors submenus to it.
  Rect rowRect(int index, RenderObject ancestor) {
    final box = context.findRenderObject()! as RenderBox;
    final scrolled = _scroll.hasClients ? _scroll.offset : 0.0;
    final origin = box.localToGlobal(Offset(1, 1 + _rowTop(index) - scrolled), ancestor: ancestor);
    return origin & Size(box.size.width - 2, _rowHeight);
  }

  double _rowTop(int index) {
    var top = _padding;
    for (final entry in widget.entries.take(index)) {
      top += entry is AppMenuDivider ? _separatorExtent : _rowHeight;
    }
    return top;
  }

  /// Scrolls the least distance that shows row [index] whole.
  void _reveal(int index) {
    if (!mounted || !_scroll.hasClients) {
      return;
    }
    final position = _scroll.position;
    final top = _rowTop(index);
    final bottom = top + _rowHeight;
    if (top < position.pixels) {
      position.jumpTo(top);
    } else if (bottom > position.pixels + position.viewportDimension) {
      position.jumpTo(bottom - position.viewportDimension);
    }
  }

  /// The widest row decides, as the shrink-to-fit CSS box does.
  double _naturalWidth(TextScaler textScaler) {
    final painter = TextPainter(textDirection: TextDirection.ltr, textScaler: textScaler, maxLines: 1);
    var widest = 0.0;
    for (final entry in widget.entries) {
      if (entry case AppMenuItem(:final label) || AppSubmenu(:final label)) {
        painter
          ..text = TextSpan(text: label, style: _style)
          ..layout();
        final chevron = entry is AppSubmenu ? 2 * _chevronPadding + _chevronBox : 0;
        widest = math.max(widest, 2 * _gutter + painter.width + chevron);
      }
    }
    painter.dispose();
    return math.max(_minWidth, widest + 2 * _rowInset) + 2;
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.entries;

    return FadeTransition(
      opacity: _fade,
      child: MouseRegion(
        onEnter: (_) => widget.onEnter(),
        child: Container(
          width: _width,
          decoration: BoxDecoration(
            color: _background,
            border: Border.all(color: _border),
            borderRadius: BorderRadius.circular(_radius),
            boxShadow: widget.submenu ? const [BoxShadow(color: _shadow, blurRadius: _shadowBlur)] : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_radius - 1),
            child: DefaultTextStyle(
              style: _style,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false, overscroll: false),
                child: ScrollbarTheme(
                  data: _scrollbarTheme,
                  child: Scrollbar(
                    controller: _scroll,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          controller: _scroll,
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: _padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final (index, entry) in entries.indexed)
                                switch (entry) {
                                  AppMenuDivider() => const _Separator(),
                                  AppMenuItem(:final label, :final checked) ||
                                  AppSubmenu(:final label, :final checked) => _Row(
                                    label: label,
                                    checked: checked,
                                    submenu: entry is AppSubmenu,
                                    focused: index == widget.focused,
                                    onHover: () => widget.onHover(index),
                                    onTap: () => widget.onTap(index),
                                  ),
                                },
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 3,
                          child: IgnorePointer(child: _ScrollShadow(_scroll)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.checked,
    required this.submenu,
    required this.focused,
    required this.onHover,
    required this.onTap,
  });

  final String label;
  final bool? checked;
  final bool submenu;
  final bool focused;
  final VoidCallback onHover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    checked: checked,
    child: MouseRegion(
      onHover: (_) => onHover(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: _rowHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _rowInset),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: focused ? _highlight : null,
                borderRadius: BorderRadius.circular(_rowRadius),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: _gutter,
                    child: checked ?? false ? const Icon(Icons.check, size: _checkSize, color: _foreground) : null,
                  ),
                  Expanded(child: Text(label, maxLines: 1, softWrap: false, overflow: TextOverflow.clip)),
                  if (submenu)
                    Padding(
                      padding: const EdgeInsets.only(right: _chevronInset),
                      child: Icon(
                        Icons.chevron_right,
                        size: _chevronSize,
                        // Secondary glyphs sit at 70% until their row is highlighted.
                        color: focused ? _foreground : _foreground.withValues(alpha: .7),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: (_separatorExtent - 1) / 2),
    child: SizedBox(height: 1, child: ColoredBox(color: _separator)),
  );
}

/// The inset shade along the top edge while the panel is scrolled.
class _ScrollShadow extends StatelessWidget {
  const _ScrollShadow(this.scroll);

  final ScrollController scroll;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: scroll,
    builder: (context, _) => scroll.hasClients && scroll.offset > 0
        ? const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_scrollShadow, Color(0x00DDDDDD)],
              ),
            ),
          )
        : const SizedBox.shrink(),
  );
}
