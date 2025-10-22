import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/spacing.dart';
import 'package:chat_pro/main_screen/chat_screen/chat_screen_provider.dart';
import 'package:chat_pro/main_screen/chat_screen/widgets/bottom_chat_field.dart';
import 'package:chat_pro/main_screen/chat_screen/widgets/chat_app_bar.dart';
import 'package:chat_pro/main_screen/chat_screen/widgets/chat_list.dart';
import 'package:chat_pro/widgets/avartar/user_image_avertar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tuple/tuple.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = '/main/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as ChatScreenArguments;
      context.read<ChatScreenProvider>().init(args);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Selector<ChatScreenProvider, String>(
          selector: (_, provider) => provider.contactUID,
          builder: (_, contactUID, __) {
            if (contactUID.isEmpty) {
              return const _ChatAppBarShimmerLoading();
            }
            return ChatAppBar(contactUID: contactUID);
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CColors.pastelPink.withAlpha(50),
                CColors.lightPink.withAlpha(20),
              ],
              stops: [0.0, 0.5],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              CColors.pastelPink.withAlpha(50),
              CColors.lightPink.withAlpha(20),
            ],
            stops: [0.0, 0.5],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Selector<ChatScreenProvider, Tuple2<String, String>>(
                  selector: (_, provider) =>
                      Tuple2(provider.contactUID, provider.groupId ?? ''),
                  builder: (_, tuple, __) {
                    final contactUID = tuple.item1;
                    final groupId = tuple.item2;
                    return ChatList(contactUID: contactUID, groupId: groupId);
                  },
                ),
              ),
              Selector<
                ChatScreenProvider,
                Tuple4<String, String, String, String>
              >(
                selector: (_, provider) => Tuple4(
                  provider.contactUID,
                  provider.contactName,
                  provider.contactImage,
                  provider.groupId ?? '',
                ),
                builder: (_, tuple, __) {
                  return BottomChatField(
                    contactUID: tuple.item1,
                    contactName: tuple.item2,
                    contactImage: tuple.item3,
                    groupId: tuple.item4,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatAppBarShimmerLoading extends StatelessWidget {
  const _ChatAppBarShimmerLoading();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        children: [
          const CAvatar(
            imageUrl: '',
            size: CAvatarSize.medium,
            showBorder: true,
          ),
          ConstSpacer.width10(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              ConstSpacer.height6(),
              Container(
                width: 60,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatListShimmer extends StatelessWidget {
  const ChatListShimmer({super.key});

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
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChatScreenArguments {
  final String contactUID;
  final String contactName;
  final String contactImage;
  final String? groupId;
  ChatScreenArguments({
    required this.contactUID,
    required this.contactImage,
    required this.contactName,
    required this.groupId,
  });
}
