import '../models/charger_model.dart';

class ChargerService {
  static Future<List<ChargerModel>> fetchAllChargers() async {
    return [
      ChargerModel(
        id: '1',
        brand: 'Tata Power',
        model: 'Fast DC 50kW',
        latitude: 12.9716,
        longitude: 77.5946,
        isAvailable: true,
        pricePerUnit: 18,
      ),
      ChargerModel(
        id: '2',
        brand: 'Ather Grid',
        model: 'AC Wall Charger',
        latitude: 12.9352,
        longitude: 77.6245,
        isAvailable: true,
        pricePerUnit: 15,
      ),
      ChargerModel(
        id: '3',
        brand: 'ChargeZone',
        model: 'Ultra Fast',
        latitude: 13.0358,
        longitude: 77.5970,
        isAvailable: false,
        pricePerUnit: 20,
      ),
    ];
  }
}
