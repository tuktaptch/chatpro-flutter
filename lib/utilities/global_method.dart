//show snack bar
import 'package:chat_pro/constraints/c_colors.dart';
import 'package:flutter/material.dart';

enum Type { success, warning, information, failed, notification }

void showSnackBar(BuildContext context, String message, Type type) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: _getTypeColor(type)),
  );
}

Color _getTypeColor(Type type) {
  switch (type) {
    case Type.success:
      return CColors.green;
    case Type.warning:
      return CColors.warning;
    case Type.information:
      return CColors.blue;
    case Type.failed:
      return CColors.red;
    case Type.notification:
      return CColors.grayBlue;
  }
}
