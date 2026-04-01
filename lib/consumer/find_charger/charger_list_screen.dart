import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../services/location_service.dart';
import '../../services/api_service.dart';
import '../../models/charger_model.dart';
import '../../booking/booking_screen.dart';

class ChargerListScreen extends StatefulWidget {
  final String vehicleType;

  const ChargerListScreen({super.key, required this.vehicleType});

  @override
  State<ChargerListScreen> createState() => _ChargerListScreenState();
}

class _ChargerListScreenState extends State<ChargerListScreen> {
  bool _loading = true;
  List<ChargerModel> _chargers = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadChargers();
  }

  Future<void> _loadChargers() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      /// 📍 GET LOCATION
      final location = await LocationService.getCurrentLocation();

      /// 📡 FETCH (2KM RADIUS)
      final chargers = await ApiService.getNearbyChargers(
        location.latitude,
        location.longitude,
        radiusKm: 2,
      );

      /// 🎯 (OPTIONAL) FILTER IF YOU ADD TYPE IN DB LATER
      final filtered = chargers;

      if (!mounted) return;

      setState(() {
        _chargers = filtered;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Load chargers error: $e");

      if (!mounted) return;

      setState(() {
        _error = "Failed to load chargers";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 55, 24, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF5E8DAA)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nearby Chargers",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.vehicleType == "2_wheeler"
                      ? "2W compatible chargers"
                      : "4W compatible chargers",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          /// BODY
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadChargers,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(child: Text(_error!))
                  : _chargers.isEmpty
                  ? const Center(child: Text("No chargers found within 2km"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _chargers.length,
                      itemBuilder: (_, i) => _chargerCard(_chargers[i]),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chargerCard(ChargerModel charger) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.ev_station,
                  color: AppColors.primaryPurple,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${charger.brand} ${charger.model}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      charger.isAvailable ? "Available" : "Unavailable",
                      style: TextStyle(
                        color: charger.isAvailable ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                "₹${charger.pricePerUnit}/unit",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryGreen,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// BOOK BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: charger.isAvailable
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingScreen(
                            ev: {
                              "id": charger.id,
                              "provider_id": charger.providerId,
                              "brand": charger.brand,
                              "model": charger.model,
                              "price": charger.pricePerUnit,
                              "type": "charger",
                            },
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
              ),
              child: const Text(
                "Book Charger",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
