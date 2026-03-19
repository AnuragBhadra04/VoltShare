import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/constants/colors.dart';

class RazorpayService {
  static Razorpay? _razorpay;

  // =====================================================
  // INITIALIZE RAZORPAY
  // =====================================================
  static void initialize({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
    required Function(ExternalWalletResponse) onWallet,
  }) {
    dispose(); // prevent duplicate listeners

    _razorpay = Razorpay();

    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, onWallet);
  }

  // =====================================================
  // START PAYMENT
  // =====================================================
  static void startPayment({
    required double amount,
    String name = "VoltShare",
    String description = "EV / Charger Booking",
    String contact = "",
    String email = "",
  }) {
    if (_razorpay == null) {
      debugPrint("❌ Razorpay not initialized");
      return;
    }

    final razorpayKey = dotenv.env['RAZORPAY_KEY'] ?? "";

    if (razorpayKey.isEmpty) {
      debugPrint("❌ Razorpay key missing");
      return;
    }

    final options = {
      'key': razorpayKey,

      // Razorpay requires amount in paise
      'amount': (amount * 100).toInt(),

      'name': name,
      'description': description,

      'timeout': 300,

      'prefill': {'contact': contact, 'email': email},

      'theme': {
        'color':
            '#${AppColors.primaryPurple.value.toRadixString(16).substring(2)}',
      },
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint("❌ Razorpay open error: $e");
    }
  }

  // =====================================================
  // VERIFY PAYMENT (Future backend verification)
  // =====================================================
  static Future<void> verifyPayment({
    required String paymentId,
    required String orderId,
    required String signature,
  }) async {
    // In production this should be verified on backend
    // using Razorpay secret key

    debugPrint("Payment verification placeholder");
  }

  // =====================================================
  // DISPOSE RAZORPAY
  // =====================================================
  static void dispose() {
    _razorpay?.clear();
    _razorpay = null;
  }
}
