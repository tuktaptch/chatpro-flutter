import 'package:chat_pro/constraints/c_colors.dart';
import 'package:flutter/material.dart';

class CShadow {
  // Private constructor to prevent instantiation
  CShadow._();

  /// Default shadow style
  static List<BoxShadow> get defaultShadow => [
    BoxShadow(
      color: CColors.lightBlue,
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  static List<BoxShadow> get pinkShadow => [
    BoxShadow(
      blurRadius: 4,
      color: CColors.hotPink.withAlpha(120),
      offset: const Offset(1, 1),
    ),
  ];
  static List<BoxShadow> get pinkLightShadow => [
    BoxShadow(
      blurRadius: 4,
      color: CColors.lightPink,
      offset: const Offset(1, 1),
    ),
  ];
}
