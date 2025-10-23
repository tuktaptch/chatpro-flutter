import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/constraints/spacing.dart';
import 'package:chat_pro/enums/enums.dart';
import 'package:flutter/material.dart';

class MessageToShow extends StatelessWidget {
  final MessageEnum type;
  final String message;

  const MessageToShow({super.key, required this.type, required this.message});

  @override
  Widget build(BuildContext context) {
    if (type == MessageEnum.text) {
      return _buildTextMessage();
    } else {
      return _buildMediaMessage(type);
    }
  }

  Widget _buildTextMessage() {
    return Text(
      message,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: CTypography.caption1.copyWith(color: CColors.grayBlue),
    );
  }

  Widget _buildMediaMessage(MessageEnum type) {
    final icon = _getIconForType(type);
    final label = _getLabelForType(type);

    return Row(
      children: [
        Icon(icon, color: CColors.grayBlue),
        ConstSpacer.width10(),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: CTypography.caption1.copyWith(color: CColors.grayBlue),
        ),
      ],
    );
  }

  IconData _getIconForType(MessageEnum type) {
    switch (type) {
      case MessageEnum.image:
        return Icons.image_outlined;
      case MessageEnum.video:
        return Icons.video_library_outlined;
      case MessageEnum.audio:
        return Icons.audiotrack_outlined;
      default:
        return Icons.help_outline;
    }
  }

  String _getLabelForType(MessageEnum type) {
    switch (type) {
      case MessageEnum.image:
        return 'Image';
      case MessageEnum.video:
        return 'Video';
      case MessageEnum.audio:
        return 'Audio';
      default:
        return message;
    }
  }
}
