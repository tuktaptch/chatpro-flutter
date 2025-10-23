import 'dart:io';

import 'package:chat_pro/utilities/alert/alert.dart';
import 'package:chat_pro/utilities/alert/toast_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseStorageUtil {
  /// Uploads a file to Firebase Storage and returns the download URL.
  static Future<String> storeFileToStorage({
    required File file,
    required String reference,
  }) async {
    try {
      if (!file.existsSync()) throw 'File Not Found';

      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(reference)
          .putFile(file);

      TaskSnapshot taskSnapshot = await uploadTask;
      String fileUrl = await taskSnapshot.ref.getDownloadURL();

      return fileUrl;
    } catch (e) {
      debugPrint('Firebase Storage upload error: $e');

      Alert.show(
        'Failed to upload file: ${e.toString().split('\n').first}',
        type: ToastType.failed,
        isMultiple: true,
      );
      return '';
    }
  }
}
