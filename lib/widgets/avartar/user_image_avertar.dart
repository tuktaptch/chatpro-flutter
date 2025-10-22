import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Standard avatar sizes
enum CAvatarSize {
  /// Small size (diameter = 28)
  small,

  /// Medium size (diameter = 40)
  medium,

  /// Large size (diameter = 60)
  large,

  /// Extra Large (diameter = 120)
  extraLarge,
}

/// Circular avatar widget that supports both network images and a fallback asset.
/// You can specify the size using [CAvatarSize] or provide a custom diameter using [customSize].
class CAvatar extends StatelessWidget {
  /// URL of the image to display.
  /// If null or empty, a fallback asset will be used.
  final String? imageUrl;

  /// Standard size of the avatar.
  /// Default is [CAvatarSize.medium].
  final CAvatarSize size;

  /// Custom diameter of the avatar.
  /// If provided, it overrides [size].
  final double? customSize;

  /// Whether to show a border around the avatar.
  final bool showBorder;

  /// Creates a circular avatar.
  const CAvatar({
    super.key,
    this.imageUrl,
    this.size = CAvatarSize.medium,
    this.customSize,
    this.showBorder = false,
  });

  /// Converts [CAvatarSize] to a radius value.
  double _getRadius() {
    switch (size) {
      case CAvatarSize.small:
        return 14; // diameter 28
      case CAvatarSize.medium:
        return 20; // diameter 40
      case CAvatarSize.large:
        return 30; // diameter 60
      case CAvatarSize.extraLarge:
        return 60;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use customSize if provided; otherwise, use size radius
    final double radius = customSize != null ? customSize! / 2 : _getRadius();

    // Check if a valid image URL exists
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return CircleAvatar(
      radius: radius + (showBorder ? 2 : 0),
      backgroundColor: showBorder ? Colors.white : Colors.transparent,
      child: ClipOval(
        child: hasImage
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: SizedBox(
                      width: radius / 1.2,
                      height: radius / 1.2,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/user.png',
                    width: radius * 2,
                    height: radius * 2,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : const CircleAvatar(
                // Fallback asset when no imageUrl is provided
                radius: 20,
                backgroundImage: AssetImage('assets/images/user.png'),
              ),
      ),
    );
  }
}
