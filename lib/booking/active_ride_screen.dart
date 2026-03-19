import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import '../core/constants/colors.dart';

class ActiveRideScreen extends StatefulWidget {
  final String bookingId;

  const ActiveRideScreen({super.key, required this.bookingId});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  bool loading = false;

  Future<void> _endRide() async {
    try {
      setState(() => loading = true);

      await BookingService.endRide(widget.bookingId);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Ride completed")));

      Navigator.pop(context);
    } catch (e) {
      debugPrint("End ride error: $e");
    }

    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Ride In Progress"),
        backgroundColor: AppColors.primaryPurple,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              /// ICON
              const Icon(
                Icons.electric_car,
                size: 90,
                color: AppColors.secondaryGreen,
              ),

              const SizedBox(height: 30),

              /// TITLE
              const Text(
                "Your ride is active",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                "Enjoy your VoltShare ride!",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 50),

              /// END RIDE BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: loading ? null : _endRide,

                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "End Ride",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
