import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';

class RazorpayService {
  static late Razorpay _razorpay;

  // ===============================
  // INITIALIZE RAZORPAY
  // ===============================
  static void init({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
    required Function(ExternalWalletResponse) onWallet,
  }) {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onWallet);
  }

  // ===============================
  // OPEN CHECKOUT
  // ===============================
  static void openCheckout({
    required double amount,
    required String name,
    String description = "VoltShare Payment",
    String contact = "",
    String email = "",
  }) {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY',

      'amount': (amount * 100).toInt(),

      'name': name,

      'description': description,

      'timeout': 300,

      'prefill': {'contact': contact, 'email': email},

      'theme': {'color': '#6C63FF'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Razorpay open error: $e");
    }
  }

  // ===============================
  // CLEAR INSTANCE
  // ===============================
  static void dispose() {
    _razorpay.clear();
  }
}
