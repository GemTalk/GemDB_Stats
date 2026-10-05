import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vsd/presentation/menu/app_menu.dart';
import 'package:vsd/presentation/menu/menu_panel.dart';

// The button in VS Code's Light Modern theme, as vscode.dev renders it.
const _buttonSize = 32.0;
const _iconSize = 16.0;
const _idleColor = Color(0xFF616161);
const _activeColor = Color(0xFF3B3B3B);
const _hoverBackground = Color(0xFFF2F2F2);
const _openBackground = Color(0xFFE4E6F1);

/// Between the button and the menu it drops.
const _menuGap = 4.0;

/// How long the pointer rests on a submenu row before the submenu opens, and
/// how long an open submenu outlives the pointer moving to another row, so
/// that it can cut the corner on its way in (menu.ts).
const _showDelay = Duration(milliseconds: 250);
const _hideDelay = Duration(milliseconds: 750);

/// vscode.dev's hamburger: all the application menus folded into one button,
/// for wherever Flutter has no native menu bar. The menus' items sit directly
/// in it, each menu's set apart by a separator, rather than one level down
/// under the menus' names.
///
/// macOS goes through `platformMenusFrom` and the real system menu instead;
/// see `usesPlatformMenuBar`.
class AppMenuButton extends StatefulWidget {
  const AppMenuButton({required this.menus, super.key});

  final List<AppSubmenu> menus;

  @override
  State<AppMenuButton> createState() => _AppMenuButtonState();
}

/// One open panel of the cascade.
class _Level {
  _Level(this.entries, this.anchor);

  /// Replaced in place when the menus change while open; see [_refresh].
  List<AppMenuEntry> entries;

  /// What the panel is placed against: the button for the root menu, the
  /// parent row for a submenu.
  final Rect anchor;
  final panel = GlobalKey<MenuPanelState>();
  int? focused;

  /// Whether [focused] last moved by keyboard.
  bool keyboard = false;

  /// The row whose submenu is the next level down.
  int? expanded;
}

class _AppMenuButtonState extends State<AppMenuButton> with WidgetsBindingObserver {
  final _portal = OverlayPortalController();
  final _buttonFocus = FocusNode(debugLabel: 'Application Menu');
  final _menuFocus = FocusNode(debugLabel: 'Application Menu items');
  final _tapGroup = Object();
  final _levels = <_Level>[];
  Timer? _showTimer;
  Timer? _hideTimer;

  /// The row [_showTimer] will open, so hovering on it doesn't restart it.
  (int, int)? _pendingShow;
  bool _hovered = false;
  bool _focused = false;

