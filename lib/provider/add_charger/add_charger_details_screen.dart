import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../services/api_service.dart';
import '../../services/location_service.dart';

class AddChargerDetailsScreen extends StatefulWidget {
  const AddChargerDetailsScreen({super.key});

  @override
  State<AddChargerDetailsScreen> createState() =>
      _AddChargerDetailsScreenState();
}

class _AddChargerDetailsScreenState extends State<AddChargerDetailsScreen> {
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final priceController = TextEditingController();

  bool loading = false;

  Future<void> _addCharger() async {
    try {
      setState(() => loading = true);

      final position = await LocationService.getCurrentLocation();

      await ApiService.addCharger({
        "brand": brandController.text.trim(),

        "model": modelController.text.trim(),

        "price_per_unit": double.parse(priceController.text),

        "latitude": position.latitude,

        "longitude": position.longitude,

        "is_available": true,
      });

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Charger added successfully")),
      );
    } catch (e) {
      debugPrint("Add Charger error $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add charger")));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Add Charger"),
        backgroundColor: AppColors.primaryPurple,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            TextField(
              controller: brandController,
              decoration: const InputDecoration(
                labelText: "Brand",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: modelController,
              decoration: const InputDecoration(
                labelText: "Model",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price Per Unit",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: loading ? null : _addCharger,

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Add Charger",
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
