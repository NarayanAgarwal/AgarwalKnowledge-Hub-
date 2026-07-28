class Institute {
  final String id;
  final String name;
  final String logoUrl;
  final String primaryColorHex;
  final String secondaryColorHex;
  final String contactEmail;
  final String contactPhone;
  final Map<String, bool> featureFlags;
  final String status; // 'Active' | 'Suspended'

  Institute({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.primaryColorHex,
    required this.secondaryColorHex,
    required this.contactEmail,
    required this.contactPhone,
    required this.featureFlags,
    this.status = 'Active',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'primaryColorHex': primaryColorHex,
      'secondaryColorHex': secondaryColorHex,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'featureFlags': featureFlags,
      'status': status,
    };
  }

  factory Institute.fromMap(Map<String, dynamic> map) {
    return Institute(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      primaryColorHex: map['primaryColorHex'] ?? '1E3C72',
      secondaryColorHex: map['secondaryColorHex'] ?? 'FF5E36',
      contactEmail: map['contactEmail'] ?? '',
      contactPhone: map['contactPhone'] ?? '',
      featureFlags: Map<String, bool>.from(map['featureFlags'] ?? {}),
      status: map['status'] ?? 'Active',
    );
  }

  Institute copyWith({
    String? name,
    String? logoUrl,
    String? primaryColorHex,
    String? secondaryColorHex,
    Map<String, bool>? featureFlags,
    String? status,
  }) {
    return Institute(
      id: id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      secondaryColorHex: secondaryColorHex ?? this.secondaryColorHex,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      featureFlags: featureFlags ?? this.featureFlags,
      status: status ?? this.status,
    );
  }
}
