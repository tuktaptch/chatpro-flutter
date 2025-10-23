import 'dart:io';

import 'package:chat_pro/ui/home_screen/home_screen.dart';
import 'package:chat_pro/models/user_model.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/utilities/attachment_picker/attachment_picker.dart';
import 'package:chat_pro/utilities/global_method.dart';
import 'package:chat_pro/widgets/attachment_picker_bottom_sheet/attachment_picker_bottom_sheet.dart';
import 'package:chat_pro/widgets/crop_image_view/crop_image_view.dart';
import 'package:chat_pro/widgets/crop_image_view/crop_image_view_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:rounded_loading_button/rounded_loading_button.dart';

class UserInformationScreenProvider with ChangeNotifier {
  final AuthenticationProvider _authProvider;
  UserInformationScreenProvider(this._authProvider);

  final CropImageViewController cropImageController = CropImageViewController();
  final TextEditingController nameController = TextEditingController();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  File? finalFileImage;
  List<File>? selectedFiles;
  bool isOnClickContinue = false;

  /// เลือกและ crop รูปภาพ
  Future<void> pickFiles(BuildContext context) async {
    final result = await pickAttachment(
      context: context,
      allowedExtensions: ['jpg', 'png'],
      allowedSources: [AttachmentSource.camera, AttachmentSource.gallery],
    );

    if (result != null && result.isNotEmpty) {
      final originalFile = result.first;

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
      if (croppedFile != null) {
        // บีบอัดรูปก่อนเก็บและอัปโหลด
        final compressedFile = await compressImage(croppedFile);

        selectedFiles = [compressedFile];
        finalFileImage = compressedFile;
        notifyListeners();
      }
    } else {
      if (!context.mounted) return;
      showSnackBar(context, 'No Selected Image', Type.warning);
    }
  }

  /// บีบอัดไฟล์รูป
  Future<File> compressImage(File file) async {
    final imageBytes = await file.readAsBytes();
    final image = img.decodeImage(imageBytes);
    if (image == null) return file;

    final compressedBytes = img.encodeJpg(image, quality: 70);
    final compressedFile = File(file.path)..writeAsBytesSync(compressedBytes);
    return compressedFile;
  }

  void onClickContinue(BuildContext context) async {
    isOnClickContinue = true;

    if (isErrortext) {
      if (!context.mounted) return;
      showSnackBar(context, 'Please enter your name', Type.failed);
      btnController.reset();
    } else {
      await saveUserDateToFireStore(context);
    }
    notifyListeners();
  }

  bool get isErrortext {
    return nameController.text.isEmpty && isOnClickContinue;
  }

  /// บันทึกข้อมูลผู้ใช้ไป Firestore
  Future<void> saveUserDateToFireStore(BuildContext context) async {
    UserModel userModel = UserModel(
      uid: _authProvider.uid ?? '',
      name: nameController.text.trim(),
      phoneNumber: _authProvider.phoneNumber ?? '',
      aboutMe: 'Hey there, I\'m using Flutter Chat Pro',
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      image: '',
      token: '',
      lastSeen: '',
      isOnline: true,
      friendsUIDs: [],
      friendRequestsUIDs: [],
      sentFriendRequestsUIDs: [],
    );

    _authProvider.saveUserDataToFireStore(
      userModel: userModel,
      fileImage: finalFileImage,
      onSuccess: () async {
        btnController.success();
        await _authProvider.saveUserDataToSharedPreference();
        if (!context.mounted) return;
        navigatorToHomeScreen(context);
      },
      onFail: (String message) async {
        if (!context.mounted) return;
        btnController.error();
        showSnackBar(context, message, Type.failed);
        await Future.delayed(const Duration(seconds: 1), () {
          btnController.reset();
        });
      },
    );
  }

  void navigatorToHomeScreen(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
  }
}
