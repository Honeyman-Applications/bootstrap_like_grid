/*
  Bradley Honeyman
  Nov 2, 2022

  This is the column widget

  Should be the direct child of a BSRow; however, if required BSColumn can be
  nested in Widget's with "child" property, BSRow must be an ancestor of BSColumn.
  BSColumn has a default breakpoint of col-12. If there are two values for a
  single breakpoint range ex col-sm-1 & col-sm-2, the first in the array will
  be used. Note only col-, col-sm-, col-md-, col-lg-, col-xl-, col-xxl- prefixes
  are used. col, or col-md will not work

  ref https://getbootstrap.com/docs/4.0/layout/grid/

 */

import 'package:flutter/material.dart';
import 'package:bootstrap_like_grid/bootstrap_like_grid.dart';

///  Should be the direct child of a BSRow; however, if required BSColumn can be
///  nested in Widget's with "child" property, BSRow must be an ancestor of BSColumn.
///  BSColumn has a default breakpoint of col-12. If there are two values for a
///  single breakpoint range ex col-sm-1 & col-sm-2, the first in the array will
///  be used. Note only col-, col-sm-, col-md-, col-lg-, col-xl-, col-xxl- prefixes
///  are used. col, or col-md will not work
class BSColumn extends StatefulWidget {
  /*
    unique
   */
  final List<String> breakPoints;

  /*
    SizedBox
   */
  final double? sizedBoxHeight;
  final Key? sizedBoxKey;

  /*
    Padding
   */
  final Key? paddingKey;
  final EdgeInsetsGeometry paddingPadding;

  /*
    BSColumnInheritance
   */
  final Key? bsColumnInheritanceKey;

  /*
    Column
   */
  final List<Widget> children;
  final Key? columnKey;
  final MainAxisSize columnMainAxisSize;
  final CrossAxisAlignment columnCrossAxisAlignment;
  final MainAxisAlignment columnMainAxisAlignment;
  final TextBaseline? columnTextBaseline;
  final TextDirection? columnTextDirection;
  final VerticalDirection columnVerticalDirection;

  /// Should be the direct child of a BSRow; however, if required BSColumn can be
  /// nested in Widget's with "child" property, BSRow must be an ancestor of BSColumn.
  /// BSColumn has a default breakpoint of col-12. If there are two values for a
  /// single breakpoint range ex col-sm-1 & col-sm-2, the first in the array will
  /// be used. Note only col-, col-sm-, col-md-, col-lg-, col-xl-, col-xxl- prefixes
  /// are used. col, or col-md will not work
  const BSColumn({
    super.key,
    /*
      unique
    */
    this.breakPoints = const [
      "col-12",
    ],
    /*
      SizedBox
    */
    this.sizedBoxHeight,
    this.sizedBoxKey,
    /*
      Padding
    */
    this.paddingKey,
    this.paddingPadding = const EdgeInsets.only(
      left: 15,
      right: 15,
    ),
    /*
      BSColumnInheritance
    */
    this.bsColumnInheritanceKey,
    /*
      Column
    */
    required this.children,
    this.columnKey,
    this.columnMainAxisSize = MainAxisSize.max,
    this.columnCrossAxisAlignment = CrossAxisAlignment.center,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.columnTextBaseline,
    this.columnTextDirection,
    this.columnVerticalDirection = VerticalDirection.down,
  });

  @override
  State<StatefulWidget> createState() => _BSColumnState();
}

class _BSColumnState extends State<BSColumn> {
  /// holder for the current width of the column
  double _currentWidth = 0.0;

  @override
  void initState() {
    // set breakpoint regex test vars
    String regex =
        r"(^col-)(([1-9]|(1[0-2]))|((sm)|(md)|(lg)|(xl)|(xxl))-([1-9]|(1[0-2])))$";
    RegExp exp = RegExp(
      regex,
    );

    // confirm passed breakpoints are valid format
    // set all breakpoints to be lowercase
    for (int i = 0; i < widget.breakPoints.length; i++) {
      String currentBreakPoint = widget.breakPoints[i].toLowerCase();
      if (!exp.hasMatch(currentBreakPoint)) {
        throw FormatException(
          "BSColumn: passed breakpoint '$currentBreakPoint' does not match the regex $regex visit a site like https://regex101.com/ to test",
        );
      }
    }

    super.initState();
  }

  /// returns the width of a column based on the current context
  /// parent BSContainer's
  ///   containerWidth
  ///   currentBSBreakPointLabel
  /// parent BSRow's
  ///   currentAxis
  ///   getColumnCurrentBreakPointSizeFactor
  /// will return a width between 1 and 12, 12ths of the parent container
  /// this value will always have the Mantissa to be 0, so in the event of any
  /// floating point calculation errors the column is always smaller than the
  /// container, so there is no overflow
  double _calculateWidth({
    required BuildContext context,
  }) {
    // get container data
    BSContainerInheritance bsContainerWrapper =
        BSContainerInheritance.of(context);

    // get the max width from the parent container
    double maxWidth = bsContainerWrapper.containerWidth;

    // get parent row data
    BSRowInheritance bsRowData = BSRowInheritance.of(context);

    // if parent row is vertical, set to max width
    if (bsRowData.currentAxis == Axis.vertical) {
      return maxWidth;
    }

    // if horizontal get the width factor 1 - 12 inclusive
    int factor = BSRowInheritance.calculateColumnCurrentBreakPointSizeFactor(
      column: widget,
      currentBreakPointLabel: bsContainerWrapper.currentBSBreakPointLabel,
    );

    // divide the max width into 12ths,
    // return how many 12ths the column is in pixels
    // floor to ensure is smaller than container in case of
    // floating point calculation errors
    return ((maxWidth / 12) * factor).floorToDouble();
  }

  @override
  Widget build(BuildContext context) {
    // ensure rebuilds when BSContainer does
    BSContainerInheritance.of(context);

    // calculate the column width
    _currentWidth = _calculateWidth(
      context: context,
    );

    // forces the width of the column
    return SizedBox(
      key: widget.sizedBoxKey,
      // set width
      width: _currentWidth,
      height: widget.sizedBoxHeight,

      // padding for the colum - fits within sized box
      // default 15px on either side, can be changed
      child: Padding(
        key: widget.paddingKey,
        padding: widget.paddingPadding,

        // column
        child: BSColumnInheritance(
          key: widget.bsColumnInheritanceKey,
          currentWidth: _currentWidth,
          child: Column(
            key: widget.columnKey,
            mainAxisSize: widget.columnMainAxisSize,
            crossAxisAlignment: widget.columnCrossAxisAlignment,
            mainAxisAlignment: widget.columnMainAxisAlignment,
            textBaseline: widget.columnTextBaseline,
            textDirection: widget.columnTextDirection,
            verticalDirection: widget.columnVerticalDirection,
            children: widget.children,
          ),
        ),
      ),
    );
  }
}
