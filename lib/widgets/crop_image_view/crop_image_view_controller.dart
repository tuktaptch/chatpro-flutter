import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:path_provider/path_provider.dart';

class CropImageViewController {
  final CropController _cropController = CropController();
  File? croppedFile;

  CropController get cropController => _cropController;

  /// สร้างไฟล์จาก Uint8List
  Future<File?> crop(Uint8List imageData) async {
    final tempDir = await getTemporaryDirectory();
    final file = File(
      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(imageData);
    croppedFile = file;
    //print('croppedFile Success: imageData length = $croppedFile');
    return croppedFile;
  }
}
