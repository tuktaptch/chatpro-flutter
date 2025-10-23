import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/constraints/spacing.dart';
import 'package:chat_pro/enums/enums.dart';
import 'package:chat_pro/ui/chat_screen/widgets/display_message_type.dart';
import 'package:chat_pro/models/message_model.dart';
import 'package:chat_pro/utilities/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class ContactMessageWidget extends StatelessWidget {
  const ContactMessageWidget({
    super.key,
    required this.messages,
    required this.onRightSwipe,
  });
  final MessageModel messages;
  final Function() onRightSwipe;
  @override
  Widget build(BuildContext context) {
    final isReplying = messages.repliedTo.isNotEmpty;
    final senderName = messages.repliedTo == 'You'
        ? messages.senderName
        : 'You';
    return SwipeTo(
      onRightSwipe: (details) {
        onRightSwipe();
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
            minWidth: MediaQuery.of(context).size.width * 0.3,
          ),
          child: Container(
            padding: EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 4),
            decoration: BoxDecoration(
              color: CColors.pureWhite.withAlpha(180),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: messages.messageType == MessageEnum.text
                      ? EdgeInsetsGeometry.fromLTRB(10, 5, 20, 20)
                      : EdgeInsetsGeometry.fromLTRB(5, 5, 5, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isReplying) ...[
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: CColors.pinkWhisper,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  senderName,
                                  style: CTypography.body3.copyWith(
                                    color: CColors.darkGray,
                                  ),
                                ),
                                DisplayMessageType(
                                  message: messages.repliedMessage,
                                  type: messages.messageType,
                                  color: CColors.darkGray,
                                  isReply: false,
                                  viewOnly: false,
                                  overFlow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      DisplayMessageType(
                        message: messages.message,
                        type: messages.messageType,
                        color: CColors.darkGray,
                        isReply: false,
                        viewOnly: false,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Row(
                    children: [
                      Text(
                        messages.timeSent.formattedTime(),
                        style: CTypography.small.copyWith(
                          color: CColors.darkGray,
                        ),
                      ),
                      ConstSpacer.width4(),
                      Icon(
                        size: 14,
                        messages.isSeen ? Icons.done_all : Icons.done,
                        color: messages.isSeen
                            ? CColors.hotPink
                            : CColors.pureWhite,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