  bool get _open => _levels.isNotEmpty;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cancelShow();
    _hideTimer?.cancel();
    _buttonFocus.dispose();
    _menuFocus.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AppMenuButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_open && !identical(oldWidget.menus, widget.menus)) {
      _refresh();
    }
  }

  /// VS Code closes its menus on resize rather than chase their anchors.
  @override
  void didChangeMetrics() => _close();

  Rect _buttonRect() {
    final box = context.findRenderObject()! as RenderBox;
    return box.localToGlobal(Offset.zero, ancestor: _overlayBox()) & box.size;
  }

  RenderObject _overlayBox() => Overlay.of(context).context.findRenderObject()!;

  /// The hamburger's own items: every menu's, set apart by separators.
  List<AppMenuEntry> _rootEntries() => [
    for (final (index, menu) in widget.menus.indexed) ...[
      if (index > 0) const AppMenuDivider(),
      ...menu.entries,
    ],
  ];

  void _show({required bool keyboard}) {
    final root = _Level(_rootEntries(), _buttonRect());
    // Opened from the keyboard, the menu lands on its first item.
    if (keyboard) {
      root
        ..focused = _step(root.entries, null, 1)
        ..keyboard = true;
    }
    setState(() => _levels.add(root));
    _portal.show();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_open) {
        _menuFocus.requestFocus();
      }
    });
  }

  /// Brings an open cascade up to date with new menus — a file load changes
  /// the File zone's label — by following its open submenus through them.
  /// A level whose rows no longer line up starts over, without submenus.
  ///
  /// Called from [didUpdateWidget], ahead of a build, so no setState.
  void _refresh() {
    _cancelShow();
    _hideTimer?.cancel();
    List<AppMenuEntry>? entries = _rootEntries();
    for (var depth = 0; depth < _levels.length && entries != null; depth++) {
      final level = _levels[depth];
      if (entries.length != level.entries.length) {
        level
          ..focused = null
          ..expanded = null;
      }
      level.entries = entries;
      final expanded = level.expanded;
      final next = expanded == null ? null : entries[expanded];
      if (next is AppSubmenu) {
        entries = next.entries;
      } else {
        _levels.removeRange(depth + 1, _levels.length);
        level.expanded = null;
        entries = null;
      }
    }
  }

  void _close({bool refocusButton = false}) {
    _cancelShow();
    _hideTimer?.cancel();
    if (!_open) {
      return;
    }
    setState(_levels.clear);
    _portal.hide();
    if (refocusButton) {
      _buttonFocus.requestFocus();
    }
  }

  void _cancelShow() {
    _showTimer?.cancel();
    _pendingShow = null;
  }

  /// Moves the highlight at [depth] to [index]. A submenu hanging off
  /// another row starts its [_hideDelay].
  void _focus(int depth, int index, {required bool keyboard}) {
    final level = _levels[depth];
    if (level.focused == index) {
      return;
    }
    setState(() {
      level
        ..focused = index
        ..keyboard = keyboard;
    });
    if (depth + 1 < _levels.length) {
      _hideTimer?.cancel();
      if (index != level.expanded) {
        _hideTimer = Timer(_hideDelay, () {
          if (depth < _levels.length && identical(_levels[depth], level)) {
            _collapse(depth);
          }
        });
      }
    }
  }

  void _hover(int depth, int index) {
    _focus(depth, index, keyboard: false);
    if (_pendingShow == (depth, index)) {
      return;
    }
    _cancelShow();
    final level = _levels[depth];
    if (level.entries[index] is AppSubmenu && index != level.expanded) {
      _pendingShow = (depth, index);
      _showTimer = Timer(_showDelay, () {
        _pendingShow = null;
        if (depth < _levels.length && identical(_levels[depth], level)) {
          _expand(depth, index, selectFirst: false);
        }
      });
    }
  }

  /// Clicks, and Enter or Space on the highlight.
  void _activate(int depth, int index) {
    switch (_levels[depth].entries[index]) {
      case AppMenuItem(:final onSelected):
        _close();
        onSelected();
      case AppSubmenu():
        _expand(depth, index, selectFirst: true);
      case AppMenuDivider():
        break;
    }
  }

  void _expand(int depth, int index, {required bool selectFirst}) {
    _cancelShow();
    _hideTimer?.cancel();
    final level = _levels[depth];
    final submenu = level.entries[index] as AppSubmenu;
    final anchor = level.panel.currentState!.rowRect(index, _overlayBox());
    final child = _Level(submenu.entries, anchor);
    if (selectFirst) {
      child
        ..focused = _step(submenu.entries, null, 1)
        ..keyboard = true;
    }
    setState(() {
      _levels
        ..removeRange(depth + 1, _levels.length)
        ..add(child);
      level
        ..focused = index
        ..expanded = index;
    });
  }

  /// Closes every submenu below [depth].
  void _collapse(int depth) {
    _hideTimer?.cancel();
    if (depth + 1 >= _levels.length) {
      return;
    }
    setState(() {
      _levels.removeRange(depth + 1, _levels.length);
      _levels[depth].expanded = null;
    });
  }

  /// Coming into a submenu puts its parent's highlight back on the row that
  /// opened it, and keeps it open.
  void _enter(int depth) {
    if (depth == 0) {
      return;
    }
    _hideTimer?.cancel();
    final parent = _levels[depth - 1];
    if (parent.focused != parent.expanded) {
      setState(() => parent.focused = parent.expanded);
    }
  }

  KeyEventResult _onMenuKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    // Keys act on the deepest highlight. A submenu opened by hover holds
    // none, so they stay with its parent until it is entered.
    var depth = _levels.length - 1;
    while (depth > 0 && _levels[depth].focused == null) {
      depth--;
    }
    final level = _levels[depth];
    final focused = level.focused;

    void move(int? index) {
      // The keyboard outranks a submenu the pointer was about to open.
      _cancelShow();
      if (index != null) {
        _focus(depth, index, keyboard: true);
      }
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        move(_step(level.entries, focused, 1));
      case LogicalKeyboardKey.arrowUp:
        move(_step(level.entries, focused, -1));
      case LogicalKeyboardKey.home || LogicalKeyboardKey.pageUp:
        move(_step(level.entries, null, 1));
      case LogicalKeyboardKey.end || LogicalKeyboardKey.pageDown:
        move(_step(level.entries, null, -1));
      case LogicalKeyboardKey.arrowRight when focused != null && level.entries[focused] is AppSubmenu:
        _expand(depth, focused, selectFirst: true);
      case LogicalKeyboardKey.enter || LogicalKeyboardKey.numpadEnter || LogicalKeyboardKey.space when focused != null:
        _activate(depth, focused);
      case LogicalKeyboardKey.arrowLeft:
        _collapse(math.max(depth - 1, 0));
      case LogicalKeyboardKey.escape:
        if (depth > 0) {
          _collapse(depth - 1);
        } else {
          _close(refocusButton: true);
        }
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  KeyEventResult _onButtonKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || _open) {
      return KeyEventResult.ignored;
    }
    switch (event.logicalKey) {
      case LogicalKeyboardKey.enter || LogicalKeyboardKey.space || LogicalKeyboardKey.arrowDown:
        _show(keyboard: true);
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  Widget _buildMenus(BuildContext context) => TapRegion(
    groupId: _tapGroup,
    onTapOutside: (_) => _close(),
    child: Focus(
      focusNode: _menuFocus,
      onKeyEvent: _onMenuKey,
      child: Stack(
        children: [
          for (final (depth, level) in _levels.indexed)
            CustomSingleChildLayout(
              delegate: _MenuLayout(level.anchor, submenu: depth > 0),
              child: MenuPanel(
                key: level.panel,
                entries: level.entries,
                focused: level.focused,
                reveal: level.keyboard,
                submenu: depth > 0,
                onHover: (index) => _hover(depth, index),
                onTap: (index) => _activate(depth, index),
                onEnter: () => _enter(depth),
              ),
            ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    // VS Code drops the hover look while the menu is open or focused.
    final active = _open || _focused;

    return OverlayPortal(
      controller: _portal,
      overlayChildBuilder: _buildMenus,
      child: TapRegion(
        groupId: _tapGroup,
        child: Semantics(
          button: true,
          expanded: _open,
          label: 'Application Menu',
          child: Focus(
            focusNode: _buttonFocus,
            onFocusChange: (focused) => setState(() => _focused = focused),
            onKeyEvent: _onButtonKey,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _hovered = true),
              onExit: (_) => setState(() => _hovered = false),
              child: GestureDetector(
                // Menus open on press, not release.
                onTapDown: (_) => _open ? _close() : _show(keyboard: false),
                child: Container(
                  width: _buttonSize,
                  height: _buttonSize,
                  decoration: BoxDecoration(
                    color: active
                        ? _openBackground
                        : _hovered
                        ? _hoverBackground
                        : null,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.menu,
                    size: _iconSize,
                    color: active || _hovered ? _activeColor : _idleColor,
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

/// The next row from [from] in direction [delta], skipping separators and
/// wrapping at the ends, as VS Code's action bar does. A null [from] starts
/// from outside the list.
int? _step(List<AppMenuEntry> entries, int? from, int delta) {
  final count = entries.length;
  var index = from ?? (delta > 0 ? -1 : count);
  for (var i = 0; i < count; i++) {
    index = (index + delta) % count;
    if (entries[index] is! AppMenuDivider) {
      return index;
    }
  }
  return null;
}

/// Places a panel the way VS Code's context view does: the root menu below
/// the button, a submenu beside its row and 4px above it, so that its first
/// row lines up with the one that opened it.
class _MenuLayout extends SingleChildLayoutDelegate {
  const _MenuLayout(this.anchor, {required this.submenu});

  final Rect anchor;
  final bool submenu;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // menu.ts caps a menu at the height below where it starts, less 35px,
    // and scrolls the rest. The 2 is the border, outside that cap.
    final top = submenu ? anchor.top : anchor.bottom + _menuGap;
    return BoxConstraints(
      maxWidth: constraints.maxWidth,
      maxHeight: math.max(10, constraints.maxHeight - top - 35) + 2,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) => submenu
      ? Offset(
          _place(size.width, childSize.width, anchor.left, anchor.width),
          _place(size.height, childSize.height, anchor.top - 4, 0),
        )
      : Offset(
          math.max(0, math.min(anchor.left, size.width - childSize.width)),
          anchor.bottom + _menuGap,
        );

  @override
  bool shouldRelayout(_MenuLayout oldDelegate) => oldDelegate.anchor != anchor || oldDelegate.submenu != submenu;
}

/// contextview.ts `layout`: after the anchor if the view fits there, else
/// before it, else as far along as the viewport allows.
double _place(double viewport, double view, double offset, double anchor) {
  if (view <= viewport - (offset + anchor)) {
    return offset + anchor;
  }
  if (view <= offset) {
    return offset - view;
  }
  return math.max(viewport - view, 0);
}
