import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageUtil {
  /// Uploads a file to Firebase Storage and returns the download URL.
  static Future<String> storeFileToStorage({
    required File file,
    required String reference,
  }) async {
    try {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(reference)
          .putFile(file);

      TaskSnapshot taskSnapshot = await uploadTask;
      String fileUrl = await taskSnapshot.ref.getDownloadURL();

      return fileUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }
}
