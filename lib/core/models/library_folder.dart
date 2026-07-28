class LibraryFolder {
  final String id;
  final String name;
  final int colorValue; // Hex color value
  final int iconCodePoint; // Icon code point
  final String? parentFolderId; // Null if root level folder
  final String userClass;
  final String subject;

  LibraryFolder({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.iconCodePoint,
    this.parentFolderId,
    required this.userClass,
    required this.subject,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'colorValue': colorValue,
      'iconCodePoint': iconCodePoint,
      'parentFolderId': parentFolderId,
      'class': userClass,
      'subject': subject,
    };
  }

  factory LibraryFolder.fromMap(Map<String, dynamic> map) {
    return LibraryFolder(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      colorValue: map['colorValue'] ?? 0xFF1E3C72,
      iconCodePoint: map['iconCodePoint'] ?? 0xe241, // default folder icon
      parentFolderId: map['parentFolderId'],
      userClass: map['class'] ?? '',
      subject: map['subject'] ?? '',
    );
  }

  LibraryFolder copyWith({
    String? name,
    int? colorValue,
    int? iconCodePoint,
    String? parentFolderId,
  }) {
    return LibraryFolder(
      id: id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      parentFolderId: parentFolderId ?? this.parentFolderId,
      userClass: userClass,
      subject: subject,
    );
  }
}
