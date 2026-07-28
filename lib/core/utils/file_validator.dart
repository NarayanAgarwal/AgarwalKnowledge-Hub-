class FileValidator {
  // Allowed file extensions for administrative & homework uploads
  static const List<String> allowedExtensions = [
    'pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx', 'ppt', 'pptx', 'zip', 'mp3', 'mp4'
  ];

  // Maximum allowed file size in bytes (15 Megabytes)
  static const int maxFileSizeBytes = 15 * 1024 * 1024;

  static bool validateUpload(String fileName, int fileSizeBytes) {
    // 1. Enforce file size limit check
    if (fileSizeBytes > maxFileSizeBytes) {
      throw Exception('Security violation: File size exceeds the 15MB maximum limit.');
    }

    // 2. Enforce file type extension check
    final String extension = fileName.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      throw Exception('Security violation: The file extension ".$extension" is not supported.');
    }

    return true;
  }
}
