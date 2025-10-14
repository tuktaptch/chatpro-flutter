import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/constraints/spacing.dart';
import 'package:chat_pro/main_screen/profile_screen/profile_screen_provider.dart';
import 'package:chat_pro/models/user_model.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/widgets/avartar/user_image_avertar.dart';
import 'package:chat_pro/widgets/button/large_button.dart';
import 'package:chat_pro/widgets/c_app_bar.dart';
import 'package:chat_pro/widgets/c_list_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/main_screen/profile_screen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as ProfileScreenArguments;
      context.read<ProfileScreenProvider>().init(args.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.background,
      appBar: _buildAppBar(context),
      body: Selector<ProfileScreenProvider, String>(
        selector: (_, provider) => provider.uid,
        builder: (context, uid, _) {
          if (uid.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<DocumentSnapshot>(
            stream: context.read<AuthenticationProvider>().usersStream(
              uid: uid,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return _buildMessage('Something went wrong');
              if (snapshot.connectionState == ConnectionState.waiting)
                return const Center(child: CircularProgressIndicator());
              if (!snapshot.hasData || snapshot.data?.data() == null)
                return _buildMessage('No user data found');

              final userModel = UserModel.fromMap(
                snapshot.data!.data() as Map<String, dynamic>,
              );

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ProfileHeader(),
                    ConstSpacer.height16(),
                    ActionList(userModel: userModel),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _LogoutButton(),
    );
  }

  CAppBar _buildAppBar(BuildContext context) {
    return CAppBar(
      backgroundColor: CColors.background,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        splashRadius: 20,
        icon: Icon(Icons.arrow_back_ios, color: CColors.darkGray),
      ),
      title: 'Profile',
    );
  }

  Widget _buildMessage(String message) {
    return Center(
      child: Text(
        message,
        style: CTypography.body1.copyWith(color: CColors.darkGray),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationProvider>().userModel;

    return Selector<ProfileScreenProvider, String>(
      selector: (_, provider) => provider.uid,
      builder: (context, uid, _) {
        if (uid.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return StreamBuilder<DocumentSnapshot>(
          stream: context.read<AuthenticationProvider>().usersStream(uid: uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data?.data() == null) {
              return Center(
                child: Text(
                  'No user data found',
                  style: CTypography.body1.copyWith(color: CColors.darkGray),
                ),
              );
            }

            final userModel = UserModel.fromMap(
              snapshot.data!.data() as Map<String, dynamic>,
            );

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    color: CColors.lightPink,
                    offset: const Offset(0, 5),
                  ),
                ],
                gradient: _gradient(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: CAvatar(
                        imageUrl: userModel.image,
                        size: CAvatarSize.large,
                        showBorder: true,
                      ),
                      onTap: () {
                        // navigate to user profile with args
                      },
                    ),
                    ConstSpacer.width16(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstSpacer.height8(),
                        Text(
                          userModel.name,
                          style: CTypography.title.copyWith(
                            color: CColors.extraLight,
                          ),
                        ),
                        Text(
                          userModel.aboutMe,
                          style: CTypography.body1.copyWith(
                            color: CColors.extraLight,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if ((currentUser?.uid ?? '') == userModel.uid)
                      IconButton(
                        onPressed: () =>
                            debugPrint('User UID: ${userModel.uid}'),
                        icon: const Icon(Icons.edit, color: CColors.extraLight),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  LinearGradient _gradient() {
    return LinearGradient(
      colors: [
        CColors.hotPink.withAlpha(80),
        CColors.pinkOrange.withAlpha(30),
        CColors.salmonPink.withAlpha(80),
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }
}

class ActionList extends StatelessWidget {
  final UserModel userModel;
  const ActionList({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationProvider>().userModel;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(blurRadius: 4, color: CColors.darkGray.withAlpha(40)),
        ],
        color: CColors.pureWhite,
      ),
      child: Column(
        children: [
          if (currentUser?.uid == userModel.uid) ...[
            if ((userModel.friendRequestsUIDs.isNotEmpty))
              CListItem(
                leading: const GradientIcon(icon: Icons.view_module_sharp),
                title: 'View Friend Requests',
                subtitle:
                    'Check new requests from people who’d like to connect',
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: CColors.grayBlue,
                ),
                onTap: () {
                  //Navigate to friend requests screen.
                },
              ),
          ] else ...[
            SizedBox(),
          ],
        ],
      ),
    );
  }
}

class GradientIcon extends StatelessWidget {
  final IconData icon;
  const GradientIcon({required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: CColors.lightPink,
            offset: const Offset(0, 5),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            CColors.hotPink.withAlpha(80),
            CColors.pinkOrange.withAlpha(30),
            CColors.salmonPink.withAlpha(80),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Center(child: Icon(icon, size: 28, color: CColors.pureWhite)),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: LargeButton(
              prefixIcon: Icons.logout,
              iconColor: CColors.hotPink,
              buttonColor: CColors.lightPink,
              onPressed: () {},
              text: 'Log Out',
              textColor: CColors.pinkOrange,
              shadow: BoxShadow(
                blurRadius: 6,
                color: CColors.lightPink,
                offset: Offset(0, 5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreenArguments {
  String uid;
  ProfileScreenArguments({required this.uid});
}
