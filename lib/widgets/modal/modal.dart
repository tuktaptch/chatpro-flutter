import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:flutter/material.dart';

/// Shows a customizable modal dialog.
///
/// This function wraps [showDialog] and provides a pre-styled modal with title, optional content,
/// optional close button, and customizable action buttons.
///
/// Example usage:
/// ```dart
/// modal(
///   context: context,
///   title: 'Confirm Action',
///   modalContent: Text('Are you sure you want to proceed?'),
///   widgetButton: [
///     ElevatedButton(onPressed: () {}, child: Text('Yes')),
///     ElevatedButton(onPressed: () {}, child: Text('No')),
///   ],
/// );
/// ```
Future<T?> modal<T>({
  /// The build context to show the dialog in.
  required BuildContext context,

  /// The title text displayed at the top of the modal.
  required String title,

  /// Whether the content should be centered horizontally.
  /// Defaults to true.
  bool isCenterContent = true,

  /// Whether to show the close ("X") button at the top right corner.
  /// Defaults to true.
  bool isCloseBtn = true,

  /// Custom color for the close button icon. Defaults to [CColors.darkGray].
  Color? colorCloseBtn,

  /// Optional list of action buttons displayed at the bottom of the modal.
  /// Defaults to an empty [SizedBox] if not provided.
  List<Widget>? widgetButton,

  /// Optional callback triggered when the modal is closed.
  void Function()? onClose,

  /// Optional fixed height for the content area.
  /// If not provided, the height will wrap the content.
  double? contentHeight,

  /// The main content widget inside the modal.
  Widget? modalContent,

  /// Whether tapping outside the modal dismisses it.
  /// Defaults to true.
  bool isBarrierDismissible = true,

  bool isHorizontalBtn = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: isBarrierDismissible,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Center(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 50),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                decoration: const BoxDecoration(
                  color: CColors.paleBlue,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: isCenterContent
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: isCloseBtn
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isCloseBtn) const SizedBox(width: 48),
                        Flexible(
                          child: Container(
                            alignment: Alignment.center,
                            constraints: const BoxConstraints(minHeight: 32),
                            child: DefaultTextStyle(
                              style: CTypography.title.copyWith(
                                color: CColors.darkGray,
                              ),
                              child: Text(title, textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                        if (isCloseBtn)
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 16),
                              child: Icon(
                                Icons.close,
                                color: colorCloseBtn ?? CColors.darkGray,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (modalContent != null)
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 32,
                            bottom: (widgetButton != null) ? 32 : 0,
                          ),
                          child: SizedBox(
                            height: contentHeight,
                            child: SingleChildScrollView(child: modalContent),
                          ),
                        ),
                      ),
                    if (isHorizontalBtn)
                      Row(children: widgetButton ?? [const SizedBox()])
                    else
                      Column(children: widgetButton ?? [const SizedBox()]),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  ).then((value) {
    onClose?.call();
    return value;
  });
}
