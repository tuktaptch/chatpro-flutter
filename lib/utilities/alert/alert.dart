import 'package:chat_pro/di/modules/service_locator.dart';
import 'package:chat_pro/di/modules/services/navigation_service.dart';
import 'package:chat_pro/utilities/alert/toast_item.dart';
import 'package:flutter/material.dart';

class Alert {
  static void show(
    String message, {
    ToastType type = ToastType.info,
    bool isMultiple = false,
  }) {
    // ใช้ overlay จาก navigatorKey โดยตรง
    final overlayState =
        getIt<NavigationService>().navigatorKey.currentState?.overlay;
    if (overlayState == null) return;

    final toast = Toast(message: message, type: type, isMultiple: isMultiple);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) {
        return SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ToastItem(
              item: toast,
              animation: kAlwaysCompleteAnimation,
              onTap: () => entry.remove(),
            ),
          ),
        );
      },
    );

    overlayState.insert(entry);

    Future.delayed(const Duration(seconds: 3), () {
      if (entry.mounted) entry.remove();
    });
  }
}
