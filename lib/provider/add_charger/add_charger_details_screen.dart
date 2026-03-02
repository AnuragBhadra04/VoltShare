import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../services/location_service.dart';
import '../../repository/charger_repository.dart';
import '../../models/charger_model.dart';

class AddChargerDetailsScreen extends StatefulWidget {
  const AddChargerDetailsScreen({super.key});

  @override
  State<AddChargerDetailsScreen> createState() =>
      _AddChargerDetailsScreenState();
}

class _AddChargerDetailsScreenState extends State<AddChargerDetailsScreen> {
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _priceController = TextEditingController();

  bool _loading = false;

  // ===============================
  // SAVE CHARGER TO SUPABASE
  // ===============================
  Future<void> _save() async {
    try {
      if (_brandController.text.isEmpty ||
          _modelController.text.isEmpty ||
          _priceController.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
        return;
      }

      setState(() => _loading = true);

      /// GET USER LOCATION
      final location = await LocationService.getCurrentLocation();

      /// CREATE CHARGER MODEL
      final charger = ChargerModel(
        id: "", // Supabase will generate
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        latitude: location.latitude,
        longitude: location.longitude,
        isAvailable: true,
        pricePerUnit: double.parse(_priceController.text.trim()),
      );

      /// SAVE TO SUPABASE
      await ChargerRepository.addCharger(charger);

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Charger added successfully")),
      );
    } catch (e) {
      debugPrint("Add charger error: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add charger")));
    }

    setState(() => _loading = false);
  }

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Add Charger"),
        backgroundColor: AppColors.secondaryGreen,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            _field(
              controller: _brandController,
              hint: "Brand (Tata, ABB, etc)",
            ),

            const SizedBox(height: 16),

            _field(controller: _modelController, hint: "Model"),

            const SizedBox(height: 16),

            _field(
              controller: _priceController,
              hint: "Price per unit (₹)",
              keyboard: TextInputType.number,
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: _loading ? null : _save,

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Charger",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================
  // FIELD WIDGET
  // ===============================
  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,

      decoration: InputDecoration(
        hintText: hint,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
