class EVModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double pricePerHour;
  final bool isAvailable;

  EVModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.pricePerHour,
    required this.isAvailable,
  });
}
