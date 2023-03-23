# CHANGELOG.md

## 1.2.0

- Added builder options to constructors to simplify access to inheritance
  objects
    - BSRow does not get a builder
        - cannot be used effectively
        - children must be a BSColumn, or contain a BSColumn
    - cannot specify both child and builder
- added support for col-0 and col-**-0
    - this way columns can assume 0 width when desired
- fixed sizing algorithm
    - works as expected
    - doesn't produce unexpected results on
        - wrong ordering of breakpoint labels
        - certain combinations of breakpoints
- new example showing 0 columns in use, and builders
- updated README

## 1.1.0

- added ```BSContainerInheritance.valueBasedOnBreakPoint```
    - returns value based on the current breakpoint in the passed context
- fixed error outputs

## 1.0.0

- updated license to MIT to be more free
- created git to track code
- removed ```bootstrap_like_breakpoints```
    - this is a stand alone package
- removed wrappers
- removed ```bs_row_state.dart```
- removed ```bs_column_state.dart```
- updated ```pubspec.yaml```
- added inheritance of parent data
    - children can depend on parent data
- made functions more reliable
- made nestable
- bug fixes

## 0.1.1

- updated to use bootstrap_like_breakpoints: ^0.2.0

## 0.1.0

- Updated example YAML
- Removed BSBreakPoints
    - is now provided by bootstrap_like_breakpoints
    - BSBreakPoints is still exported
- Added GNU license to example
- Updated Readme

## 0.0.3

- Formatted code
- Updated Readme

## 0.0.2

- Added imports to readme
- Formatted code
- Removed images in readme

## 0.0.1

Created:

- Container
- Row
- Column
- Breakpoints