import 'package:flutter/material.dart';
import 'toast_item.dart';

class ToastListOverlay<T> extends StatefulWidget {
  const ToastListOverlay({
    super.key,
    required this.child,
    required this.itemBuilder,
  });

  final Widget child;
  final Widget Function(
    BuildContext context,
    T item,
    Animation<double> animation,
  )
  itemBuilder;

  @override
  State<ToastListOverlay<T>> createState() => _ToastListOverlayState<T>();

  static _ToastListOverlayState<T>? of<T>(BuildContext context) {
    return context.findAncestorStateOfType<_ToastListOverlayState<T>>();
  }
}

class _ToastListOverlayState<T> extends State<ToastListOverlay<T>>
    with TickerProviderStateMixin {
  final List<T> _items = [];

  void add(T item) => setState(() => _items.add(item));
  void remove(T item) => setState(() => _items.remove(item));

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _items.map((item) {
              return widget.itemBuilder(
                context,
                item,
                kAlwaysCompleteAnimation,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
