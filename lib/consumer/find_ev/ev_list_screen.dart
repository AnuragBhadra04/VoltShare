import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

import '../../services/location_service.dart';
import '../../services/api_service.dart';

import '../../models/ev_model.dart';

import '../../booking/booking_screen.dart';

class EVListScreen extends StatefulWidget {
  const EVListScreen({super.key});

  @override
  State<EVListScreen> createState() => _EVListScreenState();
}

class _EVListScreenState extends State<EVListScreen> {
  bool _loading = true;

  List<EVModel> _evs = [];

  @override
  void initState() {
    super.initState();
    _loadEVs();
  }

  Future<void> _loadEVs() async {
    try {
      final location = await LocationService.getCurrentLocation();

      final evs = await ApiService.getNearbyEVs(
        location.latitude,
        location.longitude,
      );

      setState(() {
        _evs = evs;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Load EV error: $e");

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
        title: const Text("Nearby EVs"),
        backgroundColor: AppColors.primaryPurple,
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _evs.isEmpty
          ? const Center(child: Text("No EVs nearby"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _evs.length,
              itemBuilder: (_, index) {
                final ev = _evs[index];

                return _evCard(ev);
              },
            ),
    );
  }

  Widget _evCard(EVModel ev) {
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
          /// EV Name
          Text(
            ev.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          /// Price
          Text("₹${ev.pricePerHour} / hour"),

          const SizedBox(height: 12),

          /// BOOK BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingScreen(
                      ev: {
                        "id": ev.id,
                        "brand": ev.name,
                        "model": "",
                        "price": ev.pricePerHour,
                        "type": "ev",
                      },
                    ),
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
                "Book EV",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
