import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:flutter/material.dart';

/// A customizable application bar widget used throughout the app.
///
/// The [CAppBar] provides a consistent design for app bars with
/// custom typography, colors, and icons defined in the app’s
/// design system. It is a wrapper around Flutter’s [AppBar],
/// offering additional styling and default behaviors.
///
/// ### Features:
/// - Customizable title, actions, leading widget, and colors.
/// - Default back button with iOS-style arrow icon.
/// - Supports centralized or left-aligned titles.
/// - Consistent text and icon styles based on `CTypography` and `CColors`.
///
/// ### Example:
/// ```dart
/// Scaffold(
///   appBar: CAppBar(
///     title: 'Profile',
///     backgroundColor: Colors.white,
///     textColor: CColors.darkGray,
///     iconColor: CColors.darkGray,
///     actions: [
///       IconButton(
///         icon: Icon(Icons.settings),
///         onPressed: () {},
///       ),
///     ],
///   ),
///   body: ...
/// );
/// ```
///
/// ### Parameters:
/// - [title]: The title text displayed in the app bar.
/// - [actions]: Optional list of widgets displayed at the end of the app bar.
/// - [centerTitle]: Whether to center the title text. Defaults to `true`.
/// - [leading]: Optional leading widget. If not provided, a back button is shown.
/// - [backgroundColor]: Background color of the app bar.
/// - [elevation]: The z-coordinate of the app bar. Defaults to `0`.
/// - [textColor]: Color of the title text. Defaults to [CColors.darkGray].
/// - [iconColor]: Color of the icons in the app bar. Defaults to [CColors.darkGray].
class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;
  final Color? backgroundColor;
  final double elevation;
  final Color? textColor;
  final Color? iconColor;

  const CAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.leading,
    this.backgroundColor,
    this.elevation = 0,
    this.textColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: CTypography.heading2.copyWith(
          color: textColor ?? CColors.darkGray,
        ),
      ),
      actions: actions,
      centerTitle: centerTitle,
      leading:
          leading ??
          IconButton(
            onPressed: () => Navigator.pop(context),
            splashRadius: 20,
            icon: Icon(
              Icons.arrow_back_ios,
              color: iconColor ?? CColors.darkGray,
            ),
          ),
      backgroundColor: backgroundColor,
      elevation: elevation,
    );
  }
}
