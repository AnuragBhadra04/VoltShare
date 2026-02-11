import '../models/ev_model.dart';

class EVService {
  // Pretend this comes from backend
  static Future<List<EVModel>> fetchAllEVs() async {
    return [
      EVModel(
        id: '1',
        name: 'Tata Nexon EV',
        latitude: 12.9716,
        longitude: 77.5946,
        pricePerHour: 250,
        isAvailable: true,
      ),
      EVModel(
        id: '2',
        name: 'MG ZS EV',
        latitude: 13.0358,
        longitude: 77.5970,
        pricePerHour: 300,
        isAvailable: false,
      ),
      EVModel(
        id: '3',
        name: 'Ather 450X',
        latitude: 12.9352,
        longitude: 77.6245,
        pricePerHour: 120,
        isAvailable: true,
      ),
    ];
  }
}
