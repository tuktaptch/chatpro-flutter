import 'dart:io';

import 'package:chat_pro/authentication/user_information.dart/user_information_screen_provider.dart';
import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_shadow.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/constraints/spacing.dart';
import 'package:chat_pro/widgets/c_app_bar.dart';
import 'package:chat_pro/widgets/c_text_field.dart';
import 'package:chat_pro/widgets/avartar/user_avartar_with_camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class UserInformationScreen extends StatefulWidget {
  static const String routeName = '/authentication/user_information';
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final double avatarRadius = 50; // รัศมีของ UserAvatar

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double avatarTop = size.height * 0.13; // top ของ Avatar
    final double containerTop =
        avatarTop + avatarRadius; // Container เริ่มหลัง Avatar
    final provider = context.read<UserInformationScreenProvider>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CAppBar(
        title: 'User Information',
        iconColor: CColors.vividPink,
        textColor: CColors.vividPink,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            // 🌈 Background Gradient
            SizedBox(
              height: size.height,
              width: double.infinity,
              child: const LinearGradientBackground(),
            ),

            // Container สีพื้นหลังขาว มุมบนโค้ง
            Positioned(
              top: containerTop,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: CColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: CShadow.defaultShadow,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: avatarRadius + 24,
                    left: 16,
                    right: 16,
                  ), // เว้นระยะด้านบน
                  child: Column(
                    children: [
                      Selector<UserInformationScreenProvider, bool>(
                        selector: (_, provider) => provider.isErrortext,
                        builder: (context, isError, child) {
                          final provider = context
                              .read<UserInformationScreenProvider>();
                          return CTextField(
                            labelText: 'Name',
                            errorText: isError ? '' : null,
                            isRequired: true,
                            placeHolderText: 'Enter your name',
                            controller: provider.nameController,
                          );
                        },
                      ),
                      ConstSpacer.height24(),
                      RoundedLoadingButton(
                        controller: provider.btnController,
                        onPressed: () => provider.onClickContinue(context),
                        color: CColors.hotPink,
                        successColor: CColors.orange,
                        width: 200,
                        borderRadius: 30,
                        child: Text(
                          'Continue',
                          style: CTypography.title.copyWith(
                            color: CColors.pureWhite,
                          ),
                        ), // ปุ่มโค้ง
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // User Avatar
            Positioned(
              top: avatarTop,
              left: (size.width / 2) - avatarRadius, // กึ่งกลาง
              child: Selector<UserInformationScreenProvider, File?>(
                selector: (_, provider) => provider.finalFileImage,
                builder: (context, imageFile, child) {
                  return UserAvatarWithCamera(
                    imageFile: imageFile,
                    avatarRadius: avatarRadius,
                    onCameraTap: () async {
                      final provider = context
                          .read<UserInformationScreenProvider>();
                      await provider.pickFiles(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LinearGradientBackground extends StatelessWidget {
  const LinearGradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CColors.hotPink.withAlpha(80),
              CColors.pinkOrange.withAlpha(30),
              CColors.salmonPink.withAlpha(20),
            ],
            stops: const [
              0.0, // เริ่มต้น
              0.2, // ครึ่งทาง
              1.0, // สุดท้าย
            ],
          ),
        ),
      ),
    );
  }
}

class UserInformationArguments {
  final String phoneNumber;
  UserInformationArguments({required this.phoneNumber});
}
