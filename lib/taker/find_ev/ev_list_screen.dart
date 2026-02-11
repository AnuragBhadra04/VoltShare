import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../services/location_service.dart';
import '../../services/provider_service.dart';
import '../../core/utils/distance_helper.dart';
import '../../services/booking_service.dart'; // ✅ ADD THIS

class EVListScreen extends StatefulWidget {
  const EVListScreen({super.key});

  @override
  State<EVListScreen> createState() => _EVListScreenState();
}

class _EVListScreenState extends State<EVListScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _nearbyEVs = [];

  @override
  void initState() {
    super.initState();
    _loadEVs();
  }

  Future<void> _loadEVs() async {
    final userLocation = await LocationService.getCurrentLocation();

    final evs = ProviderService.evs.where((ev) {
      final distance = DistanceHelper.kmBetween(
        userLocation.latitude,
        userLocation.longitude,
        ev['lat'],
        ev['lng'],
      );
      return distance <= 10 && ev['available'] == true;
    }).toList();

    setState(() {
      _nearbyEVs = evs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Nearby EVs'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _nearbyEVs.isEmpty
          ? const Center(child: Text('No EVs nearby'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _nearbyEVs.length,
              itemBuilder: (_, i) {
                final ev = _nearbyEVs[i];
                return _evCard(ev);
              },
            ),
    );
  }

  Widget _evCard(Map<String, dynamic> ev) {
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
            '${ev['brand']} ${ev['model']}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text('Range: ${ev['range']} km'),
          Text('₹${ev['price']} / hour'),
          const SizedBox(height: 12),

          // ✅ BOOK EV BUTTON (CONNECTED)
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () async {
                await BookingService.createBooking(type: 'ev', item: ev);

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking request sent to provider'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Book EV',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
