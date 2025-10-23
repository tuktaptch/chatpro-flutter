import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/widgets/c_app_bar.dart';
import 'package:chat_pro/widgets/friend_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendRequestScreen extends StatefulWidget {
  const FriendRequestScreen({super.key});
  static const String routeName = '/main/friend_request';

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.background,
      appBar: CAppBar(
        title: 'Friend Request',
        backgroundColor: CColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            CupertinoSearchTextField(
              placeholder: 'Search',
              style: CTypography.caption1.copyWith(color: CColors.hotPink),
            ),
            Expanded(child: FriendsList(viewType: FriendView.friendRequests)),
          ],
        ),
      ),
    );
  }
}
