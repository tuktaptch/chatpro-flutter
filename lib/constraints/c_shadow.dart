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
}
