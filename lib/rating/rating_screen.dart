import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../core/constants/colors.dart';

class RatingScreen extends StatefulWidget {
  final String bookingId;

  const RatingScreen({super.key, required this.bookingId});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 0;
  bool _loading = false;

  // ===============================
  // SUBMIT RATING
  // ===============================
  Future<void> _submitRating() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a rating")));
      return;
    }

    try {
      setState(() => _loading = true);

      await ApiService.supabase
          .from('bookings')
          .update({'rating': _rating})
          .eq('id', widget.bookingId);

      if (!mounted) return;

      Navigator.of(context).popUntil((route) => route.isFirst);

      Future.delayed(const Duration(milliseconds: 300), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Thank you for your feedback!")),
        );
      });
    } catch (e) {
      debugPrint("Rating error: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to submit rating")));
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 50, 24, 24),

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
                  "Rate Your Experience",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "Your feedback helps improve VoltShare",
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
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryGreen.withOpacity(.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      size: 60,
                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "How was your experience?",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 25),

                  /// STAR RATING
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          size: 42,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 40),

                  /// SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed: _loading ? null : _submitRating,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),

                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Submit Rating",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
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
