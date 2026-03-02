import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../services/location_service.dart';
import '../../services/api_service.dart';

import '../../models/charger_model.dart';

import '../../booking/booking_screen.dart';

class ChargerListScreen extends StatefulWidget {
  const ChargerListScreen({super.key});

  @override
  State<ChargerListScreen> createState() => _ChargerListScreenState();
}

class _ChargerListScreenState extends State<ChargerListScreen> {
  bool _loading = true;

  List<ChargerModel> _chargers = [];

  @override
  void initState() {
    super.initState();
    _loadChargers();
  }

  Future<void> _loadChargers() async {
    try {
      final location = await LocationService.getCurrentLocation();

      final chargers = await ApiService.getNearbyChargers(
        location.latitude,
        location.longitude,
      );

      setState(() {
        _chargers = chargers;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Load chargers error: $e");

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Nearby Chargers"),
        backgroundColor: AppColors.primaryPurple,
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _chargers.isEmpty
          ? const Center(child: Text("No chargers nearby"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _chargers.length,
              itemBuilder: (_, index) {
                final charger = _chargers[index];

                return _chargerCard(charger);
              },
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// Charger Name
          Text(
            "${charger.brand} ${charger.model}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          /// Price
          Text("₹${charger.pricePerUnit} per unit"),

          const SizedBox(height: 12),

          /// Request Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingScreen(
                      ev: {
                        "id": charger.id,
                        "brand": charger.brand,
                        "model": charger.model,
                        "price": charger.pricePerUnit,
                        "type": "charger",
                      },
                    ),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              child: const Text(
                "Request Charger",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
