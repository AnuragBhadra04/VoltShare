import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../core/constants/colors.dart';

class RideSessionScreen extends StatefulWidget {
  final String bookingId;

  const RideSessionScreen({super.key, required this.bookingId});

  @override
  State<RideSessionScreen> createState() => _RideSessionScreenState();
}

class _RideSessionScreenState extends State<RideSessionScreen> {
  bool loading = false;

  Future<void> endRide() async {
    setState(() => loading = true);

    try {
      await ApiService.updateBookingStatus(widget.bookingId, "completed");

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Ride completed")));
    } catch (e) {
      debugPrint("End ride error: $e");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Ride Active"),
        backgroundColor: AppColors.secondaryGreen,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Icon(Icons.electric_car, size: 100, color: Colors.green),

              const SizedBox(height: 20),

              const Text(
                "Your ride is currently active",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: loading ? null : endRide,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("End Ride"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
