class ProviderService {
  static final List<Map<String, dynamic>> chargers = [];
  static final List<Map<String, dynamic>> evs = [];

  static Future<void> addCharger({
    required String brand,
    required String model,
    required double pricePerUnit,
    required double latitude,
    required double longitude,
  }) async {
    chargers.add({
      'brand': brand,
      'model': model,
      'pricePerUnit': pricePerUnit,
      'latitude': latitude,
      'longitude': longitude,
      'available': true,
    });
  }

  static Future<void> addEV({
    required String brand,
    required String model,
    required double pricePerHour,
    required int rangeKm,
    required double latitude,
    required double longitude,
  }) async {
    evs.add({
      'brand': brand,
      'model': model,
      'pricePerHour': pricePerHour,
      'rangeKm': rangeKm,
      'latitude': latitude,
      'longitude': longitude,
      'available': true,
    });
  }
}
