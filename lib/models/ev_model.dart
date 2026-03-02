class EVModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double pricePerHour;
  final bool isAvailable;
  final String? providerId;
  final DateTime? createdAt;

  EVModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.pricePerHour,
    required this.isAvailable,
    this.providerId,
    this.createdAt,
  });

  // ✅ Supabase JSON → Model
  factory EVModel.fromJson(Map<String, dynamic> json) {
    return EVModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      pricePerHour: (json['price_per_hour'] ?? 0).toDouble(),
      isAvailable: json['is_available'] ?? true,
      providerId: json['provider_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  // ✅ Model → Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'price_per_hour': pricePerHour,
      'is_available': isAvailable,
      'provider_id': providerId,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
