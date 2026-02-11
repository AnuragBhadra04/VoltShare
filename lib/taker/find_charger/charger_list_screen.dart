import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../services/location_service.dart';
import '../../services/provider_service.dart';
import '../../core/utils/distance_helper.dart';

class ChargerListScreen extends StatefulWidget {
  const ChargerListScreen({super.key});

  @override
  State<ChargerListScreen> createState() => _ChargerListScreenState();
}

class _ChargerListScreenState extends State<ChargerListScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _nearbyChargers = [];

  @override
  void initState() {
    super.initState();
    _loadChargers();
  }

  Future<void> _loadChargers() async {
    final userLocation = await LocationService.getCurrentLocation();

    final chargers = ProviderService.chargers.where((charger) {
      final distance = DistanceHelper.kmBetween(
        userLocation.latitude,
        userLocation.longitude,
        charger['lat'],
        charger['lng'],
      );

      return distance <= 10 && charger['available'] == true;
    }).toList();

    setState(() {
      _nearbyChargers = chargers;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Nearby Chargers'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _nearbyChargers.isEmpty
          ? const Center(child: Text('No chargers nearby'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _nearbyChargers.length,
              itemBuilder: (_, index) {
                final charger = _nearbyChargers[index];
                return _chargerCard(charger);
              },
            ),
    );
  }

  Widget _chargerCard(Map<String, dynamic> charger) {
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
          Text(
            '${charger['brand']} ${charger['model']}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text('₹${charger['price']} per unit'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Request Charger',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
