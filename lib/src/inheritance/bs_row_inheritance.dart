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

  /// gets the breakpoint label indexes of a column, and the width factor
  /// of each breakpoint in the column breakpoint
  static List<List<int>> getColumBreakpointIndexes({
    required BSColumn column,
  }) {
    List<List<int>> indexes = [];
    // col- check RegExp
    RegExp colDashCheck = RegExp(r"(^col-)([0-9]|1[0-2])$");

    for (int i = 0; i < column.breakPoints.length; i++) {
      // ensure the current column breakpoint is lowercase
      String currentBreakPoint = column.breakPoints[i].toLowerCase();

      // check for col-
      if (colDashCheck.hasMatch(
        currentBreakPoint,
      )) {
        indexes.add(
          [
            BSBreakPointLabels.values.length - 1,
            int.parse(
              currentBreakPoint.replaceAll(
                RegExp('[^0-9]'),
                '',
              ),
            ),
          ],
        );
        continue;
      }

      // add all others, check for xl match in xxl also
      indexes.add(
        [
          BSBreakPointLabels.values.indexWhere((element) {
            if (currentBreakPoint.contains(
                  element.name,
                ) &&
                !(element.name == BSBreakPointLabels.xl.name &&
                    currentBreakPoint == BSBreakPointLabels.xxl.name)) {
              return true;
            }
            return false;
          }),
          int.parse(
            currentBreakPoint.replaceAll(
              RegExp('[^0-9]'),
              '',
            ),
          ),
        ],
      );
    }

    // sort xxl to col
    indexes.sort(
      (a, b) {
        return a[0] - b[0];
      },
    );

    return indexes;
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

    // get column breakpoint indexes in order from xxl to col
    List<List<int>> indexes = getColumBreakpointIndexes(
      column: column,
    );

    // find the applicable breakpoint
    for (int i = 0; i < indexes.length; i++) {
      if (indexes[i][0] >= currentBreakPointLabelIndex) {
        return indexes[i][1];
      }
    }

    // for compiler, should not be called ever
    // default is col-12 if nothing is entered
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
