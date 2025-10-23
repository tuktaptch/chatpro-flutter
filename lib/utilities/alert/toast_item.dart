import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:flutter/material.dart';

enum ToastType { success, failed, info, warning }

class Toast {
  final String message;
  final ToastType type;
  final bool isMultiple;

  Toast({required this.message, required this.type, this.isMultiple = false});
}

class ToastItem extends StatelessWidget {
  final Toast item;
  final Animation<double> animation;
  final VoidCallback onTap;

  const ToastItem({
    super.key,
    required this.item,
    required this.animation,
    required this.onTap,
  });

  Color _backgroundColor() {
    switch (item.type) {
      case ToastType.success:
        return CColors.green;
      case ToastType.failed:
        return CColors.red;
      case ToastType.info:
        return CColors.blue;
      case ToastType.warning:
        return CColors.warning;
    }
  }

  IconData _icon() {
    switch (item.type) {
      case ToastType.success:
        return Icons.check_circle_outline;
      case ToastType.failed:
        return Icons.error_outline;
      case ToastType.info:
        return Icons.info_outline;
      case ToastType.warning:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.3),
          end: Offset.zero,
        ).animate(animation),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _backgroundColor(),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: DefaultTextStyle(
              style: CTypography.caption1.copyWith(
                color: CColors.pureWhite,
                decoration: TextDecoration.none,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(_icon(), color: CColors.pureWhite),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CTypography.caption1.copyWith(
                        color: CColors.pureWhite,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(16),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          color: CColors.pureWhite,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
