import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../services/api_service.dart';
import '../../services/location_service.dart';

class AddEVDetailsScreen extends StatefulWidget {
  const AddEVDetailsScreen({super.key});

  @override
  State<AddEVDetailsScreen> createState() => _AddEVDetailsScreenState();
}

class _AddEVDetailsScreenState extends State<AddEVDetailsScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  bool loading = false;

  Future<void> _addEV() async {
    try {
      setState(() => loading = true);

      /// Check RC uploaded
      final user = await ApiService.supabase
          .from("users")
          .select()
          .eq("id", ApiService.supabase.auth.currentUser!.id)
          .single();

      if (user["rc_url"] == null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please upload RC in profile before adding EV"),
          ),
        );

        setState(() => loading = false);
        return;
      }

      /// GET CURRENT LOCATION
      final position = await LocationService.getCurrentLocation();

      await ApiService.addEV({
        "name": nameController.text.trim(),

        "price_per_hour": double.parse(priceController.text),

        "latitude": position.latitude,

        "longitude": position.longitude,

        "is_available": true,
      });

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("EV added successfully")));
    } catch (e) {
      debugPrint("Add EV error $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add EV")));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Add EV"),
        backgroundColor: AppColors.primaryPurple,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            /// EV NAME
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "EV Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// PRICE
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price Per Hour",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: loading ? null : _addEV,

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Add EV",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
