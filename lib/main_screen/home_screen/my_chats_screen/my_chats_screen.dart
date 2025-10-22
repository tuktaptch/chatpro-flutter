import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/main_screen/chat_screen/chat_screen.dart';
import 'package:chat_pro/main_screen/chat_screen/widgets/message_to_show.dart';
import 'package:chat_pro/main_screen/home_screen/my_chats_screen/my_chats_screen_providet.dart';
import 'package:chat_pro/models/last_message_model.dart';
import 'package:chat_pro/widgets/avartar/user_image_avertar.dart';
import 'package:chat_pro/widgets/no_data_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MyChatsScreen extends StatefulWidget {
  static const routeName = '/main/home/my-chats';
  const MyChatsScreen({super.key});

  @override
  State<MyChatsScreen> createState() => _MyChatsScreenState();
}

class _MyChatsScreenState extends State<MyChatsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Consumer<MyChatsScreenProvider>(
        builder: (context, provider, _) {
          return StreamBuilder<List<LastMessageModel>>(
            stream: provider.chatsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return _MyChatsShimmerLoading();
              }

              final chats = snapshot.data;
              if (chats == null || chats.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: const NoDataContainer(),
                );
              }

              return ListView.builder(
                key: const PageStorageKey('myChatsListView'),
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final lastMessage = provider.getLastMessage(chat);
                  final dateTime = provider.getFormattedTime(chat);

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.pushNamed(
                      context,
                      ChatScreen.routeName,
                      arguments: ChatScreenArguments(
                        contactUID: chat.contactUID,
                        contactImage: chat.contactImage,
                        contactName: chat.contactName,
                        groupId: '',
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CAvatar(
                        imageUrl: chat.contactImage,
                        size: CAvatarSize.large,
                      ),
                      title: Text(
                        chat.contactName,
                        style: CTypography.title.copyWith(
                          color: CColors.darkGray,
                        ),
                      ),
                      subtitle: MessageToShow(
                        type: chat.messageType,
                        message: lastMessage,
                      ),
                      trailing: Text(
                        dateTime,
                        style: CTypography.caption1.copyWith(
                          color: CColors.grayBlue,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _MyChatsShimmerLoading extends StatelessWidget {
  const _MyChatsShimmerLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: 6, // จำนวน shimmer แถว
      itemBuilder: (_, __) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 8),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: ListTile(
              contentPadding: EdgeInsets.zero,

              leading: CAvatar(imageUrl: '', size: CAvatarSize.large),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              subtitle: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              trailing: Container(
                width: MediaQuery.of(context).size.width * 0.1,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
