library shortcuts_display;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A style class for customizing the appearance of [ShortcutItem] widget.
///
/// This class provides properties to define the visual styling such as
/// decoration, padding, margin, and text style for the [ShortcutItem] widget.
class ShortcutItemStyle with Diagnosticable {
  /// The decoration to be applied to the container wrapping the text.
  BoxDecoration? decoration;

  /// The padding inside the container wrapping the text.
  final EdgeInsetsGeometry padding;

  /// The margin around the container wrapping the text.
  final EdgeInsetsGeometry margin;

  /// The style of the text displayed inside the [ShortcutItem].
  final TextStyle textStyle;

  /// Creates a [ShortcutItemStyle].
  ///
  /// The [decoration] defaults to a BoxDecoration with a specific color and
  /// border radius.
  ///
  /// The [padding] and [margin] default to `EdgeInsets.all(15.0)`.
  ///
  /// The [textStyle] defaults to a TextStyle with white color and font size of 25.0.
  ShortcutItemStyle({
    this.padding = const EdgeInsets.all(15.0),
    this.margin = const EdgeInsets.all(15.0),
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 25.0,
    ),
    this.decoration,
  }) {
    // Default decoration for the ShortcutItemStyle
    decoration ??= BoxDecoration(
      color: const Color.fromARGB(202, 48, 52, 73),
      borderRadius: BorderRadius.circular(10),
    );
  }
}

/// A custom widget representing a shortcut item in the UI.
///
/// This widget displays a label text inside a container with customizable styling.
class ShortcutItem extends StatelessWidget {
  /// Creates a [ShortcutItem].
  ///
  /// The [key] parameter is the widget's key.
  ///
  /// The [label] parameter specifies the text to be displayed as the shortcut label.
  ///
  /// The [style] parameter allows customization of the visual appearance of the [ShortcutItem].
  const ShortcutItem({
    super.key,
    required this.label,
    this.style,
  });

  /// The text to be displayed as the shortcut label.
  final String label;

  /// The style for customizing the appearance of the [ShortcutItem].
  final ShortcutItemStyle? style;

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final ShortcutItemStyle _style = style ?? ShortcutItemStyle();
    return Container(
      decoration: _style.decoration,
      padding: _style.padding,
      margin: _style.margin,
      child: Text(
        label,
        style: _style.textStyle,
      ),
    );
  }
}

/// A class representing the display style for the shortcuts in the UI.
///
/// This class provides properties to configure the visual appearance and behavior
/// of the shortcuts when displayed on the screen.
class ShortcutsDisplayStyle with Diagnosticable {
  /// The offset for displaying the shortcuts relative to their alignment.
  final Offset offset;

  /// The alignment of the shortcuts on the screen.
  final AlignmentGeometry alignment;

  /// The duration for animating the appearance of the shortcuts.
  final Duration durationIn;

  /// The duration for animating the disappearance of the shortcuts.
  final Duration durationOut;

  /// The curve for controlling the animation of the shortcuts.
  final Curve curve;

  /// The widget used as a separator between shortcuts.
  final Widget separator;

  /// The style for customizing the appearance of shortcut items.
  ShortcutItemStyle? itemStyle;

  /// Creates a [ShortcutsDisplayStyle].
  ///
  /// The [offset] defaults to (0.0, -200).
  ///
  /// The [alignment] defaults to [Alignment.bottomCenter].
  ///
  /// The [durationIn] defaults to 2 seconds.
  ///
  /// The [durationOut] defaults to 1 second.
  ///
  /// The [curve] defaults to [Curves.easeOut].
  ///
  /// The [separator] defaults to an Icon with [Icons.add], white color, and size 30.
  ///
  /// The [itemStyle] defaults to a [ShortcutItemStyle].
  ShortcutsDisplayStyle({
    this.offset = const Offset(0.0, -200),
    this.alignment = Alignment.bottomCenter,
    this.durationIn = const Duration(seconds: 2),
    this.durationOut = const Duration(seconds: 1),
    this.curve = Curves.easeOut,
    this.separator = const Icon(
      Icons.add,
      color: Colors.white,
      size: 30,
    ),
    this.itemStyle,
  }) {
    itemStyle ??= ShortcutItemStyle();
  }
}

/// A StatefulWidget that displays shortcuts and their associated actions.
///
/// This widget manages the visibility and appearance of shortcuts displayed
/// on the screen in response to user input.
class ShortcutsDisplay extends StatefulWidget {
  /// Creates a [ShortcutsDisplay].
  ///
  /// The [bindings] parameter is a map containing shortcut bindings and their associated actions.
  ///
  /// The [child] parameter is the widget tree to display.
  ///
  /// The [style] parameter is used to customize the appearance and behavior of the shortcuts display.
  const ShortcutsDisplay({
    super.key,
    required this.bindings,
    required this.child,
    this.style,
  });

  /// A map containing shortcut bindings and their associated actions.
  final Map<SingleActivator, VoidCallback> bindings;

  /// The widget tree to display.
  final Widget child;

  /// The style for customizing the appearance and behavior of the shortcuts display.
  final ShortcutsDisplayStyle? style;

  @override
  State<ShortcutsDisplay> createState() => _ShortcutsDisplayState();
}

class _ShortcutsDisplayState extends State<ShortcutsDisplay> {
  bool _isVisible = false;
  List<String> activeBindings = [];
  late ShortcutsDisplayStyle style;

  @override
  void initState() {
    super.initState();
    style = widget.style ?? ShortcutsDisplayStyle();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: _mapShortcuts(
        bindings: widget.bindings,
        preFunc: defaultPreFunc,
        postFunc: defaultPostFunc,
      ),
      child: Focus(
        autofocus: true,
        child: Center(
          child: Stack(
            children: [
              widget.child,
              Transform.translate(
                offset: style.offset,
                child: Align(
                  alignment: style.alignment,
                  child: AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: style.durationOut,
                    curve: style.curve,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: activeBindings
                          .map(
                            (e) => <Widget>[
                              ShortcutItem(
                                label: e,
                                style: style.itemStyle,
                              ),
                              if (e != activeBindings.last) style.separator
                            ],
                          )
                          .expand((element) => element)
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void defaultPostFunc() => Timer(style.durationIn, () {
        if (mounted) {
          setState(() {
            _isVisible = false;
          });
        }
      });

  void defaultPreFunc(SingleActivator shortcut) => setState(() {
        _isVisible = true;
        activeBindings.clear();
        if (shortcut.alt) {
          activeBindings.add("Alt");
        }
        if (shortcut.control) {
          activeBindings.add("Ctrl");
        }
        if (shortcut.shift) {
          activeBindings.add("Shift");
        }
        activeBindings.add(shortcut.trigger.keyLabel);
      });

  Map<ShortcutActivator, VoidCallback> _mapShortcuts({
    required Map<SingleActivator, VoidCallback> bindings,
    required void Function(SingleActivator shortcuts) preFunc,
    required VoidCallback postFunc,
  }) {
    Map<SingleActivator, VoidCallback> newBindings = {};

    for (var binding in bindings.entries) {
      newBindings[binding.key] = () {
        preFunc(binding.key);
        binding.value();
        postFunc();
      };
    }

    return newBindings;
  }
}