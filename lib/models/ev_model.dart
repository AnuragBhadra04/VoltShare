class EVModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double pricePerHour;
  final bool isAvailable;

  final String vehicleType; // ✅ ADD THIS

  final String? providerId;
  final DateTime? createdAt;

  const EVModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.pricePerHour,
    required this.isAvailable,
    required this.vehicleType, // ✅ REQUIRED
    this.providerId,
    this.createdAt,
  });

  factory EVModel.fromJson(Map<String, dynamic> json) {
    return EVModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      pricePerHour: (json['price_per_hour'] ?? 0).toDouble(),
      isAvailable: json['is_available'] ?? true,

      vehicleType: json['vehicle_type'] ?? '2_wheeler', // 🔥 IMPORTANT

      providerId: json['provider_id'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'price_per_hour': pricePerHour,
      'is_available': isAvailable,

      'vehicle_type': vehicleType, // ✅ ADD THIS

      'provider_id': providerId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  EVModel copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    double? pricePerHour,
    bool? isAvailable,
    String? vehicleType, // ✅ ADD
    String? providerId,
    DateTime? createdAt,
  }) {
    return EVModel(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      isAvailable: isAvailable ?? this.isAvailable,
      vehicleType: vehicleType ?? this.vehicleType, // ✅ ADD
      providerId: providerId ?? this.providerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
