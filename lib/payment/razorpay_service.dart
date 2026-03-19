import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  static Razorpay? _razorpay;

  // ===============================
  // INITIALIZE RAZORPAY
  // ===============================
  static void init({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
    required Function(ExternalWalletResponse) onWallet,
  }) {
    // Prevent duplicate instances
    dispose();

    _razorpay = Razorpay();

    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);

    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, onError);

    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, onWallet);
  }

  // ===============================
  // OPEN CHECKOUT
  // ===============================
  static void openCheckout({
    required double amount,
    String name = "VoltShare",
    String description = "EV / Charger Booking",
    String contact = "",
    String email = "",
  }) {
    if (_razorpay == null) {
      debugPrint("Razorpay not initialized");
      return;
    }

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
      _razorpay!.open(options);
    } catch (e) {
      debugPrint("Razorpay open error: $e");
    }
  }

  // ===============================
  // DISPOSE
  // ===============================
  static void dispose() {
    _razorpay?.clear();
    _razorpay = null;
  }
}
