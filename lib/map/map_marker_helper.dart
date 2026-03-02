import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/ev_model.dart';
import '../models/charger_model.dart';

class MapMarkerHelper {
  // ===============================
  // USER MARKER
  // ===============================
  static Marker createUserMarker({
    required double latitude,
    required double longitude,
  }) {
    return Marker(
      markerId: const MarkerId("user_location"),

      position: LatLng(latitude, longitude),

      infoWindow: const InfoWindow(title: "You are here"),

      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );
  }

  // ===============================
  // EV MARKERS
  // ===============================
  static Set<Marker> createEVMarkers(
    List<EVModel> evs, {
    Function(EVModel)? onTap,
  }) {
    return evs.map((ev) {
      return Marker(
        markerId: MarkerId("ev_${ev.id}"),

        position: LatLng(ev.latitude, ev.longitude),

        infoWindow: InfoWindow(
          title: ev.name,
          snippet: "₹${ev.pricePerHour} / hour",
        ),

        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),

        onTap: () {
          if (onTap != null) {
            onTap(ev);
          }
        },
      );
    }).toSet();
  }

  // ===============================
  // CHARGER MARKERS
  // ===============================
  static Set<Marker> createChargerMarkers(
    List<ChargerModel> chargers, {
    Function(ChargerModel)? onTap,
  }) {
    return chargers.map((charger) {
      return Marker(
        markerId: MarkerId("charger_${charger.id}"),

        position: LatLng(charger.latitude, charger.longitude),

        infoWindow: InfoWindow(
          title: "${charger.brand} ${charger.model}",
          snippet: "₹${charger.pricePerUnit} / unit",
        ),

        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),

        onTap: () {
          if (onTap != null) {
            onTap(charger);
          }
        },
      );
    }).toSet();
  }

  // ===============================
  // MERGE ALL MARKERS
  // ===============================
  static Set<Marker> mergeMarkers({
    required Marker userMarker,
    required Set<Marker> evMarkers,
    required Set<Marker> chargerMarkers,
  }) {
    return {userMarker, ...evMarkers, ...chargerMarkers};
  }
}
