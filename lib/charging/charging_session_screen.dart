import 'dart:async';
import 'package:flutter/material.dart';

import '../core/constants/colors.dart';
import '../services/api_service.dart';

class ChargingSessionScreen extends StatefulWidget {
  final String bookingId;

  const ChargingSessionScreen({super.key, required this.bookingId});

  @override
  State<ChargingSessionScreen> createState() => _ChargingSessionScreenState();
}

class _ChargingSessionScreenState extends State<ChargingSessionScreen> {
  int seconds = 0;
  Timer? timer;

  bool ending = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        seconds++;
      });
    });
  }

  Future<void> endSession() async {
    setState(() => ending = true);

    try {
      timer?.cancel();

      /// update booking session end
      await ApiService.updateBookingStatus(widget.bookingId, "completed");

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Charging session ended")));
    } catch (e) {
      debugPrint("End charging error: $e");
    }

    setState(() => ending = false);
  }

  String formatTime() {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;

    return "$minutes:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Charging Session"),
        backgroundColor: AppColors.secondaryGreen,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            /// charging icon
            Container(
              padding: const EdgeInsets.all(30),

              decoration: BoxDecoration(
                color: AppColors.secondaryGreen.withOpacity(.15),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.ev_station,
                size: 70,
                color: AppColors.secondaryGreen,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Charging in progress",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text(
              formatTime(),
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: ending ? null : endSession,

                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

                child: ending
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("End Charging Session"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
