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
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEVs();
  }

  Future<void> _loadEVs() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final location = await LocationService.getCurrentLocation();

      final evs = await ApiService.getNearbyEVs(
        location.latitude,
        location.longitude,
      );

      if (!mounted) return;

      setState(() {
        _evs = evs;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Load EV error: $e");

      if (!mounted) return;

      setState(() {
        _error = "Failed to load EVs";
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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),

            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nearby EVs",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "Electric vehicles available near you",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          /// BODY
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadEVs,

              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Text(
                        _error!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    )
                  : _evs.isEmpty
                  ? const Center(
                      child: Text(
                        "No EVs available nearby",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _evs.length,
                      itemBuilder: (_, index) {
                        final ev = _evs[index];
                        return _evCard(ev);
                      },
                    ),
            ),
          ),
        ],
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
              /// ICON
              Container(
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.electric_car,
                  color: AppColors.primaryPurple,
                ),
              ),

              const SizedBox(width: 14),

              /// NAME + STATUS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ev.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      ev.isAvailable
                          ? "Available now"
                          : "Currently unavailable",
                      style: TextStyle(
                        fontSize: 13,
                        color: ev.isAvailable ? Colors.green : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),

              /// PRICE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: AppColors.secondaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Text(
                  "₹${ev.pricePerHour}/hr",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryGreen,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// BOOK BUTTON
          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: ev.isAvailable
                  ? () {
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
                    }
                  : null,

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryGreen,
                disabledBackgroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),

              child: const Text(
                "Book EV",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
