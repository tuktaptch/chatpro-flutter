import 'package:flutter/material.dart';
import 'toast_list_overlay.dart';

import 'package:flutter/material.dart';
import 'toast_list_overlay.dart';

extension ToastContext on BuildContext {
  void hideToast<T>(T item) {
    ToastListOverlay.of<T>(this)?.remove(item);
  }
}
