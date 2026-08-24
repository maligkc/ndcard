import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/domain/repositories/storage_repository.dart';

Future<File?> pickAndCropSquareImage() async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 90);
  if (picked == null) return null;
  final cropped = await ImageCropper().cropImage(
    sourcePath: picked.path,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    uiSettings: [
      IOSUiSettings(title: 'Kırp', aspectRatioLockEnabled: true),
      AndroidUiSettings(lockAspectRatio: true),
    ],
  );
  if (cropped == null) return null;
  return File(cropped.path);
}

Future<File?> pickImage() async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 90);
  if (picked == null) return null;
  return File(picked.path);
}

Future<String> uploadCardImage({
  required StorageRepository storage,
  required StorageBucket bucket,
  required String userId,
  required String fileName,
  required File file,
}) {
  return storage.uploadFile(bucket: bucket, userId: userId, file: file, fileName: fileName);
}
