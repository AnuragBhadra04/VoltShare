import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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

  // ===============================
  // PAYMENT SUCCESS
  // ===============================
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() => _loading = true);

    try {
      // ✅ UPDATE BOOKING STATUS
      await ApiService.supabase
          .from('bookings')
          .update({'status': 'completed', 'payment_id': response.paymentId})
          .eq('id', widget.bookingId);

      if (!mounted) return;

      // ✅ PASS bookingId to RatingScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RatingScreen(bookingId: widget.bookingId),
        ),
      );
    } catch (e) {
      debugPrint("Payment success DB error: $e");
    }

    setState(() => _loading = false);
  }

  // ===============================
  // PAYMENT FAILURE
  // ===============================
  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  // ===============================
  // WALLET HANDLER
  // ===============================
  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wallet selected: ${response.walletName}")),
    );
  }

  // ===============================
  // OPEN CHECKOUT
  // ===============================
  void _openCheckout() {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY',

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

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: AppColors.primaryPurple,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Icon(
                Icons.payment,
                size: 80,
                color: AppColors.primaryPurple,
              ),

              const SizedBox(height: 20),

              Text(
                "Amount: ₹${widget.amount}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

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
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
