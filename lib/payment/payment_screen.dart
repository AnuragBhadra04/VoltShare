import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/constants/colors.dart';
import '../rating/rating_screen.dart';
import '../services/api_service.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String bookingId;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.bookingId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  /// ===============================
  /// PAYMENT SUCCESS
  /// ===============================
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() => _loading = true);

    try {
      await ApiService.supabase
          .from('bookings')
          .update({'status': 'paid', 'payment_id': response.paymentId})
          .eq('id', widget.bookingId);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RatingScreen(bookingId: widget.bookingId),
        ),
      );
    } catch (e) {
      debugPrint("Payment DB update error: $e");
    }

    setState(() => _loading = false);
  }

  /// ===============================
  /// PAYMENT FAILURE
  /// ===============================
  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  /// ===============================
  /// WALLET
  /// ===============================
  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wallet selected: ${response.walletName}")),
    );
  }

  /// ===============================
  /// OPEN RAZORPAY CHECKOUT
  /// ===============================
  void _openCheckout() {
    final razorpayKey = dotenv.env['RAZORPAY_KEY'];

    if (razorpayKey == null) {
      debugPrint("Razorpay key missing in .env");
      return;
    }

    var options = {
      'key': razorpayKey,
      'amount': (widget.amount * 100).toInt(),
      'name': 'VoltShare',
      'description': 'EV / Charger Booking',
      'timeout': 300,
      'prefill': {'contact': '', 'email': ''},
      'theme': {'color': '#6C63FF'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Payment open error: $e");
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  /// ===============================
  /// UI
  /// ===============================
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
                  "Payment",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Complete your VoltShare booking",
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
                  /// PAYMENT ICON
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withOpacity(.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.payment,
                      size: 60,
                      color: AppColors.primaryPurple,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// AMOUNT CARD
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Total Amount",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "₹${widget.amount}",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  /// PAY BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _openCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Pay Now",
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
