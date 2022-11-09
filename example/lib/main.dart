/*
  Bradley Honeyman
  Nov 1, 2022

  This is a basic example of how to use bootstrap like grid

 */

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
