/*
  Bradley Honeyman
  Nov 6, 2022

  This class is used to hold BSRow data that
  children rely on

 */

import 'package:flutter/material.dart';
import 'package:bootstrap_like_grid/bootstrap_like_grid.dart';

/// The InheritedWidget, which passes data to all the children of BSRowInheritance,
/// allows children to update when BSRowInheritance data updates, usually from a
/// screen resize. The current axis of the row is used to determine the size of
/// children BSColumn
class BSRowInheritance extends InheritedWidget {
  /// the current axis of the row, children columns max width if vertical
  final Axis currentAxis;

  /// confirm the passed context contains BSRowInheritance, and if there is
  /// one, or more pass the nearest BSRowInheritance in the Widget tree
  /// use this function to access BSRowInheritance's data
  static BSRowInheritance of(BuildContext context) {
    final BSRowInheritance? result =
        context.dependOnInheritedWidgetOfExactType<BSRowInheritance>();
    assert(result != null, 'No BSRowInheritance found in context');
    return result!;
  }

  /// get a BSColumn's breakpoint size factor from the columns breakpoints, and
  /// the current breakpoint set by the BSContainer
  /// ex if current breakpoint xxl, and the column has breakpoints col-md-5, and
  /// col-sm-3, 5 will be returned
  static int calculateColumnCurrentBreakPointSizeFactor({
    required BSColumn column,
    required BSBreakPointLabels currentBreakPointLabel,
  }) {
    // get current breakpoint index
    int currentBreakPointLabelIndex = BSBreakPointLabels.values.indexWhere(
      (element) => element == currentBreakPointLabel,
    );

    // col- check RegExp
    RegExp colDashCheck = RegExp(r"(^col-)([1-9]|1[0-2])$");

    // from xxl -> sm, starting at currentBreakPoint
    for (int i = currentBreakPointLabelIndex;
        i < BSBreakPointLabels.values.length;
        i++) {
      // check all breakpoints passed to the column
      for (int b = 0; b < column.breakPoints.length; b++) {
        // ensure the current column breakpoint is lowercase
        String currentBreakPoint = column.breakPoints[b].toLowerCase();

        // confirm currently valid breakpoint specified to the column
        if (
            // confirm current column breakpoint value isn't xxl if intend xl
            !(BSBreakPointLabels.values[i].name == "xl" &&
                    currentBreakPoint.contains(
                      "xxl",
                    )) &&
                // check if is col- or any other valid breakpoint
                (colDashCheck.hasMatch(
                      currentBreakPoint,
                    ) ||
                    currentBreakPoint.contains(
                      BSBreakPointLabels.values[i].name,
                    ))) {
          // return numbers from string as a int
          // will be 1-2 digits
          return int.parse(
            currentBreakPoint.replaceAll(
              RegExp('[^0-9]'),
              '',
            ),
          );
        }
      }
    }

    // if can't find a value return default 12
    return 12;
  }

  /// The InheritedWidget, which passes data to all the children of BSRowInheritance,
  /// allows children to update when BSRowInheritance data updates, usually from a
  /// screen resize. The current axis of the row is used to determine the size of
  /// children BSColumn
  const BSRowInheritance({
    super.key,
    required super.child,
    required this.currentAxis,
  });

  /// no need to call this function manually usually
  @override
  bool updateShouldNotify(BSRowInheritance oldWidget) {
    return currentAxis != oldWidget.currentAxis;
  }
}
