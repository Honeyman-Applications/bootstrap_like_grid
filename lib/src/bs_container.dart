/*
  Bradley Honeyman
  Nov 1, 2022

  Needs to be a child of a Widget that contains MediaQueryData,
  typically this will be a MaterialApp
  Acts similarly to a Bootstrap container, can be
    fluid
      - match the width of the nearest MediaQueryData parent
    non-fluid
      - a static size when the screen is xxl, xl, lg, md, sm
      - acts the same as fluid if smaller than sm
    - maxWidthIdentifier
      - same as non-fluid, but will never be bigger than the specified
        breakpoint label

 */

import 'package:bootstrap_like_grid/src/inheritance/bs_container_inheritance.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

///  Needs to be a child of a Widget that contains MediaQueryData,
///  typically this will be a MaterialApp
///  Acts similarly to a Bootstrap container, can be
///    fluid
///      - match the width of the nearest MediaQueryData parent
///    non-fluid
///      - a static size when the screen is xxl, xl, lg, md, sm
///      - acts the same as fluid if smaller than sm
///    - maxWidthIdentifier
///      - same as non-fluid, but will never be bigger than the specified
///        breakpoint label
class BSContainer extends StatefulWidget {
  /// if true the container fills the max amount of it's parent
  /// if false (default) the container has it's size set based
  /// on how big the nearest parent with a MediaQueryData, which
  /// is usually the screen size. See BSContainer.containerWidths
  final bool fluid;

  /// use an enum value from BSBreakPointLabels to specify what
  /// BSContainer.containerWidths size is the max width the
  /// BSContainer can be
  final BSBreakPointLabels? maxWidthIdentifier;

  /// builder for the container passes a build context that can reference the
  /// container's inheritance
  final List<Widget> Function(BuildContext context)? builder;

  /*
    passed to the SingleChildScrollView
  */
  final Key? singleChildScrollViewKey;
  final ScrollController? singleChildScrollViewController;
  final Clip singleChildScrollViewClipBehavior;
  final DragStartBehavior singleChildScrollViewDragStartBehavior =
      DragStartBehavior.start;
  final ScrollViewKeyboardDismissBehavior
      singleChildScrollViewScrollViewKeyboardDismissBehavior =
      ScrollViewKeyboardDismissBehavior.manual;
  final EdgeInsetsGeometry? singleChildScrollViewPadding;
  final ScrollPhysics? singleChildScrollViewPhysics;
  final bool? singleChildScrollViewPrimary;
  final String? singleChildScrollViewRestorationId;
  final bool singleChildScrollViewReverse;
  final Axis singleChildScrollViewScrollDirection;

  /*
    Container
  */
  final Key? containerKey;
  final Alignment containerAlignment;
  final double? containerHeight;
  final double? containerWidth;
  final EdgeInsetsGeometry? containerPadding;
  final Clip containerClipBehavior;
  final Decoration? containerDecoration;
  final Color? containerColor;
  final BoxConstraints? containerConstraints;
  final Decoration? containerForegroundDecoration;
  final EdgeInsetsGeometry? containerMargin;
  final Matrix4? containerTransform;
  final AlignmentGeometry? containerTransformAlignment;

  /*
    passed to the SizedBox
  */

  /// passed to the SizedBox, leave as default unless you wish to set a
  /// static height for the BSContainer
  final double? height;
  final Key? sizedBoxKey;

  /*
    BSContainerInheritance
  */
  final Key? bsContainerInheritanceKey;

  /*
    Column
  */
  final Key? columnKey;
  final VerticalDirection columnVerticalDirection;
  final TextDirection? columnTextDirection;
  final TextBaseline? columnTextBaseline;
  final MainAxisAlignment columnMainAxisAlignment;
  final CrossAxisAlignment columnCrossAxisAlignment;
  final MainAxisSize columnMainAxisSize;

  /// recommend that children only be BSRow; however, non-BSRow children
  /// will be accepted. If the non-BSRow children add width this will
  /// produce unexpected results, and may cause errors. It is acceptable
  /// to wrap BSRow in a Widget such as a GestureDetector
  final List<Widget>? children;

