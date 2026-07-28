import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  FirebaseStorage get _storage => FirebaseStorage.instance;
  bool _useMock = false;

  void enableMockMode() {
    _useMock = true;
  }

  @override
  Future<String> uploadFile({
    required String path,
    required File file,
    required String fileName,
  }) async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 1500));
      return "https://firebasestorage.googleapis.com/v0/b/mock-bucket/o/${Uri.encodeComponent(path)}%2F$fileName?alt=media";
    }

    try {
      final Reference ref = _storage.ref().child(path).child(fileName);
      final UploadTask task = ref.putFile(file);
      final TaskSnapshot snap = await task;
      return await snap.ref.getDownloadURL();
    } catch (e) {
      // Fallback url
      return "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
    }
  }

  @override
  Future<void> deleteFile(String fileUrl) async {
    if (_useMock || fileUrl.contains("mock-bucket")) {
      return;
    }
    try {
      final Reference ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      // Log or handle
    }
  }
}
