import 'dart:math';

import 'package:flutter/material.dart';

/*class FixedCenterDockedFabLocation extends StandardFabLocation
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
}*/

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// FAB по центру над нижней навигацией, который НЕ сдвигается
/// вверх при появлении SnackBar.
class FixedCenterDockedFabLocation extends StandardFabLocation
    with FabCenterOffsetX, FabDockedOffsetY {
  const FixedCenterDockedFabLocation();

  @override
  String toString() => 'FloatingActionButtonLocation.fixedCenterDocked';

  @override
  double getOffsetY(
      ScaffoldPrelayoutGeometry scaffoldGeometry,
      double adjustment,
      ) {
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double contentMargin =
        scaffoldGeometry.scaffoldSize.height - contentBottom;
    final double bottomViewPadding = scaffoldGeometry.minViewPadding.bottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double bottomMinInset = scaffoldGeometry.minInsets.bottom;

    double safeMargin;
    if (contentMargin > bottomMinInset + fabHeight / 2.0) {
      // Места достаточно — отступ не нужен.
      safeMargin = 0.0;
    } else if (bottomMinInset == 0.0) {
      // Клавиатура не показана — используем нижний padding.
      safeMargin = bottomViewPadding;
    } else {
      // Клавиатура показана — сдвигаем FAB, чтобы не перекрывался.
      safeMargin = fabHeight / 2.0 + kFloatingActionButtonMargin;
    }

    double fabY = contentBottom - fabHeight / 2.0 - safeMargin;

    // ВАЖНО: в отличие от FabDockedOffsetY здесь намеренно НЕ учитываем
    // scaffoldGeometry.snackBarSize.height, поэтому при показе SnackBar
    // позиция FAB не меняется.

    if (bottomSheetHeight > 0.0) {
      fabY = math.min(fabY, contentBottom - bottomSheetHeight - fabHeight / 2.0);
    }

    final double maxFabY =
        scaffoldGeometry.scaffoldSize.height - fabHeight - safeMargin;
    return math.min(maxFabY, fabY) + adjustment;
  }
}