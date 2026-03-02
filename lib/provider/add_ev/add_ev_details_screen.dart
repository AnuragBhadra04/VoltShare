import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../core/constants/colors.dart';
import '../../services/location_service.dart';
import '../../repository/ev_repository.dart';
import '../../models/ev_model.dart';

class AddEVDetailsScreen extends StatefulWidget {
  const AddEVDetailsScreen({super.key});

  @override
  State<AddEVDetailsScreen> createState() => _AddEVDetailsScreenState();
}

class _AddEVDetailsScreenState extends State<AddEVDetailsScreen> {
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _priceController = TextEditingController();
  final _rangeController = TextEditingController();

  String? _docName;

  bool _loading = false;

  // ===============================
  // PICK DOCUMENT (Optional upload)
  // ===============================
  Future<void> _pickDoc() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _docName = result.files.first.name;
      });
    }
  }

  // ===============================
  // SAVE EV TO SUPABASE
  // ===============================
  Future<void> _save() async {
    try {
      if (_brandController.text.isEmpty ||
          _modelController.text.isEmpty ||
          _priceController.text.isEmpty ||
          _rangeController.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
        return;
      }

      setState(() => _loading = true);

      /// GET LOCATION
      final location = await LocationService.getCurrentLocation();

      /// CREATE EV MODEL
      final ev = EVModel(
        id: "", // Supabase generates ID
        name: "${_brandController.text.trim()} ${_modelController.text.trim()}",
        latitude: location.latitude,
        longitude: location.longitude,
        pricePerHour: double.parse(_priceController.text.trim()),
        isAvailable: true,
      );

      /// SAVE TO SUPABASE
      await EVRepository.addEV(ev);

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("EV added successfully")));
    } catch (e) {
      debugPrint("Add EV error: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add EV")));
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
        title: const Text("Add EV"),
        backgroundColor: AppColors.secondaryGreen,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            _field(controller: _brandController, hint: "EV Brand"),

            const SizedBox(height: 16),

            _field(controller: _modelController, hint: "EV Model"),

            const SizedBox(height: 16),

            _field(
              controller: _rangeController,
              hint: "Range (km)",
              keyboard: TextInputType.number,
            ),

            const SizedBox(height: 16),

            _field(
              controller: _priceController,
              hint: "Price per hour (₹)",
              keyboard: TextInputType.number,
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.upload_file),
              title: Text(_docName ?? "Upload RC / Insurance"),
              onTap: _pickDoc,
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: _loading ? null : _save,

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryGreen,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save EV",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
    _rangeController.dispose();
    super.dispose();
  }
}
