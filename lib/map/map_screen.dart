import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/location_service.dart';
import '../services/api_service.dart';

import '../models/ev_model.dart';
import '../models/charger_model.dart';

import '../core/constants/colors.dart';

import 'map_marker_helper.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  LatLng? _currentPosition;

  Set<Marker> _markers = {};

  bool _loading = true;

  List<EVModel> _evs = [];

  List<ChargerModel> _chargers = [];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      /// GET USER LOCATION
      final location = await LocationService.getCurrentLocation();

      final userLat = location.latitude;
      final userLng = location.longitude;

      _currentPosition = LatLng(userLat, userLng);

      /// FETCH FROM SUPABASE
      _evs = await ApiService.getNearbyEVs(userLat, userLng);

      _chargers = await ApiService.getNearbyChargers(userLat, userLng);

      /// CREATE MARKERS USING HELPER

      final userMarker = MapMarkerHelper.createUserMarker(
        latitude: userLat,
        longitude: userLng,
      );

      final evMarkers = MapMarkerHelper.createEVMarkers(
        _evs,
        onTap: _showEVDetails,
      );

      final chargerMarkers = MapMarkerHelper.createChargerMarkers(
        _chargers,
        onTap: _showChargerDetails,
      );

      /// MERGE ALL MARKERS
      _markers = MapMarkerHelper.mergeMarkers(
        userMarker: userMarker,
        evMarkers: evMarkers,
        chargerMarkers: chargerMarkers,
      );
    } catch (e) {
      debugPrint("Map error: $e");
    }

    setState(() {
      _loading = false;
    });
  }

  /// EV DETAILS BOTTOM SHEET
  void _showEVDetails(EVModel ev) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ev.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text("₹${ev.pricePerHour}/hour"),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    // TODO: booking flow
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                  ),
                  child: const Text(
                    "Book EV",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// CHARGER DETAILS BOTTOM SHEET
  void _showChargerDetails(ChargerModel charger) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${charger.brand} ${charger.model}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text("₹${charger.pricePerUnit}/unit"),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    // TODO: charger booking flow
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryGreen,
                  ),
                  child: const Text(
                    "Use Charger",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _currentPosition == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Nearby EV & Chargers"),
        backgroundColor: AppColors.primaryPurple,
      ),

      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 14,
        ),

        myLocationEnabled: true,

        myLocationButtonEnabled: true,

        zoomControlsEnabled: true,

        markers: _markers,

        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
