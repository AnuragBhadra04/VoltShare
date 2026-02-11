class ChargerModel {
  final String id;
  final String brand;
  final String model;
  final double latitude;
  final double longitude;
  final bool isAvailable;
  final double pricePerUnit;

  ChargerModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.latitude,
    required this.longitude,
    required this.isAvailable,
    required this.pricePerUnit,
  });
}
