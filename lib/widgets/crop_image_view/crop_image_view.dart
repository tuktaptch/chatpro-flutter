import 'dart:io';
import 'dart:typed_data';
import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/utilities/global_method.dart';
import 'package:chat_pro/widgets/button/medium_button.dart';
import 'package:chat_pro/widgets/c_app_bar.dart';
import 'package:chat_pro/widgets/crop_image_view/crop_image_view_controller.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

class CropImageView extends StatefulWidget {
  final File originalFile;
  final CropImageViewController controller;

  const CropImageView({
    super.key,
    required this.originalFile,
    required this.controller,
  });

  @override
  State<CropImageView> createState() => _CropImageViewState();
}

class _CropImageViewState extends State<CropImageView> {
  bool isReady = false; // บอกว่า crop พร้อม
  Uint8List? croppedData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: CAppBar(
        title: 'Crop Image',
        textColor: CColors.pureWhite,
        iconColor: CColors.pureWhite,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Crop(
          baseColor: Colors.black,
          maskColor: Colors.black.withValues(alpha: 0.8),
          aspectRatio: 1,
          withCircleUi: true,
          image: widget.originalFile.readAsBytesSync(),
          controller: widget.controller.cropController,
          onStatusChanged: (status) {
            if (status == CropStatus.ready) {
              setState(() {
                isReady = true;
              });
            }
          },
          onCropped: (CropResult result) async {
            if (result is CropSuccess) {
              // สร้างไฟล์จริง
              await widget.controller.crop(result.croppedImage);
              // ปิดหน้าจอหลัง crop เสร็จ
              if (context.mounted) {
                Navigator.pop(context);
                showSnackBar(
                  context,
                  'Image updated successfully!',
                  Type.success,
                );
              }
            } else if (result is CropFailure) {
              showSnackBar(
                context,
                'Failed to crop the image: ${result.cause}',
                Type.failed,
              );
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: MediumButton(
                onPressed: () {
                  Navigator.pop(context);
                  showSnackBar(context, 'No Selected Image', Type.warning);
                },
                textColor: CColors.pureWhite,
                buttonColor: isReady ? CColors.red : CColors.grayBlue,
                text: 'Cancel',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MediumButton(
                onPressed: () async {
                  // เรียก crop ของ CropController เพื่อ trigger onCropped
                  widget.controller.cropController.crop();
                }, // disable ปุ่มจนกว่าพร้อม
                textColor: CColors.pureWhite,
                buttonColor: isReady ? CColors.green : CColors.grayBlue,
                text: 'Crop',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
