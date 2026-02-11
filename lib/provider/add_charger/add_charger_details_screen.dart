import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../services/location_service.dart';
import '../../services/provider_service.dart';

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

  Future<void> _save() async {
    setState(() => _loading = true);

    final location = await LocationService.getCurrentLocation();

    await ProviderService.addCharger(
      brand: _brandController.text.trim(),
      model: _modelController.text.trim(),
      pricePerUnit: double.parse(_priceController.text),
      latitude: location.latitude,
      longitude: location.longitude,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Charger'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _field(_brandController, 'Brand (e.g. Tata, ABB)'),
            const SizedBox(height: 16),
            _field(_modelController, 'Model (or enter manually)'),
            const SizedBox(height: 16),
            _field(
              _priceController,
              'Price per unit (₹)',
              keyboard: TextInputType.number,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  _loading ? 'Saving...' : 'Save Charger',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint, {
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
}
