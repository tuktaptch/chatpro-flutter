import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:flutter/material.dart';

enum SizeButton { large, medium, small }

enum SizeIconButton { extraSmall, small, large, medium }

enum TypeButton { filled, outline }

enum Variant { normal, icon }

enum Shape { circle, square }

class Button extends StatelessWidget {
  /// A customizable button widget that can be used as a text button or an icon button.
  final IconData? icon;

  ///prefixWidget is used to set a custom widget at the start of the button text.
  final IconData? prefixIcon;

  ///prefixWidget is used to set a custom widget at the start of the button text.
  final Widget? prefixWidget;

  ///suffixWidget is used to set a custom widget at the end of the button text.
  final IconData? suffixIcon;

  ///suffixWidget is used to set a custom widget at the end of the button text.
  final Widget? suffixWidget;

  /// The text to display on the button. If null, only the icon will be shown.
  final String? buttonText;

  /// The color of the icon.
  /// If null, the icon will use the default color based on the button type.
  final Color? iconColor;

  ///buttonColor is used to set the background color of the button.
  final Color buttonColor;

  ///textColor is used to set the text color of the button.
  final Color? textColor;

  ///lineColor is used to set the border color of the button when typeButton is outline.
  final Color? lineColor;

  /// The callback function to be executed when the button is pressed.
  final VoidCallback onPressed;

  /// Size of the button, can be large, medium, or small.
  /// Default is medium.
  final SizeButton sizeButton;

  /// Type of the button, can be filled or outline.
  final TypeButton typeButton;

  /// Variant of the button, can be normal or icon.
  final Variant variant;

  /// Shape of the button, can be circle or square.
  final Shape? shape;

  /// Shadow of the button, can be null.
  final BoxShadow? shadow;

  /// Disable the button if true.
  /// Default is false.
  final bool disable;

  /// Height of the button.
  final double sizeHeight;

  /// Size of the icon.
  final double sizeIcon;

  /// Margin between icon and text.
  final double marginIcon;

  /// Border radius of the button.
  final double borderRadius;

  /// Color of the badge.
  final Color? badgeColor;

  /// Show badge if true.
  /// Default is false.
  final bool badge;

  /// Show loading indicator if true.
  /// Default is false.
  final bool showLoading;

  /// Border color of the button.
  final Color? borderColor;

