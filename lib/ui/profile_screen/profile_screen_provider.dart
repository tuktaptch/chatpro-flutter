import 'package:chat_pro/ui/authentication/login/login_screen.dart';
import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/utilities/global_method.dart';
import 'package:chat_pro/widgets/button/button.dart';
import 'package:chat_pro/widgets/button/large_button.dart';
import 'package:chat_pro/widgets/modal/modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreenProvider with ChangeNotifier {
  final AuthenticationProvider _authenticationProvider;
  ProfileScreenProvider(this._authenticationProvider);
  String _uid = '';
  String get uid => _uid;

  void init(String uid) {
    _uid = uid;
    notifyListeners();
  }

  String displayTitleText({
    required List<String> sentFriendRequestsUIDs,
    required String currentUser,
    required List<String> friendRequestsUIDs,
    required List<String> friendsUIDs,
  }) {
    if (friendsUIDs.contains(currentUser)) {
      return 'Unfriend';
    } else if (friendRequestsUIDs.contains(currentUser)) {
      return 'Cancel Friend Request';
    } else if (sentFriendRequestsUIDs.contains(currentUser)) {
      return 'Accept Friend Request';
    } else {
      return 'Send Friend Request';
    }
  }

  String displaySubTitleText({
    required List<String> sentFriendRequestsUIDs,
    required String currentUser,
    required List<String> friendRequestsUIDs,
    required List<String> friendsUIDs,
  }) {
    if (friendsUIDs.contains(currentUser)) {
      return 'Remove this user from your friends list.';
    } else if (friendRequestsUIDs.contains(currentUser)) {
      return 'Remove a friend request you’ve already sent.';
    } else if (sentFriendRequestsUIDs.contains(currentUser)) {
      return 'Accept the friend request from this user.';
    } else {
      return 'Invite someone to join your network.';
    }
  }

  String displayMessageText({
    required List<String> sentFriendRequestsUIDs,
    required String currentUser,
    required List<String> friendRequestsUIDs,
    required String userName,
    required List<String> friendsUIDs,
  }) {
    if (friendsUIDs.contains(currentUser)) {
      return 'You have unfriended.';
    } else if (friendRequestsUIDs.contains(currentUser)) {
      return 'Friend request canceled.';
    } else if (sentFriendRequestsUIDs.contains(currentUser)) {
      return 'You are now friends with $userName.';
    } else {
      return 'Friend request sent.';
    }
  }

  IconData displayIcon({
    required List<String> sentFriendRequestsUIDs,
    required String currentUser,
    required List<String> friendRequestsUIDs,
    required List<String> friendsUIDs,
  }) {
    if (friendsUIDs.contains(currentUser)) {
      return Icons.person_remove_alt_1; // Unfriend
    } else if (friendRequestsUIDs.contains(currentUser)) {
      return Icons.cancel; // Cancel friend request
    } else if (sentFriendRequestsUIDs.contains(currentUser)) {
      return Icons.check_circle_outline; // Accept request
    } else {
      return Icons.person_add_alt_1; // Send friend request
    }
  }

  Type displayTypeSnackBar({
    required List<String> sentFriendRequestsUIDs,
    required String uid,
    required List<String> friendRequestsUIDs,
  }) {
    if ((friendRequestsUIDs).contains(uid)) {
      return Type.failed;
    } else if ((sentFriendRequestsUIDs).contains(uid)) {
      return Type.success;
    } else {
      return Type.success;
    }
  }

  void onTapFriendRequest({
    required BuildContext context,
    required String currentUser,
    required List<String> sentFriendRequestsUIDs,
    required String friendUID,
    required List<String> friendRequestsUIDs,
    required String userName,
    required List<String> friendsUIDs,
    required BuildContext rootContext, // ✅ context หลักจาก Scaffold
  }) async {
    Type type = displayTypeSnackBar(
      sentFriendRequestsUIDs: sentFriendRequestsUIDs,
      uid: currentUser,
      friendRequestsUIDs: friendRequestsUIDs,
    );

    try {
      if (friendsUIDs.contains(currentUser)) {
        // 🧩 Unfriend
        await showConfirmUnfriend(context, friendUID: friendUID);
      } else if (friendRequestsUIDs.contains(currentUser)) {
        // 🧩 Cancel friend request (you sent)
        await _authenticationProvider.cancelFriendRequest(friendUID: friendUID);
        if (!context.mounted) return;
        showSnackBar(
          rootContext,
          displayMessageText(
            sentFriendRequestsUIDs: sentFriendRequestsUIDs,
            currentUser: currentUser,
            friendRequestsUIDs: friendRequestsUIDs,
            userName: userName,
            friendsUIDs: friendsUIDs,
          ),
          type,
        );
      } else if (sentFriendRequestsUIDs.contains(currentUser)) {
        // 🧩 Accept friend request (they sent you)
        await _authenticationProvider.acceptFriendRequest(friendUID: friendUID);
        if (!context.mounted) return;
        showSnackBar(
          rootContext,
          displayMessageText(
            sentFriendRequestsUIDs: sentFriendRequestsUIDs,
            currentUser: currentUser,
            friendRequestsUIDs: friendRequestsUIDs,
            userName: userName,
            friendsUIDs: friendsUIDs,
          ),
          type,
        );
      } else {
        // 🧩 Send new friend request
        await _authenticationProvider.sendFriendRequest(friendUID: friendUID);
        if (!context.mounted) return;
        showSnackBar(
          rootContext,
          displayMessageText(
            sentFriendRequestsUIDs: sentFriendRequestsUIDs,
            currentUser: currentUser,
            friendRequestsUIDs: friendRequestsUIDs,
            userName: userName,
            friendsUIDs: friendsUIDs,
          ),
          type,
        );
      }

      // ✅ Refresh data after any action
      await _authenticationProvider.fetchUserDataFromFireStore();

      notifyListeners();
    } on FirebaseException catch (e) {
      print('Friend request action failed: $e');
    }
  }

  Future<void> showConfirmUnfriend(
    BuildContext context, {
    required String friendUID,
  }) async {
    modal(
      context: context,
      title: 'Unfriend',
      modalContent: Text(
        'Are you sure you want to unfriend?',
        style: CTypography.body3.copyWith(color: CColors.darkGray),
        textAlign: TextAlign.center,
      ),
      isBarrierDismissible: false,
      widgetButton: [
        Expanded(
          child: LargeButton(
            text: 'Cancel',
            onPressed: () => {Navigator.pop(context)},
            buttonColor: CColors.red,
            textColor: CColors.pureWhite,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: LargeButton(
            buttonColor: CColors.green,
            textColor: CColors.pureWhite,
            text: 'Yes',
            typeButton: TypeButton.filled,
            onPressed: () async {
              Navigator.pop(context);
              await _authenticationProvider.removeFriendRequest(
                friendUID: friendUID,
              );
              if (!context.mounted) return;
              showSnackBar(context, 'You have unfriended', Type.success);
            },
          ),
        ),
      ],
    );
  }

  void showConfirmLogOut(BuildContext context) {
    modal(
      context: context,
      title: 'Logout',
      modalContent: Text(
        'Are you sure you want to logout?',
        style: CTypography.body3.copyWith(color: CColors.darkGray),
        textAlign: TextAlign.center,
      ),
      isBarrierDismissible: false,
      widgetButton: [
        Expanded(
          child: LargeButton(
            text: 'Cancel',
            onPressed: () => {Navigator.pop(context)},
            buttonColor: CColors.red,
            textColor: CColors.pureWhite,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: LargeButton(
            buttonColor: CColors.green,
            textColor: CColors.pureWhite,
            text: 'Yes',
            typeButton: TypeButton.filled,
            onPressed: () async {
              await _authenticationProvider.logOut().whenComplete(() {
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginScreen.routeName,
                    (route) => false,
                  );
                }
              });
            },
          ),
        ),
      ],
    );
  }
}
