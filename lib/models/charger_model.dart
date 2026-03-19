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

  const ChargerModel({
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
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

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

  ChargerModel copyWith({
    String? id,
    String? brand,
    String? model,
    double? latitude,
    double? longitude,
    bool? isAvailable,
    double? pricePerUnit,
    String? providerId,
    DateTime? createdAt,
  }) {
    return ChargerModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isAvailable: isAvailable ?? this.isAvailable,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      providerId: providerId ?? this.providerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
