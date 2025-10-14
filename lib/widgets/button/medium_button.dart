import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/widgets/button/button.dart';
import 'package:flutter/material.dart';

class MediumButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color? textColor;
  final IconData? icon;
  final bool disable;
  final bool showLoading;
  final BoxShadow? shadow;
  final TypeButton typeButton;

  const MediumButton({
    super.key,
    this.text,
    required this.onPressed,
    this.buttonColor = CColors.hotPink,
    this.textColor = CColors.darkGray,
    this.icon,
    this.disable = false,
    this.showLoading = false,
    this.shadow,
    this.typeButton = TypeButton.filled,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      typeButton: typeButton,
      buttonText: text,
      onPressed: onPressed,
      buttonColor: buttonColor,
      textColor: textColor,
      sizeButton: SizeButton.medium,
      sizeHeight: 44, // สูงของปุ่มกลาง
      sizeIcon: 20, // ขนาด icon กลาง
      marginIcon: 6,
      borderRadius: 10,
      shadow: shadow,
      disable: disable,
      showLoading: showLoading,
    );
  }
}
