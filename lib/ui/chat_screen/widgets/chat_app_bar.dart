import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/ui/profile_screen/profile_screen.dart';
import 'package:chat_pro/models/user_model.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/widgets/avartar/user_image_avertar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatAppBar extends StatefulWidget {
  const ChatAppBar({super.key, required this.contactUID});

  final String contactUID;

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();
}

class _ChatAppBarState extends State<ChatAppBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<AuthenticationProvider>().usersStream(
        uid: widget.contactUID,
      ),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final userModel = UserModel.fromMap(
          snapshot.data!.data() as Map<String, dynamic>,
        );

        DateTime lastSeen = DateTime.fromMillisecondsSinceEpoch(
          int.parse(userModel.lastSeen),
        );

        return Row(
          children: [
            GestureDetector(
              child: CAvatar(
                imageUrl: userModel.image,
                size: CAvatarSize.medium,
                showBorder: true,
              ),
              onTap: () {
                // navigate to user profile with args
                // navigate to this friends profile with uid as argument
                Navigator.pushNamed(
                  context,
                  ProfileScreen.routeName,
                  arguments: ProfileScreenArguments(uid: userModel.uid),
                );
              },
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel.name,
                  style: CTypography.title.copyWith(color: CColors.darkGray),
                ),
                Text(
                  userModel.isOnline
                      ? 'Online'
                      : 'Last seen ${timeago.format(lastSeen)}',
                  //${timeago.format(lastSeen)}
                  style: CTypography.caption1.copyWith(
                    color: userModel.isOnline
                        ? CColors.green
                        : CColors.grayBlue,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
