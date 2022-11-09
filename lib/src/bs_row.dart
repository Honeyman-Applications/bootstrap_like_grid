/*
  Bradley Honeyman
  Oct 8, 2021

  Ref: https://getbootstrap.com/docs/4.0/layout/grid/
 */

import 'package:flutter/material.dart';
import 'package:bootstrap_like_grid/bootstrap_like_grid.dart';

/// A row or a column based on it's BSColumn children's breakpoints
/// if the sum of the children column's breakpoints are greater than
/// 12 this is a column, otherwise it is a row
class BSRow extends StatefulWidget {
  /*
    BSRowInheritance
  */
  final Key? bsRowInheritanceKey;

  /*
    Flex
  */

  /// should be BSColumn. Can also nest BSColumn in Widgets, which have the
  /// child property, don't change the width of the BSColumn
  final List<Widget> children;
  final Key? flexKey;
  final MainAxisSize flexMainAxisSize;
  final CrossAxisAlignment flexCrossAxisAlignment;
  final MainAxisAlignment flexMainAxisAlignment;
  final TextBaseline? flexTextBaseline;
  final TextDirection? flexTextDirection;
  final VerticalDirection flexVerticalDirection;
  final Clip flexClipBehavior;

  /// A row or a column based on it's BSColumn children's breakpoints
  /// if the sum of the children column's breakpoints are greater than
  /// 12 this is a column, otherwise it is a row
  const BSRow({
    super.key,
    required this.children,
    /*
      BSRowInheritance
    */
    this.bsRowInheritanceKey,
    /*
      Flex
    */
    this.flexKey,
    this.flexMainAxisSize = MainAxisSize.max,
    this.flexCrossAxisAlignment = CrossAxisAlignment.center,
    this.flexMainAxisAlignment = MainAxisAlignment.start,
    this.flexTextBaseline,
    this.flexTextDirection,
    this.flexVerticalDirection = VerticalDirection.down,
    this.flexClipBehavior = Clip.none,
  });

  @override
  State<StatefulWidget> createState() => _BSRowState();
}

class _BSRowState extends State<BSRow> {
  /// the current axis of the row
  Axis _currentAxis = Axis.horizontal;

  /// recursively search for the nearest BSColumn,
  /// if there are no BSColumn an error will be thrown, because the method will
  /// reach the bottom of the widget tree. BSColumn can only be nested in Widgets
  /// with the property child
  BSColumn _findNearestColumnFromChild(dynamic current) {
    if (current.runtimeType == BSColumn) {
      return current as BSColumn;
    }

    return _findNearestColumnFromChild(current.child);
  }

  /// determines the rows axis from the sum of the children BSColumn breakpoint
  /// size factors, if the sum is greater than 12 vertical otherwise horizontal
  Axis _determineAxis({
    required BuildContext context,
  }) {
    // get the current breakpoint label
    BSBreakPointLabels breakPoint = BSContainerInheritance.of(
      context,
    ).currentBSBreakPointLabel;

    // sum the size factors of the children BSColumn
    int sizeFactorSum = 0;
    for (int i = 0; i < widget.children.length; i++) {
      // if the BSColumn isn't a direct child get the nested BSColumn
      sizeFactorSum +=
          BSRowInheritance.calculateColumnCurrentBreakPointSizeFactor(
        column: _findNearestColumnFromChild(
          widget.children[i],
        ),
        currentBreakPointLabel: breakPoint,
      );
    }

    // vertical if more than 12 otherwise horizontal
    if (sizeFactorSum <= 12) {
      return Axis.horizontal;
    }
    return Axis.vertical;
  }

  @override
  Widget build(BuildContext context) {
    // calculate the current axis
    _currentAxis = _determineAxis(
      context: context,
    );

    // pass data to children
    return BSRowInheritance(
      key: widget.bsRowInheritanceKey,
      currentAxis: _currentAxis,
      child: Flex(
        key: widget.flexKey,
        direction: _currentAxis,
        mainAxisSize: widget.flexMainAxisSize,
        crossAxisAlignment: widget.flexCrossAxisAlignment,
        mainAxisAlignment: widget.flexMainAxisAlignment,
        textBaseline: widget.flexTextBaseline,
        textDirection: widget.flexTextDirection,
        verticalDirection: widget.flexVerticalDirection,
        clipBehavior: widget.flexClipBehavior,
        children: widget.children,
      ),
    );
  }
}
