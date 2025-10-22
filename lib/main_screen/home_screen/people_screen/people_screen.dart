import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/constraints/constants.dart';
import 'package:chat_pro/main_screen/home_screen/people_screen/people_screen_provider.dart';
import 'package:chat_pro/main_screen/profile_screen/profile_screen.dart';
import 'package:chat_pro/utilities/assets_manager.dart';
import 'package:chat_pro/widgets/avartar/user_image_avertar.dart';
import 'package:chat_pro/widgets/no_data_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PeopleScreen extends StatefulWidget {
  static const routeName = '/main/home/people';
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PeopleScreenProvider>();

    return SafeArea(
      top: false,
      child: StreamBuilder<QuerySnapshot>(
        stream: provider.allUsersStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return _PeopleShimmerLoading();
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: const NoDataContainer(),
            );
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: docs.map((doc) {
              final data = provider.parseUserData(doc);
              if (data.isEmpty) return const SizedBox.shrink();

              return ListTile(
                leading: GestureDetector(
                  child: CAvatar(
                    imageUrl: data[Constants.image] ?? AssetsManager.userImage,
                    size: CAvatarSize.large,
                    showBorder: true,
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    ProfileScreen.routeName,
                    arguments: ProfileScreenArguments(uid: doc.id),
                  ),
                ),
                title: Text(
                  data[Constants.name] ?? 'No name',
                  style: CTypography.body1.copyWith(color: CColors.darkGray),
                ),
                subtitle: Text(
                  data[Constants.aboutMe] ?? 'No information',
                  style: CTypography.caption1.copyWith(color: CColors.grayBlue),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _PeopleShimmerLoading extends StatelessWidget {
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
                width: MediaQuery.of(context).size.width * 0.3,
                height: 30,
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
