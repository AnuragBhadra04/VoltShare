class ChargerModel {
  final String id;
  final String brand;
  final String model;
  final double latitude;
  final double longitude;
  final bool isAvailable;
  final double pricePerUnit;
  final String? providerId;
  final DateTime? createdAt;

  ChargerModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.latitude,
    required this.longitude,
    required this.isAvailable,
    required this.pricePerUnit,
    this.providerId,
    this.createdAt,
  });

  /// ✅ Supabase JSON → Model
  factory ChargerModel.fromJson(Map<String, dynamic> json) {
    return ChargerModel(
      id: json['id'].toString(),
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      isAvailable: json['is_available'] ?? true,
      pricePerUnit: (json['price_per_unit'] ?? 0).toDouble(),
      providerId: json['provider_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  /// ✅ Model → Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'latitude': latitude,
      'longitude': longitude,
      'is_available': isAvailable,
      'price_per_unit': pricePerUnit,
      'provider_id': providerId,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
