import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/widgets/button/button.dart';
import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color? textColor;
  final bool disable;
  final bool showLoading;
  final BoxShadow? shadow;
  final TypeButton typeButton;
  final Color? iconColor;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  const LargeButton({
    super.key,
    this.text,
    required this.onPressed,
    this.buttonColor = CColors.hotPink,
    this.textColor = CColors.darkGray,
    this.disable = false,
    this.showLoading = false,
    this.shadow,
    this.typeButton = TypeButton.filled,
    this.iconColor,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      typeButton: typeButton,
      buttonText: text,
      onPressed: onPressed,
      buttonColor: buttonColor,
      textColor: textColor,
      sizeButton: SizeButton.large,
      sizeHeight: 52, // สูงของปุ่มใหญ่
      sizeIcon: 24, // ขนาด icon ใหญ่
      marginIcon: 8,
      borderRadius: 12,
      shadow: shadow,
      disable: disable,
      showLoading: showLoading,
      iconColor: iconColor,
    );
  }
}
