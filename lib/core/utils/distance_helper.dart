import 'package:geolocator/geolocator.dart';

class DistanceHelper {
  static double kmBetween(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }
}
