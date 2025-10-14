import 'package:flutter/material.dart';

enum AttachmentSource { camera, gallery, file }

Future<AttachmentSource?> showAttachmentPickerBottomSheet({
  required BuildContext context,
  required List<AttachmentSource> allowedSources,
}) {
  return showModalBottomSheet<AttachmentSource>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (allowedSources.contains(AttachmentSource.camera))
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () => Navigator.pop(context, AttachmentSource.camera),
          ),
        if (allowedSources.contains(AttachmentSource.gallery))
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () => Navigator.pop(context, AttachmentSource.gallery),
          ),
        if (allowedSources.contains(AttachmentSource.file))
          ListTile(
            leading: const Icon(Icons.attach_file),
            title: const Text('File'),
            onTap: () => Navigator.pop(context, AttachmentSource.file),
          ),
        const SizedBox(height: 12),
      ],
    ),
  );
}
