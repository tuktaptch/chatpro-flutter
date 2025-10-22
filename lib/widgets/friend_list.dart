import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/main_screen/chat_screen/chat_screen.dart';
import 'package:chat_pro/main_screen/profile_screen/profile_screen.dart';
import 'package:chat_pro/models/user_model.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/utilities/global_method.dart';
import 'package:chat_pro/widgets/avartar/user_image_avertar.dart';
import 'package:chat_pro/widgets/c_list_item.dart';
import 'package:chat_pro/widgets/no_data_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

enum FriendView { friends, friendRequests, groupView }

class FriendsList extends StatelessWidget {
  const FriendsList({super.key, required this.viewType});

  final FriendView viewType;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AuthenticationProvider>();
    final uid = provider.userModel?.uid ?? '';

    final future = switch (viewType) {
      FriendView.friends => provider.getFriendsList(uid: uid),
      FriendView.friendRequests => provider.getFriendsRequestList(uid: uid),
      FriendView.groupView => provider.getFriendsList(uid: uid),
    };

    return FutureBuilder<List<UserModel>>(
      future: future,
      builder: (context, snapshot) {
        // === Loading ===
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: FriendsListShimmer());
        }

        // === Error ===
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong',
              style: CTypography.title.copyWith(color: CColors.darkGray),
            ),
          );
        }

        final dataList = snapshot.data ?? [];

        // === Empty ===
        if (dataList.isEmpty) {
          return const Center(child: NoDataContainer());
        }

        // === Data List ===
        return ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            final data = dataList[index];
            return _buildFriendCard(context, provider, data);
          },
        );
      },
    );
  }

  Widget _buildFriendCard(
    BuildContext context,
    AuthenticationProvider provider,
    UserModel data,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: CColors.pureWhite,
      child: CListItem(
        leading: GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            ProfileScreen.routeName,
            arguments: ProfileScreenArguments(uid: data.uid),
          ),
          child: CAvatar(imageUrl: data.image, size: CAvatarSize.large),
        ),
        title: data.name,
        subtitle: data.aboutMe,
        trailing: InkWell(
          radius: 36,
          child: GradientIcon(icon: _displayIcon),
          onTap: () async => _handleTrailingTap(context, provider, data),
        ),
      ),
    );
  }

  Future<void> _handleTrailingTap(
    BuildContext context,
    AuthenticationProvider provider,
    UserModel data,
  ) async {
    switch (viewType) {
      case FriendView.friendRequests:
        await provider.acceptFriendRequest(friendUID: data.uid);
        if (context.mounted) {
          showSnackBar(
            context,
            'You are now friends with ${data.name}',
            Type.success,
          );
        }
        break;

      case FriendView.friends:
        // go to chat
        Navigator.pushNamed(
          context,
          ChatScreen.routeName,
          arguments: ChatScreenArguments(
            contactUID: data.uid,
            contactImage: data.image,
            contactName: data.name,
            groupId: '',
          ),
        );
        break;

      case FriendView.groupView:
        // TODO: handle group selection
        break;
    }
  }

  IconData get _displayIcon => switch (viewType) {
    FriendView.friends => Icons.chat,
    FriendView.friendRequests => Icons.check_circle_outline,
    FriendView.groupView => Icons.group,
  };
}

class FriendsListShimmer extends StatelessWidget {
  const FriendsListShimmer({super.key});

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
                    width: double.infinity,
                    height: 80,
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
