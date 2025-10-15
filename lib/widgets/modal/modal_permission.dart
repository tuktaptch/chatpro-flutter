import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/di/modules/service_locator.dart';
import 'package:chat_pro/di/modules/services/navigation_service.dart';
import 'package:chat_pro/widgets/button/large_button.dart';
import 'package:chat_pro/widgets/modal/modal.dart';
import 'package:flutter/material.dart';

BuildContext _context = getIt<NavigationService>().context!;
Future<bool?> showCameraPermissionModal() => modal<bool>(
  context: _context,
  title: 'Enable Camera Access',
  isCloseBtn: false,
  modalContent: Column(
    children: [
      const Icon(Icons.camera_alt, size: 64, color: CColors.pinkOrange),
      const SizedBox(height: 16),
      DefaultTextStyle(
        style: CTypography.body3.copyWith(color: CColors.grayBlue),
        child: Text(
          'Please allow camera access to take profile photos or scan documents directly in the app.',

          textAlign: TextAlign.center,
        ),
      ),
    ],
  ),
  widgetButton: [
    Expanded(
      child: LargeButton(
        buttonColor: CColors.pinkOrange,
        textColor: CColors.pureWhite,
        text: 'Go to Settings',
        onPressed: () => Navigator.pop(_context, true),
      ),
    ),
  ],
);

Future<bool?> showStoragePermissionModal() => modal<bool>(
  context: _context,
  title: 'Enable Storage Access',
  isCloseBtn: false,
  modalContent: Column(
    children: [
      const Icon(Icons.sd_storage, size: 64, color: CColors.pinkOrange),
      const SizedBox(height: 16),
      DefaultTextStyle(
        style: CTypography.body3.copyWith(color: CColors.grayBlue),
        child: Text(
          'Please allow storage access so the app can upload images and store your data securely.',
          textAlign: TextAlign.center,
        ),
      ),
    ],
  ),
  widgetButton: [
    Expanded(
      child: LargeButton(
        buttonColor: CColors.pinkOrange,
        textColor: CColors.pureWhite,
        text: 'Go to Settings',
        onPressed: () => Navigator.pop(_context, true),
      ),
    ),
  ],
);
