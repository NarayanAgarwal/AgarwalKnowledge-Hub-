import 'dart:io';

abstract class StorageRepository {
  Future<String> uploadFile({
    required String path,
    required File file,
    required String fileName,
  });

  Future<String> uploadFileBytes({
    required String path,
    required List<int> bytes,
    required String fileName,
    required String mimeType,
  });

  Future<void> deleteFile(String fileUrl);
}
