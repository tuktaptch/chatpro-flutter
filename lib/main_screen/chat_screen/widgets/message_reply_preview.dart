import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageReplyPreview extends StatelessWidget {
  const MessageReplyPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final messageReply = chatProvider.messageReplyModel;
        final isMe = messageReply?.isMe ?? false;
        return Container(
          decoration: BoxDecoration(
            color: CColors.pinkWhisper,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: ListTile(
            title: Text(
              isMe ? 'You' : messageReply?.senderName ?? '',
              style: CTypography.body3.copyWith(color: CColors.darkGray),
            ),
            subtitle: Text(
              messageReply?.message ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CTypography.body3.copyWith(color: CColors.darkGray),
            ),
            trailing: IconButton(
              onPressed: () => chatProvider.setMessageReplyModel(null),
              icon: Icon(Icons.close, size: 14, color: CColors.darkGray),
            ),
          ),
        );
      },
    );
  }
}
