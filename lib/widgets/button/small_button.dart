import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/widgets/button/button.dart';
import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color? textColor;
  final IconData? icon;
  final bool disable;
  final bool showLoading;
  final BoxShadow? shadow;

  const SmallButton({
    super.key,
    this.text,
    required this.onPressed,
    this.buttonColor = CColors.hotPink,
    this.textColor = CColors.darkGray,
    this.icon,
    this.disable = false,
    this.showLoading = false,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      buttonText: text,
      onPressed: onPressed,
      buttonColor: buttonColor,
      textColor: textColor,
      sizeButton: SizeButton.small,
      sizeHeight: 36, // สูงของปุ่มเล็ก
      sizeIcon: 16, // ขนาด icon เล็ก
      marginIcon: 4,
      borderRadius: 8,
      shadow: shadow,
      disable: disable,
      showLoading: showLoading,
    );
  }
}
