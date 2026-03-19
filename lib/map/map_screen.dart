import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'map_service.dart';
import 'map_marker_helper.dart';
import 'navigation_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? userLocation;

  final MapController mapController = MapController();

  final MapService mapService = MapService();
  final NavigationService navigationService = NavigationService();

  List<Marker> markers = [];
  List<LatLng> routePoints = [];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  /// ================================
  /// INITIALIZE MAP
  /// ================================
  Future<void> _initializeMap() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    LatLng location = LatLng(position.latitude, position.longitude);

    setState(() {
      userLocation = location;

      markers.add(MapMarkerHelper.userMarker(location));
    });

    await loadMapData();
  }

  /// ================================
  /// LOAD EV + CHARGER DATA
  /// ================================
  Future<void> loadMapData() async {
    final evs = await mapService.fetchEVs();
    final chargers = await mapService.fetchChargers();

    List<Marker> newMarkers = [];

    /// EV MARKERS
    for (var ev in evs) {
      final lat = ev['latitude'];
      final lng = ev['longitude'];

      if (lat != null && lng != null) {
        LatLng position = LatLng(lat.toDouble(), lng.toDouble());

        newMarkers.add(
          Marker(
            point: position,
            width: 50,
            height: 50,
            child: GestureDetector(
              onTap: () {
                drawRoute(position);
              },
              child: const Icon(
                Icons.electric_scooter,
                color: Colors.green,
                size: 35,
              ),
            ),
          ),
        );
      }
    }

    /// CHARGER MARKERS
    for (var charger in chargers) {
      final lat = charger['latitude'];
      final lng = charger['longitude'];

      if (lat != null && lng != null) {
        LatLng position = LatLng(lat.toDouble(), lng.toDouble());

        newMarkers.add(
          Marker(
            point: position,
            width: 50,
            height: 50,
            child: GestureDetector(
              onTap: () {
                drawRoute(position);
              },
              child: const Icon(
                Icons.ev_station,
                color: Colors.orange,
                size: 35,
              ),
            ),
          ),
        );
      }
    }

    setState(() {
      markers.addAll(newMarkers);
    });
  }

  /// ================================
  /// DRAW ROUTE
  /// ================================
  Future<void> drawRoute(LatLng destination) async {
    if (userLocation == null) return;

    final route = await navigationService.getRoute(userLocation!, destination);

    setState(() {
      routePoints = route;
    });
  }

  /// ================================
  /// UI
  /// ================================
  @override
  Widget build(BuildContext context) {
    if (userLocation == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("VoltShare Map")),

      body: FlutterMap(
        mapController: mapController,

        options: MapOptions(initialCenter: userLocation!, initialZoom: 15),

        children: [
          /// OPEN STREET MAP TILES
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "com.voltshare.app",
          ),

          /// ROUTE POLYLINE
          PolylineLayer(
            polylines: [
              Polyline(points: routePoints, strokeWidth: 5, color: Colors.blue),
            ],
          ),

          /// MARKERS
          MarkerLayer(markers: markers),
        ],
      ),

      /// CENTER USER LOCATION
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapController.move(userLocation!, 16);
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
