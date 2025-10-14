import 'dart:io';
import 'package:chat_pro/utilities/permission/permission.dart';
import 'package:chat_pro/widgets/attachment_picker_bottom_sheet/attachment_picker_bottom_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<List<File>?> pickAttachment({
  /// Context for showing bottom sheet
  required BuildContext context,

  /// Allow picking multiple files (only for gallery and file)
  bool allowMultiple = false,

  /// Allowed file extensions (only for file)
  List<String>? allowedExtensions,

  /// Allowed attachment sources, default to all sources
  List<AttachmentSource>? allowedSources,
}) async {
  final sources = allowedSources ?? AttachmentSource.values;

  AttachmentSource? source;
  if (sources.length == 1) {
    source = sources.first;
  } else {
    source = await showAttachmentPickerBottomSheet(
      context: context,
      allowedSources: sources,
    );
  }

  if (source == null) return null;

  final picker = ImagePicker();
  List<File> files = [];

  switch (source) {
    case AttachmentSource.camera:
      final granted = await CPermission.checkCameraPermission();
      if (!granted) return null;
      // Camera only supports single file
      final XFile? cameraFile = await picker.pickImage(
        source: ImageSource.camera,
      );
      if (cameraFile != null) files.add(File(cameraFile.path));
      break;

    case AttachmentSource.gallery:
      final granted = await CPermission.checkStoragePermission();
      if (!granted) return null;
      if (allowMultiple) {
        final List<XFile>? galleryFiles = await picker.pickMultiImage();
        if (galleryFiles != null) {
          files.addAll(galleryFiles.map((e) => File(e.path)));
        }
      } else {
        final XFile? galleryFile = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (galleryFile != null) files.add(File(galleryFile.path));
      }
      break;

    case AttachmentSource.file:
      final granted = await CPermission.checkStoragePermission();
      if (!granted) return null;
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultiple,
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
      );
      if (result != null) files.addAll(result.files.map((e) => File(e.path!)));
      break;
  }

  return files.isNotEmpty ? files : null;
}
