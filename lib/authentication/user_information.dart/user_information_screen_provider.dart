import 'dart:io';

import 'package:chat_pro/main_screen/home_screen/home_screen.dart';
import 'package:chat_pro/models/user_model.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/utilities/attachment_picker/attachment_picker.dart';
import 'package:chat_pro/utilities/global_method.dart';
import 'package:chat_pro/widgets/attachment_picker_bottom_sheet/attachment_picker_bottom_sheet.dart';
import 'package:chat_pro/widgets/crop_image_view/crop_image_view.dart';
import 'package:chat_pro/widgets/crop_image_view/crop_image_view_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class UserInformationScreenProvider with ChangeNotifier {
  final AuthenticationProvider _authProvider;
  UserInformationScreenProvider(this._authProvider);
  // Add your state variables and methods here
  final CropImageViewController cropImageController = CropImageViewController();
  final TextEditingController nameController = TextEditingController();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  File? finalFileImage;
  List<File>? selectedFiles;
  bool isOnClickContinue = false;

  Future<void> pickFiles(BuildContext context) async {
    final result = await pickAttachment(
      context: context,
      allowedExtensions: ['jpg', 'png'],
      allowedSources: [AttachmentSource.camera, AttachmentSource.gallery],
    );

    if (result != null && result.isNotEmpty) {
      // ได้ภาพมาแล้ว
      final originalFile = result.first;
      // print('originalFile file: ${originalFile.path}');

      // เปิดหน้า CropImageView เพื่อครอป
      if (!context.mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CropImageView(
            originalFile: originalFile,
            controller: cropImageController,
          ),
        ),
      );
      final croppedFile = cropImageController.croppedFile;
      // ถ้ามีการครอปสำเร็จ
      if (croppedFile != null) {
        selectedFiles = [croppedFile];
        finalFileImage = croppedFile;
        notifyListeners();
      }
    } else {
      if (!context.mounted) return;
      showSnackBar(context, 'No Selected Image', Type.warning);
    }
  }

  void onClickContinue(BuildContext context) async {
    // set isOnClickContinue to true
    isOnClickContinue = true;
    if (isErrortext) {
      if (!context.mounted) return;
      showSnackBar(context, 'Please enter your name', Type.failed);
      btnController.reset();
    } else {
      // save user info to firebase
      await saveUserDateToFireStore(context);
    }
    notifyListeners();
  }

  bool get isErrortext {
    return nameController.text.isEmpty && isOnClickContinue;
  }

  //save user info to firebase
  Future<void> saveUserDateToFireStore(BuildContext context) async {
    UserModel userModel = UserModel(
      uid: _authProvider.uid ?? '',
      name: nameController.text.trim(),
      phoneNumber: _authProvider.phoneNumber ?? '',
      aboutMe: 'Hello, I am using Chat Pro',
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      image: '',
      token: '',
      lastSeen: '',
      isOnline: true,
      friendsUIDs: [],
      friendRequestsUIDs: [],
      sentFriendRequestsUIDs: [],
    );
    await _authProvider.saveUserDataToFirebase(
      userModel: userModel,
      fileImage: finalFileImage,
      onSuccess: () async {
        btnController.success();
        //save user data to shared preferences
        await _authProvider.saveUserDataToSharedPreference();
        // await Future.delayed(const Duration(seconds: 1), () {
        //   btnController.reset();
        // });

        if (!context.mounted) return;
        navigatorToHomeScreen(context);
      },
      onFail: () async {
        btnController.error();
        if (!context.mounted) return;
        showSnackBar(context, 'Failed to save user data', Type.failed);
        await Future.delayed(const Duration(seconds: 1), () {
          btnController.reset();
        });
      },
    );
    // if (!context.mounted) return;
    // showSnackBar(context, 'User info saved successfully!', Type.success);
  }

  void navigatorToHomeScreen(BuildContext context) {
    // Navigate to HomeScreen and remove all previous routes.
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
  }
}
