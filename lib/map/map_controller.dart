import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'map_service.dart';
import 'navigation_service.dart';
import 'map_marker_helper.dart';

class MapControllerManager {
  final MapService mapService = MapService();
  final NavigationService navigationService = NavigationService();

  List<Marker> markers = [];
  List<LatLng> routePoints = [];

  Future<void> loadMarkers() async {
    final evs = await mapService.fetchEVs();
    final chargers = await mapService.fetchChargers();

    for (var ev in evs) {
      final lat = ev['latitude'];
      final lng = ev['longitude'];

      if (lat != null && lng != null) {
        markers.add(
          MapMarkerHelper.evMarker(LatLng(lat.toDouble(), lng.toDouble())),
        );
      }
    }

    for (var charger in chargers) {
      final lat = charger['latitude'];
      final lng = charger['longitude'];

      if (lat != null && lng != null) {
        markers.add(
          MapMarkerHelper.chargerMarker(LatLng(lat.toDouble(), lng.toDouble())),
        );
      }
    }
  }

  Future<void> buildRoute(LatLng start, LatLng end) async {
    routePoints = await navigationService.getRoute(start, end);
  }
}
