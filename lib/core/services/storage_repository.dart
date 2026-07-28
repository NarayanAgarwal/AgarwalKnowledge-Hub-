import 'dart:io';

abstract class StorageRepository {
  Future<String> uploadFile({
    required String path,
    required File file,
    required String fileName,
  });
  Future<void> deleteFile(String fileUrl);
}
