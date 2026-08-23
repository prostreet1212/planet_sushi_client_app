import 'dart:math';

import 'package:flutter/material.dart';

class FixedCenterDockedFabLocation extends StandardFabLocation
    with FabCenterOffsetX, FabDockedOffsetY {
  const FixedCenterDockedFabLocation();

  @override
  String toString() => 'FloatingActionButtonLocation.fixedCenterDocked';

  @override
  double getOffsetY(
      ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    final double bottomMinInset = scaffoldGeometry.minInsets.bottom;
    if (bottomMinInset > 0) {
      // Hide if there's a keyboard
      return 0;
    }
    return super.getOffsetY(scaffoldGeometry, adjustment);
  }
}