  const Button({
    super.key,
    this.buttonText,
    required this.onPressed,
    this.icon,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.suffixWidget,
    this.iconColor,
    required this.buttonColor,
    this.textColor,
    this.lineColor,
    this.sizeButton = SizeButton.medium,
    this.typeButton = TypeButton.filled,
    this.variant = Variant.normal,
    this.shape = Shape.circle,
    required this.shadow,
    this.disable = false,
    required this.sizeHeight,
    required this.sizeIcon,
    required this.marginIcon,
    required this.borderRadius,
    this.badgeColor,
    this.badge = false,
    this.showLoading = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return variant == Variant.icon ? _buildIconButton() : _buildTextButton();
  }

  /// Helper: Get icon color based on disabled state
  Color? _getIconColor() =>
      disable ? iconColor?.withValues(alpha: 0.3) : iconColor;

  /// Helper: Get text color based on type and disabled state
  Color? _getTextColor() {
    if (typeButton == TypeButton.filled) return textColor;
    return disable ? lineColor?.withValues(alpha: 0.3) : lineColor;
  }

  /// Helper: build badge widget
  Widget _buildBadge() {
    return badge
        ? Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: badgeColor ?? CColors.orange,
              shape: BoxShape.circle,
            ),
          )
        : const SizedBox();
  }

  /// Helper: build icon button
  /// If badge is true, show badge at top right corner
  /// If disable is true, disable the button
  Widget _buildIconButton() {
    return Stack(
      children: [
        Container(
          width: sizeHeight,
          height: sizeHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: borderColor == null
                ? null
                : Border.all(color: borderColor!),
            shape: shape == Shape.circle ? BoxShape.circle : BoxShape.rectangle,
            boxShadow: shadow != null ? [shadow!] : null,
            color: disable ? buttonColor.withValues(alpha: 0.3) : buttonColor,
            borderRadius: shape == Shape.circle
                ? null
                : BorderRadius.circular(borderRadius),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            splashRadius: 1,
            onPressed: disable ? null : onPressed,
            icon: Icon(icon, color: _getIconColor(), size: sizeIcon),
          ),
        ),
        Positioned(
          top: sizeHeight * 0.01,
          right: sizeHeight * 0.01,
          child: _buildBadge(),
        ),
      ],
    );
  }

  /// Helper: build text button
  /// If prefixIcon or suffixIcon is not null, show the icon
  /// If prefixWidget or suffixWidget is not null, show the widget
  /// If disable is true, disable the button
  /// If showLoading is true, show loading indicator  before the text
  /// If text is too long, use Expanded to avoid overflow
  Widget _buildTextButton() {
    return Container(
      height: sizeHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadow != null ? [shadow!] : null,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          disabledBackgroundColor: typeButton == TypeButton.filled
              ? buttonColor.withValues(alpha: 0.3)
              : CColors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor: typeButton == TypeButton.filled
              ? buttonColor
              : CColors.lightBlue,
          side: typeButton == TypeButton.filled
              ? null
              : BorderSide(
                  color: disable
                      ? lineColor!.withValues(alpha: 0.3)
                      : lineColor!,
                ),
          fixedSize: Size.fromHeight(sizeHeight),
          padding: sizeButton == SizeButton.large
              ? const EdgeInsets.symmetric(horizontal: 28)
              : const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: disable ? null : onPressed,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final useExpanded = isTextOverflow(constraints);
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefixIcon != null)
                  Icon(prefixIcon, color: _getTextColor(), size: sizeIcon),
                if (prefixWidget != null && prefixIcon == null) prefixWidget!,
                if (prefixIcon != null || prefixWidget != null)
                  SizedBox(width: marginIcon),
                _buildTextContent(useExpanded),
                if (suffixIcon != null || suffixWidget != null)
                  SizedBox(width: marginIcon),
                if (suffixIcon != null)
                  Icon(suffixIcon, color: _getTextColor(), size: sizeIcon),
                if (suffixWidget != null && suffixIcon == null) suffixWidget!,
              ],
            );
          },
        ),
      ),
    );
  }

  /// Helper: Determine text alignment based on presence of prefix and suffix icons
  /// If both icons are present, center the text
  /// If only prefix icon is present, align text to the left
  /// If only suffix icon is present, align text to the right
  /// If no icons are present, center the text
  TextAlign _textAlignButton(IconData? prefixIcon, IconData? suffixIcon) {
    if (prefixIcon != null && suffixIcon != null) return TextAlign.center;
    if (prefixIcon != null) return TextAlign.left;
    if (suffixIcon != null) return TextAlign.right;
    return TextAlign.center;
  }

  /// Helper: build text content of the button
  /// If useExpanded is true, wrap the content in Expanded to avoid overflow
  /// If showLoading is true, show loading indicator before the text
  /// If text is null, show empty string
  Widget _buildTextContent(bool useExpanded) {
    Widget textWidget() => Text(
      buttonText ?? '',
      maxLines: sizeButton == SizeButton.large ? 2 : 1,
      overflow: TextOverflow.ellipsis,
      textAlign: _textAlignButton(prefixIcon, suffixIcon),
      style: sizeButton == SizeButton.large
          ? CTypography.title.copyWith(color: _getTextColor())
          : sizeButton == SizeButton.small
          ? CTypography.caption1.copyWith(color: _getTextColor())
          : CTypography.body2.copyWith(color: _getTextColor()),
    );

    Widget content = Row(
      mainAxisAlignment: showLoading
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      children: [
        if (showLoading)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                color: _getTextColor(),
                strokeWidth: 2,
              ),
            ),
          ),
        textWidget(),
      ],
    );

    return useExpanded ? Expanded(child: content) : content;
  }

  /// Helper: Check if text overflows the button width
  /// Return true if text overflows, else false
  /// Use TextPainter to measure the text width
  /// Compare the text width with the available space in the button
  /// Available space = button width - icon size - margin
  /// If text overflows, use Expanded to avoid overflow error
  /// This method is called in the LayoutBuilder of the button
  bool isTextOverflow(BoxConstraints constraints) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: buttonText ?? '',
        style: sizeButton == SizeButton.large
            ? CTypography.title.copyWith(color: _getTextColor())
            : sizeButton == SizeButton.small
            ? CTypography.caption1.copyWith(color: _getTextColor())
            : CTypography.body2.copyWith(color: _getTextColor()),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    final textSpace = constraints.maxWidth - sizeIcon - marginIcon;
    return textPainter.width > textSpace;
  }
}
