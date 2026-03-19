import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapMarkerHelper {
  /// USER MARKER
  static Marker userMarker(LatLng position) {
    return Marker(
      point: position,
      width: 50,
      height: 50,
      child: const Icon(Icons.my_location, color: Colors.blue, size: 40),
    );
  }

  /// EV MARKER
  static Marker evMarker(LatLng position) {
    return Marker(
      point: position,
      width: 50,
      height: 50,
      child: const Icon(Icons.electric_scooter, color: Colors.green, size: 35),
    );
  }

  /// CHARGER MARKER
  static Marker chargerMarker(LatLng position) {
    return Marker(
      point: position,
      width: 50,
      height: 50,
      child: const Icon(Icons.ev_station, color: Colors.orange, size: 35),
    );
  }
}
