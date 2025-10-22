import 'dart:io';

import 'package:chat_pro/widgets/modal/modal_permission.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as appSettings;

class CPermission {
  CPermission._();
  static Future<bool> checkStoragePermission() async {
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;

      if (deviceInfo.version.sdkInt > 32) {
        // SDK 33+ แยก photo/video/audio
        return await _handlePermissions([
          Permission.photos,
          Permission.videos,
          Permission.audio,
        ], showStoragePermissionModal);
      } else {
        // SDK 32 หรือต่ำกว่า
        return await _handlePermissions([
          Permission.storage,
        ], showStoragePermissionModal);
      }
    } else if (Platform.isIOS) {
      // iOS ใช้ permission.photos
      return await _handlePermissions([
        Permission.photos,
      ], showStoragePermissionModal);
    }

    return false;
  }

  static Future<bool> checkCameraPermission() async {
    return await _handlePermissions([
      Permission.camera,
    ], showCameraPermissionModal);
  }

  /// ✅ ฟังก์ชันรวม logic ตรวจ + ขอสิทธิ์ + แสดง modal ของเราเอง
  static Future<bool> _handlePermissions(
    List<Permission> permissions,
    Future<bool?> Function() showModal,
  ) async {
    for (final permission in permissions) {
      final status = await permission.status;

      // ✅ ยังไม่เคยขอ → system modal ของ iOS จะขึ้นครั้งแรก
      if (status.isDenied) {
        final result = await permission.request();

        // ถ้ายังไม่ให้สิทธิ์หลัง system modal
        if (!result.isGranted) {
          final bool? openSettings = await showModal();
          if (openSettings ?? false) await appSettings.openAppSettings();
          return false;
        }
      }
      // ✅ ถ้าเคยปฏิเสธถาวร (Don’t Ask Again)
      else if (status.isPermanentlyDenied) {
        final bool? openSettings = await showModal();
        if (openSettings ?? false) await appSettings.openAppSettings();
        return false;
      }
      // ✅ ถ้าได้รับอนุญาตแล้ว ก็ข้ามได้เลย
      else if (status.isGranted) {
        continue;
      }
    }

    return true;
  }

  static Future<bool> checkMicrophonePermission() async {
    final permission = Permission.microphone;
    final status = await permission.status;

    if (status.isDenied) {
      final result = await permission.request();

      if (!result.isGranted) {
        final bool? openSettings = await showMicroPhonePermissionModal();
        if (openSettings ?? false) await appSettings.openAppSettings();
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      final bool? openSettings = await showMicroPhonePermissionModal();
      if (openSettings ?? false) await appSettings.openAppSettings();
      return false;
    } else if (status.isGranted) {
      return true;
    }

    return true;
  }
}