  ///  Needs to be a child of a Widget that contains MediaQueryData,
  ///  typically this will be a MaterialApp
  ///  Acts similarly to a Bootstrap container, can be
  ///    fluid
  ///      - match the width of the nearest MediaQueryData parent
  ///    non-fluid
  ///      - a static size when the screen is xxl, xl, lg, md, sm
  ///      - acts the same as fluid if smaller than sm
  ///    - maxWidthIdentifier
  ///      - same as non-fluid, but will never be bigger than the specified
  ///        breakpoint label
  BSContainer({
    super.key,
    this.fluid = false,
    this.maxWidthIdentifier,
    this.builder,
    /*
      passed to the SingleChildScrollView
    */
    this.singleChildScrollViewKey,
    this.singleChildScrollViewController,
    this.singleChildScrollViewClipBehavior = Clip.hardEdge,
    this.singleChildScrollViewPadding,
    this.singleChildScrollViewPhysics,
    this.singleChildScrollViewPrimary,
    this.singleChildScrollViewRestorationId,
    this.singleChildScrollViewReverse = false,
    this.singleChildScrollViewScrollDirection = Axis.vertical,
    /*
      passed to the SizedBox
    */
    this.sizedBoxKey,
    this.height,
    /*
      Container
    */
    this.containerKey,
    this.containerAlignment = Alignment.topCenter,
    this.containerHeight,
    this.containerWidth,
    this.containerPadding,
    this.containerClipBehavior = Clip.none,
    this.containerDecoration,
    this.containerColor,
    this.containerConstraints,
    this.containerForegroundDecoration,
    this.containerMargin,
    this.containerTransform,
    this.containerTransformAlignment,
    /*
      BSContainerInheritance
    */
    this.bsContainerInheritanceKey,
    /*
      Column
    */
    this.children,
    this.columnKey,
    this.columnVerticalDirection = VerticalDirection.down,
    this.columnTextDirection,
    this.columnTextBaseline,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.columnCrossAxisAlignment = CrossAxisAlignment.center,
    this.columnMainAxisSize = MainAxisSize.max,
  }) {
    // confirm not both fluid and maxWidthIdentifier
    if (fluid && maxWidthIdentifier != null) {
      throw Exception(
        "BSContainer: fluid can't be true if a maxWidthIdentifier is passed",
      );
    }
  }

  @override
  State<StatefulWidget> createState() => _BSContainerState();
}

class _BSContainerState extends State<BSContainer> {
  /// the current width of the container, calculated very build
  double _containerWidth = 0.0;

  /// the current breakpoint label of the container, calculated very build
  BSBreakPointLabels _currentBSBreakPointLabel = BSBreakPointLabels.none;

  @override
  void initState() {
    super.initState();
    // check that either children or builder is passed, and not both
    if ((widget.children == null && widget.builder == null) ||
        (widget.children != null && widget.builder != null)) {
      throw Exception(
          "BSContainer: Must pass builder or children, can't pass both");
    }
  }

  /// calculates the current breakpoint based on the passed width
  /// the passed width should match the screen width, or the max
  /// width that the container can be
  BSBreakPointLabels _calculateCurrentBreakPoint({
    required double width,
  }) {
    // xxl
    if (width >= BSContainerInheritance.breakPoints[BSBreakPointLabels.xxl]!) {
      return BSBreakPointLabels.xxl;

      // xl
    } else if (width >=
        BSContainerInheritance.breakPoints[BSBreakPointLabels.xl]!) {
      return BSBreakPointLabels.xl;

      // lg
    } else if (width >=
        BSContainerInheritance.breakPoints[BSBreakPointLabels.lg]!) {
      return BSBreakPointLabels.lg;

      // md
    } else if (width >=
        BSContainerInheritance.breakPoints[BSBreakPointLabels.md]!) {
      return BSBreakPointLabels.md;

      // sm
    } else if (width >=
        BSContainerInheritance.breakPoints[BSBreakPointLabels.sm]!) {
      return BSBreakPointLabels.sm;

      // smallest - default
    } else {
      return BSBreakPointLabels.none;
    }
  }

