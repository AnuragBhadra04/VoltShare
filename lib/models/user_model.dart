class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? photoUrl;
  final String? role;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.photoUrl,
    this.role,
    required this.createdAt,
  });

  /// FROM SUPABASE JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      photoUrl: json['photo_url'],
      role: json['role'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// TO SUPABASE JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'photo_url': photoUrl,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// COPY WITH (useful for profile updates)
  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? photoUrl,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, phone: $phone, role: $role)';
  }
}
