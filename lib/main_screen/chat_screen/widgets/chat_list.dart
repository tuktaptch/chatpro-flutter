import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/main_screen/chat_screen/chat_screen.dart';
import 'package:chat_pro/main_screen/chat_screen/widgets/contact_message_widget.dart';
import 'package:chat_pro/main_screen/chat_screen/widgets/my_message_widget.dart';
import 'package:chat_pro/models/message_model.dart';
import 'package:chat_pro/models/message_reply_model.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/provider/chat_provider.dart';
import 'package:chat_pro/utilities/chat_date_builder.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  final String contactUID;
  final String groupId;

  const ChatList({super.key, required this.contactUID, required this.groupId});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthenticationProvider>().userModel!.uid;
    return StreamBuilder<List<MessageModel>>(
      stream: (widget.contactUID.isNotEmpty || widget.groupId.isNotEmpty)
          ? context.read<ChatProvider>().getMessagesStream(
              userId: uid,
              contactUID: widget.contactUID,
              isGroup: widget.groupId,
            )
          : Stream.value([]), // ป้องกัน path ว่าง
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        if ((widget.contactUID.isEmpty && widget.groupId.isEmpty)) {
          return const ChatListShimmer();
        }

        final messages = snapshot.data ?? [];

        if (messages.isEmpty) {
          return Center(
            child: Text(
              'Start conversation...',
              style: CTypography.caption1.copyWith(color: CColors.grayBlue),
            ),
          );
        }
        //automatically scroll to the bottom on new message
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.position.animateTo(
            _scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        });
        if (snapshot.hasData) {
          return GroupedListView<MessageModel, DateTime>(
            padding: EdgeInsets.all(8),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            controller: _scrollController,
            elements: messages,
            groupBy: (element) => DateTime(
              element.timeSent.year,
              element.timeSent.month,
              element.timeSent.day,
            ),
            groupHeaderBuilder: (element) =>
                SizedBox(height: 40, child: buildChatDate(element)),
            groupComparator: (value1, value2) => value2.compareTo(value1),
            itemComparator: (item1, item2) =>
                item2.timeSent.compareTo(item1.timeSent),
            order: GroupedListOrder.ASC,
            useStickyGroupSeparators: true,
            reverse: true,
            floatingHeader: true,
            itemBuilder: (context, element) {
              //set message as seen
              if (!element.isSeen && element.senderUID != uid) {
                context.read<ChatProvider>().setMessageAsSeen(
                  userId: uid,
                  contactUID: widget.contactUID,
                  messageId: element.messageId,
                  groupId: widget.groupId,
                );
              }

              final isMe = element.senderUID == uid;
              return isMe
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: MyMessageWidget(
                        messages: element,
                        onRightSwipe: () {
                          //set message tpo reply
                          final messageReply = MessageReplyModel(
                            message: element.message,
                            senderUID: element.senderUID,
                            senderName: element.senderName,
                            senderImage: element.senderImage,
                            messageType: element.messageType,
                            isMe: isMe,
                          );
                          context.read<ChatProvider>().setMessageReplyModel(
                            messageReply,
                          );
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: ContactMessageWidget(
                        messages: element,
                        onRightSwipe: () {
                          //set message tpo reply
                          final messageReply = MessageReplyModel(
                            message: element.message,
                            senderUID: element.senderUID,
                            senderName: element.senderName,
                            senderImage: element.senderImage,
                            messageType: element.messageType,
                            isMe: isMe,
                          );
                          context.read<ChatProvider>().setMessageReplyModel(
                            messageReply,
                          );
                        },
                      ),
                    );
            },
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
