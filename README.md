
# Shortcuts Display

A Flutter library for visually displaying keyboard shortcuts on the screen.

## Features:

- Customizable visual appearance for shortcut items and overall display.
- Animated appearance and disappearance of shortcuts.
- Configurable alignment, offset, duration, and curve for animations.
- Flexible binding of keyboard shortcuts to actions.

## Key Components:

- ShortcutItem: A custom widget representing a single shortcut item with customizable text and styling.
- ShortcutItemStyle: A class for configuring the visual styling of ShortcutItems.
- ShortcutsDisplayStyle: A class for customizing the overall appearance and behavior of the shortcuts display.
- ShortcutsDisplay: A StatefulWidget that manages the visibility and appearance of shortcuts based on user input and defined bindings.

## Usage:

1. Define shortcut bindings: Create a map associating keyboard shortcuts with their corresponding actions.
2. Wrap your widget tree with ShortcutsDisplay: Incorporate the ShortcutsDisplay widget into your UI hierarchy, providing the bindings map and the main content widget as children.
3. Customize appearance (optional): Optionally, use ShortcutsDisplayStyle to tailor the visual presentation and behavior of the shortcuts display.

## Example:

```dart
ShortcutsDisplay(
  bindings: {
    // Define your shortcut bindings here
    SingleActivator(LogicalKeyboardKey.keyA, control: true): 
        () => print("Ctrl+A pressed"),
  },
  child: MyApp(), // Your main app widget
),

```