import 'dart:io';

import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/utilities/assets_manager.dart';
import 'package:flutter/material.dart';

class UserAvatarWithCamera extends StatelessWidget {
  final File? imageFile;
  final VoidCallback? onCameraTap;
  final double avatarRadius;
  final double cameraRadius;

  const UserAvatarWithCamera({
    super.key,
    required this.imageFile,
    this.onCameraTap,
    this.avatarRadius = 50,
    this.cameraRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: avatarRadius * 2,
      height: avatarRadius * 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundImage: imageFile != null
                ? FileImage((imageFile!))
                : AssetImage(AssetsManager.userImage),
          ),
          Positioned(
            bottom: -cameraRadius / 2, // ยื่นออกนิดหน่อย
            right: -cameraRadius / 2,
            child: GestureDetector(
              onTap: onCameraTap,
              child: CircleAvatar(
                radius: cameraRadius,
                backgroundColor: CColors.green,
                child: Icon(
                  Icons.camera_alt,
                  color: CColors.pureWhite,
                  size: cameraRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
