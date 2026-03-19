import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../core/constants/colors.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List payments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    try {
      final user = AuthService.currentUser;

      if (user == null) return;

      final data = await ApiService.supabase
          .from("bookings")
          .select()
          .eq("user_id", user.id)
          .not("payment_id", "is", null)
          .order("created_at", ascending: false);

      if (!mounted) return;

      setState(() {
        payments = data;
        loading = false;
      });
    } catch (e) {
      debugPrint("Payment history error: $e");

      if (!mounted) return;

      setState(() => loading = false);
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case "completed":
        return Colors.green;

      case "active":
        return Colors.blue;

      case "accepted":
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Payment History"),
        backgroundColor: AppColors.primaryPurple,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : payments.isEmpty
          ? const Center(child: Text("No payments yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: payments.length,
              itemBuilder: (_, i) {
                final payment = payments[i];

                final id = payment["id"];
                final amount = payment["amount"];
                final status = payment["status"];
                final created = payment["created_at"];
                final paymentId = payment["payment_id"];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// HEADER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment #${id.toString().substring(0, 6)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),

                              decoration: BoxDecoration(
                                color: statusColor(status),
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: Text(
                                status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// AMOUNT
                        Text(
                          "Amount Paid: ₹$amount",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 6),

                        /// PAYMENT ID
                        Text(
                          "Payment ID: ${paymentId ?? "N/A"}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// DATE
                        Text(
                          "Date: $created",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
