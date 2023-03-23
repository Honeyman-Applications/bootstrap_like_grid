/*
  Bradley Honeyman
  Nov 6, 2022

  The InheritedWidget, which passes data to all the children of BSContainer,
  allows children to update when BSContainer data updates, usually from a
  screen resize

 */

import 'package:flutter/material.dart';

/// enum values used to represent the breakpoint labels
enum BSBreakPointLabels {
  xxl,
  xl,
  lg,
  md,
  sm,
  none,
}

/// The InheritedWidget, which passes data to all the children of BSContainer,
/// allows children to update when BSContainer data updates, usually from a
/// screen resize
class BSContainerInheritance extends InheritedWidget {
  ///     BSBreakPointLabels.xxl: 1400.0, // >=
  ///     BSBreakPointLabels.xl: 1200.0, // >=
  ///     BSBreakPointLabels.lg: 992.0, // >=
  ///     BSBreakPointLabels.md: 768.0, // >=
  ///     BSBreakPointLabels.sm: 576.0, // >=
  ///     BSBreakPointLabels.none: 576.0, // <
  static const Map<BSBreakPointLabels, double> breakPoints = {
    BSBreakPointLabels.xxl: 1400.0, // >=
    BSBreakPointLabels.xl: 1200.0, // >=
    BSBreakPointLabels.lg: 992.0, // >=
    BSBreakPointLabels.md: 768.0, // >=
    BSBreakPointLabels.sm: 576.0, // >=
    BSBreakPointLabels.none: 576.0, // <
  };

  /// width of the container at each breakpoint.
  /// Unless the max width is smaller, or the container is in fluid mode
  ///     BSBreakPointLabels.xxl: 1320.0,
  ///     BSBreakPointLabels.xl: 1140.0,
  ///     BSBreakPointLabels.lg: 960.0,
  ///     BSBreakPointLabels.md: 720.0,
  ///     BSBreakPointLabels.sm: 540.0,
  ///     // smallest = parent width
  static const Map<BSBreakPointLabels, double> containerWidths = {
    BSBreakPointLabels.xxl: 1320.0,
    BSBreakPointLabels.xl: 1140.0,
    BSBreakPointLabels.lg: 960.0,
    BSBreakPointLabels.md: 720.0,
    BSBreakPointLabels.sm: 540.0,
    // smallest = parent width
  };

  /// throws error if BSContainerInheritance is not in the passed context
  /// returns the nearest BSContainerInheritance if it is in the passed
  /// context
  static BSContainerInheritance _checkIfInContext({
    required BuildContext context,
  }) {
    final BSContainerInheritance? result =
        context.dependOnInheritedWidgetOfExactType<BSContainerInheritance>();
    assert(result != null, 'No BSContainerInheritance found in context');
    return result!;
  }

  /// returns the value in the map based on the current breakpoint.
  /// if there is a missing breakpoint in the map null may be returned
  /// map example: {
  ///                 BSBreakPointLabels.xxl: "1",
  ///                 BSBreakPointLabels.xl: "2",
  ///                 BSBreakPointLabels.lg: "3",
  ///                 BSBreakPointLabels.md: "4",
  ///                 BSBreakPointLabels.sm: "5",
  ///                 BSBreakPointLabels.none: "6",
  ///               }
  static dynamic valueBasedOnBreakPoint({
    required BuildContext context,
    required Map<BSBreakPointLabels, dynamic> map,
  }) {
    // get the current container from the passed context
    BSContainerInheritance bsContainerInheritance = _checkIfInContext(
      context: context,
    );

    // return null if the passed map doesn't have a value for the current breakpoint
    if (!map.containsKey(bsContainerInheritance.currentBSBreakPointLabel)) {
      return null;
    }

    // return the value for the current breakpoint
    return map[bsContainerInheritance.currentBSBreakPointLabel];
  }

  /// confirm the passed context contains BSContainerInheritance, and if there is
  /// one, or more pass the nearest BSContainerInheritance in the Widget tree
  /// use this function to access BSContainerInheritance's data
  static BSContainerInheritance of(BuildContext context) {
    return _checkIfInContext(context: context);
  }

  /// the current width of the nearest parent BSContainer
  final double containerWidth;

  /// the current breakpoint label of the nearest parent BSContainer
  final BSBreakPointLabels currentBSBreakPointLabel;

  /// The InheritedWidget, which passes data to all the children of BSContainer,
  /// allows children to update when BSContainer data updates, usually from a
  /// screen resize
  const BSContainerInheritance({
    super.key,
    required super.child,
    required this.containerWidth,
    required this.currentBSBreakPointLabel,
  });

  /// no need to call this function manually usually
  @override
  bool updateShouldNotify(BSContainerInheritance oldWidget) {
    return containerWidth != oldWidget.containerWidth ||
        currentBSBreakPointLabel != oldWidget.currentBSBreakPointLabel;
  }
}
