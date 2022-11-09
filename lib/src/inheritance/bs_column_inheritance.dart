/*
  Bradley Honeyman
  Nov 6, 2022

  This class contains the data that is Inherited by children of the BSColumn
  The InheritedWidget, which passes data to all the children of BSColumnInheritance,
  allows children to update when BSColumnInheritance data updates, usually from a
  screen resize. The current width of the column can be used for display of widgets

 */
import 'package:flutter/cupertino.dart';

/// The InheritedWidget, which passes data to all the children of BSColumnInheritance,
/// allows children to update when BSColumnInheritance data updates, usually from a
/// screen resize. The current width of the column can be used for display of widgets
class BSColumnInheritance extends InheritedWidget {
  final double currentWidth;

  /// The InheritedWidget, which passes data to all the children of BSColumnInheritance,
  /// allows children to update when BSColumnInheritance data updates, usually from a
  /// screen resize. The current width of the column can be used for display of widgets
  const BSColumnInheritance({
    super.key,
    required super.child,
    required this.currentWidth,
  });

  /// confirm the passed context contains BSColumnInheritance, and if there is
  /// one, or more pass the nearest BSColumnInheritance in the Widget tree
  /// use this function to access BSColumnInheritance's data
  static BSColumnInheritance of(BuildContext context) {
    final BSColumnInheritance? result =
        context.dependOnInheritedWidgetOfExactType<BSColumnInheritance>();
    assert(result != null, 'No BSContainerWrapper found in context');
    return result!;
  }

  /// no need to call this function manually usually
  @override
  bool updateShouldNotify(BSColumnInheritance oldWidget) {
    return currentWidth != oldWidget.currentWidth;
  }
}