  /// calculate the width of the container
  /// if fluid max max width, the width of the parent widget
  /// if maxWidthIdentifier don't let be bigger than the maxWidthIdentifier.
  /// ex maxWidthIdentifier = BSBreakPointLabels.sm the container will never be
  /// bigger than 540.0. If not fluid or maxWidthIdentifier, use the standard
  /// values based on the max container width/screen size
  double _calculateContainerWidth({
    required BuildContext context,
  }) {
    // get the width from the nearest MediaQueryData, usually the screen size
    double maxWidth = MediaQuery.of(context).size.width;

    // set the _currentBSBreakPointLabel based on the max available container width
    _currentBSBreakPointLabel = _calculateCurrentBreakPoint(
      width: maxWidth,
    );

    // if fluid make width as big as possible
    if (widget.fluid) {
      return maxWidth;
    }

    // if not fluid calculate the width
    double width;

    // set width to oen specified by BSContainer.containerWidths, unless
    // at smallest in that case use max width
    if (_currentBSBreakPointLabel != BSBreakPointLabels.none) {
      width =
          BSContainerInheritance.containerWidths[_currentBSBreakPointLabel]!;
    } else {
      width = maxWidth;
    }

    // if there is a maxWidthIdentifier, and the current width is greater than
    // maxWidthIdentifier, width = maxWidthIdentifier
    if (widget.maxWidthIdentifier != null &&
        width >
            BSContainerInheritance
                .containerWidths[widget.maxWidthIdentifier]!) {
      width =
          BSContainerInheritance.containerWidths[widget.maxWidthIdentifier]!;
    }

    // after width is calculated set it to calculated value unless the
    // calculated value is greater than maxWidth
    if (width > maxWidth) {
      return maxWidth;
    }
    return width;
  }

  /// returns the children if passed; otherwise returns the builder function
  /// with the context that contains the column's inheritance
  List<Widget> _buildContainerChildren(BuildContext context) {
    if (widget.children != null) {
      return widget.children!;
    }
    return widget.builder!(context);
  }

  @override
  Widget build(BuildContext context) {
    // recalculate, and set the _containerWidth every build
    // also calculate and set _currentBSBreakPointLabel
    _containerWidth = _calculateContainerWidth(
      context: context,
    );

    // by default allow content to be scrolled
    return SingleChildScrollView(
      key: widget.singleChildScrollViewKey,
      controller: widget.singleChildScrollViewController,
      clipBehavior: widget.singleChildScrollViewClipBehavior,
      dragStartBehavior: widget.singleChildScrollViewDragStartBehavior,
      keyboardDismissBehavior:
          widget.singleChildScrollViewScrollViewKeyboardDismissBehavior,
      padding: widget.singleChildScrollViewPadding,
      physics: widget.singleChildScrollViewPhysics,
      primary: widget.singleChildScrollViewPrimary,
      restorationId: widget.singleChildScrollViewRestorationId,
      reverse: widget.singleChildScrollViewReverse,
      scrollDirection: widget.singleChildScrollViewScrollDirection,

      // fill available space, and align content top center by default
      child: Container(
        key: widget.containerKey,

        // has a default value to align top center
        alignment: widget.containerAlignment,
        height: widget.containerHeight,
        width: widget.containerWidth,
        padding: widget.containerPadding,
        clipBehavior: widget.containerClipBehavior,
        decoration: widget.containerDecoration,
        color: widget.containerColor,
        constraints: widget.containerConstraints,
        foregroundDecoration: widget.containerForegroundDecoration,
        margin: widget.containerMargin,
        transform: widget.containerTransform,
        transformAlignment: widget.containerTransformAlignment,

        // build and ensure fits in constraints
        child: SizedBox(
          key: widget.sizedBoxKey,
          height: widget.height,

          // update the width of the size box;
          // therefore, the container based on the current size
          width: _containerWidth,

          // list children, should be BSRow in a column
          child: BSContainerInheritance(
            key: widget.bsContainerInheritanceKey,
            containerWidth: _containerWidth,
            currentBSBreakPointLabel: _currentBSBreakPointLabel,

            // column of children should be BSRow
            child: Builder(
              builder: (builderContext) => Column(
                key: widget.columnKey,
                verticalDirection: widget.columnVerticalDirection,
                textDirection: widget.columnTextDirection,
                textBaseline: widget.columnTextBaseline,
                mainAxisAlignment: widget.columnMainAxisAlignment,
                crossAxisAlignment: widget.columnCrossAxisAlignment,
                mainAxisSize: widget.columnMainAxisSize,
                children: _buildContainerChildren(
                  builderContext,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
