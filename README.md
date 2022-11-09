# bootstrap_like_grid

## A grid system similar to the bootstrap's

- Container
- Row
- Column

## Post All Questions on StackOverflow, and tag @CatTrain (user:16200950)

<https://stackoverflow.com/>

## ```BSContainer```

The root of Bootstrap Like Grid. ```BSContainer``` must be the ancestor of ```BSRow```, and ```BSColumn```

- ```fluid```
  - if ```true``` the container is always at max size
  - default ```false```
- ```maxWidthIdentifier```
  - set the max width the container can be
  - **```fluid must == false if this option is used```**
  - values (```String```)
    - xxl = 1320
    - xl = 1140
    - lg = 960
    - md = 720
    - sm = 540
- ```children```
  - a list of [Widget](https://api.flutter.dev/flutter/widgets/Widget-class.html) that will have access to the ```BSContainerInheritance``` data
  - does not have to be ```BSRow```, but ```BSRow``` must be a child of ```BSContainer```
- default
  - width will be based on the nearest [MediaQueryData](https://api.flutter.dev/flutter/widgets/MediaQueryData-class.html), which is usually [MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp-class.html), which usually gives the screen size.
  - screen width breakpoints
    - xxl >= 1400
    - xl >= 1200
    - lg >= 992
    - md >= 768
    - sm >= 576
  - width based on screen breakpoint
    - xxl = 1320
    - xl = 1140
    - lg = 960
    - md = 720
    - sm = 540

## ```BSContainerInheritance```

- ```BSBreakPointLabels``` an enum representing breakpoint labels
  - xxl
  - xl
  - lg
  - md
  - sm
  - none
- ```BSContainerInheritance.containerWidths```
  - map ```BSBreakPointLabels``` to container widths
- ```BSContainerInheritance.breakPoints```
  - map ```BSBreakPointLabels``` to screen widths
- allow children of ```BSContainer``` to access the container's
  - ```containerWidth```
  - ```currentBSBreakPointLabel```

## ```BSRow```

Is either a row or a column, depending on if the sum of the children ```BSColumn``` breakpoints based on the parent ```BSContainerInheritance``` ```currentBSBreakPointLabel```.

- ```children```
  - All children must be a ```BSColumn```, or have a ```BSColumn``` nested before the bottom of that branch of the widget tree.
    - If the ```BSColumn``` is nested in a widget, that widget must have the ```BSColumn``` nested under it's **child** property, otherwise the ```BSRow``` will not be able to find it's data
    - ```BSColumn``` ```breakPoints``` are used to determine the ```BSRow``` current axis

## ```BSRowInheritance```

Passes the ```BSRow``` ```currentAxis``` to children, which is used by ```BSColumn``` to calculate the width of the column

## ```BSColumn```

Contains widgets to be displayed in the bootstrap like grid system, can be from 1/12 to 12/12 of the parent ```BSContainer``` width, which is based on the passed breakpoints.

- ```breakPoints```
  - list of ```String```
  - can have the following prefixes
    - col-*
    - col-sm-*
    - col-md-*
    - col-lg-*
    - col-lx-*
    - col-xxl-*
  - The suffix replaces the * in the prefix and can be from 1-12 inclusive
  - set the desired breakpoint based on the breakpoint of the screen

## ```BSColumnInheritance```

- passes the parent ```BSColum``` ```currentWidth``` to its children

## Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:bootstrap_like_grid/bootstrap_like_grid.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: BSContainer(
          children: const [
            Text("A widget just in the container"),
            BSRow(
              children: [
                BSColumn(
                  breakPoints: ["col-md-6"],
                  children: [
                    Text("1/2 width until smaller than md"),
                  ],
                ),
                BSColumn(
                  breakPoints: ["col-md-6"],
                  children: [
                    Text("1/2 width until smaller than md"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
```

## Nesting ```BSColumn```

```dart
import 'package:flutter/material.dart';
import 'package:bootstrap_like_grid/bootstrap_like_grid.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: BSContainer(
          children: [
            const Text("A widget just in the container"),
            BSRow(
              children: [
                Container(
                  color: Colors.yellow,
                  child: const BSColumn(
                    breakPoints: ["col-md-6"],
                    children: [
                      Text("1/2 width until smaller than md"),
                    ],
                  ),
                ),

                // nested BSColumn, see how this widget has a child property,
                // and BSColumn is in the child property
                Container(
                  color: Colors.teal,
                  child: const BSColumn(
                    breakPoints: ["col-md-6"],
                    children: [
                      Text("1/2 width until smaller than md"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
```

## Accessing Inherited Data

```dart
import 'package:flutter/material.dart';
import 'package:bootstrap_like_grid/bootstrap_like_grid.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: BSContainer(
          children: [
            const Text("A widget just in the container"),
            BSRow(
              children: [
                Container(
                  color: Colors.yellow,
                  child: const BSColumn(
                    breakPoints: ["col-md-6"],
                    children: [
                      Text("1/2 width until smaller than md"),
                    ],
                  ),
                ),

                // nested BSColumn, see how this widget has a child property,
                // and BSColumn is in the child property
                Container(
                  color: Colors.teal,
                  child: const BSColumn(
                    breakPoints: ["col-md-6"],
                    children: [
                      Text("1/2 width until smaller than md"),
                    ],
                  ),
                ),
              ],
            ),
            BSRow(
              children: [
                Container(
                  color: Colors.amber,
                  child: BSColumn(
                    breakPoints: const [
                      "col-xxl-4",
                      "col-xl-12",
                      "col-lg-4",
                      "col-md-12",
                      "col-sm-4",
                    ],
                    children: [
                      Builder(
                        builder: (context) => Text(
                          "BSContainer current width: ${BSContainerInheritance.of(context).containerWidth}",
                        ),
                      ),
                      Builder(
                        builder: (context) => Text(
                          "BSContainer current breakpoint: ${BSContainerInheritance.of(context).currentBSBreakPointLabel}",
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.lightBlueAccent,
                  child: BSColumn(
                    breakPoints: const [
                      "col-xxl-4",
                      "col-xl-12",
                      "col-lg-4",
                      "col-md-12",
                      "col-sm-4",
                    ],
                    children: [
                      Builder(
                        builder: (context) => Text(
                          "BSRow current axis: ${BSRowInheritance.of(context).currentAxis}",
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.pink,
                  child: BSColumn(
                    breakPoints: const [
                      "col-xxl-4",
                      "col-xl-12",
                      "col-lg-4",
                      "col-md-12",
                      "col-sm-4",
                    ],
                    children: [
                      // a context within the BSColumn must be used to get the
                      // column data
                      Builder(
                        builder: (context) => Text(
                          "BSColumn Width: ${BSColumnInheritance.of(context).currentWidth}",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
```
  