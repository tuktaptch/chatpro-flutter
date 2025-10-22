// import 'package:chat_pro/widgets/avartar/user_image_avertar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class GroupChatAppBar extends StatefulWidget {
//   const GroupChatAppBar({super.key, required this.groupId});

//   final String groupId;

//   @override
//   State<GroupChatAppBar> createState() => _GroupChatAppBarState();
// }

// class _GroupChatAppBarState extends State<GroupChatAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: context.read<GroupProvider>().groupStream(
//         groupId: widget.groupId,
//       ),
//       builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return const Center(child: Text('Something went wrong'));
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final groupModel = GroupModel.fromMap(
//           snapshot.data!.data() as Map<String, dynamic>,
//         );

//         return GestureDetector(
//           onTap: () {
//             // navigate to group information screen
//             // context.read<GroupProvider>().updateGroupMembersList().whenComplete(
//             //   () {
//             //     Navigator.pushNamed(context, Constants.groupInformationScreen);
//             //   },
//             // );
//           },
//           child: Row(
//             children: [
//               GestureDetector(
//                 child: CAvatar(
//                   imageUrl: groupModel.groupImage,
//                   size: CAvatarSize.large,
//                   showBorder: true,
//                 ),
//                 onTap: () {
//                   // navigate to group settings screen
//                 },
//               ),

//               const SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(groupModel.groupName),
//                   GroupMembers(membersUIDs: groupModel.membersUIDs),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
