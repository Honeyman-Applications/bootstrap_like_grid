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
          // access inherited data using builder context and BSContainerInheritance
          builder: (context) {
            return [
              // shows with of the container using BSContainerInheritance and builder
              Text(
                "Container Width: ${BSContainerInheritance.of(context).containerWidth.toString()}",
                textAlign: TextAlign.center,
              ),
              BSRow(
                children: [
                  Container(
                    color: Colors.pink,
                    child: const BSColumn(
                      paddingPadding: EdgeInsets.only(top: 5),
                      breakPoints: [
                        "col-xxl-3",
                        "col-xl-0",
                        "col-lg-3",
                        "col-md-0",
                        "col-sm-3",
                        "col-0",
                      ],
                      children: [],
                    ),
                  ),
                  Container(
                    color: Colors.greenAccent,
                    child: const BSColumn(
                      breakPoints: [
                        "col-xxl-3",
                        "col-xl-6",
                        "col-lg-3",
                        "col-md-6",
                        "col-sm-3",
                        "col-6",
                      ],
                      children: [
                        Text(
                          "Col 1",
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.green,
                    child: const BSColumn(
                      breakPoints: [
                        "col-xxl-3",
                        "col-xl-6",
                        "col-lg-3",
                        "col-md-6",
                        "col-sm-3",
                        "col-6",
                      ],
                      children: [
                        Text(
                          "Col 2",
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.pink,
                    child: const BSColumn(
                      paddingPadding: EdgeInsets.only(top: 5),
                      breakPoints: [
                        "col-xxl-3",
                        "col-xl-0",
                        "col-0",
                        "col-md-0",
                        "col-lg-3",
                        "col-sm-3",
                      ],
                      children: [],
                    ),
                  ),
                ],
              ),
              BSRow(
                children: [
                  Container(
                    color: Colors.pink,
                    child: const BSColumn(
                      paddingPadding: EdgeInsets.only(top: 5),
                      breakPoints: [
                        "col-xxl-2",
                        "col-xl-1",
                        "col-lg-2",
                        "col-md-1",
                        "col-sm-2",
                        "col-1",
                      ],
                      children: [],
                    ),
                  ),
                  Container(
                    color: Colors.blue,
                    child: BSColumn(
                      breakPoints: const [
                        "col-xxl-4",
                        "col-xl-5",
                        "col-lg-4",
                        "col-md-5",
                        "col-sm-4",
                        "col-5",
                      ],
                      // show container width using builder and BSColumnInheritance
                      builder: (context) {
                        return [
                          Text(
                            "Width: ${BSColumnInheritance.of(context).currentWidth}",
                          ),
                        ];
                      },
                    ),
                  ),
                  Container(
                    color: Colors.blueAccent,
                    child: BSColumn(
                      breakPoints: const [
                        "col-xxl-4",
                        "col-xl-5",
                        "col-lg-4",
                        "col-md-5",
                        "col-sm-4",
                        "col-5",
                      ],
                      // show container width using builder and BSColumnInheritance
                      builder: (context) {
                        return [
                          Text(
                            "Width: ${BSColumnInheritance.of(context).currentWidth}",
                          ),
                        ];
                      },
                    ),
                  ),
                  Container(
                    color: Colors.pink,
                    child: const BSColumn(
                      paddingPadding: EdgeInsets.only(top: 5),
                      breakPoints: [
                        "col-xxl-2",
                        "col-xl-1",
                        "col-1",
                        "col-md-1",
                        "col-lg-2",
                        "col-sm-2",
                      ],
                      children: [],
                    ),
                  ),
                ],
              ),
              BSRow(
                children: [
                  Container(
                    color: Colors.yellowAccent,
                    child: const BSColumn(
                      breakPoints: [
                        "col-md-6",
                      ],
                      children: [
                        Text(
                          "Stack after md 1",
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.yellow,
                    child: const BSColumn(
                      breakPoints: [
                        "col-md-6",
                      ],
                      children: [
                        Text(
                          "Stack after md 2",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ];
          },
        ),
      ),
    ),
  );
}
