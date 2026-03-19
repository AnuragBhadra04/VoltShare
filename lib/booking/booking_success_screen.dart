import 'package:flutter/material.dart';

import '../core/constants/colors.dart';
import '../rating/rating_screen.dart';
import '../consumer/consumer_home_screen.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String bookingId;

  const BookingSuccessScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),

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
                  "Booking Confirmed",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "Your VoltShare booking was successful",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          /// BODY
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  /// SUCCESS ICON
                  Container(
                    padding: const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      color: AppColors.secondaryGreen.withOpacity(.1),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: AppColors.secondaryGreen,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Payment Successful!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Booking ID: $bookingId",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                  const SizedBox(height: 40),

                  /// RATE SERVICE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RatingScreen(bookingId: bookingId),
                          ),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),

                      child: const Text(
                        "Rate Your Experience",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// BACK HOME
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ConsumerHomeScreen(),
                          ),
                          (route) => false,
                        );
                      },

                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryPurple),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),

                      child: const Text(
                        "Back to Home",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
