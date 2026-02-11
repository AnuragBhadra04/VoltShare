import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/constants/colors.dart';
import '../../services/location_service.dart';
import '../../services/provider_service.dart';

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

  Future<void> _pickDoc() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() => _docName = result.files.first.name);
    }
  }

  Future<void> _save() async {
    setState(() => _loading = true);

    final location = await LocationService.getCurrentLocation();

    await ProviderService.addEV(
      brand: _brandController.text.trim(),
      model: _modelController.text.trim(),
      pricePerHour: double.parse(_priceController.text),
      rangeKm: int.parse(_rangeController.text),
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
        title: const Text('Add EV'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _field(_brandController, 'EV Brand'),
            const SizedBox(height: 16),
            _field(_modelController, 'EV Model'),
            const SizedBox(height: 16),
            _field(
              _rangeController,
              'Range (km)',
              keyboard: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _field(
              _priceController,
              'Price per hour (₹)',
              keyboard: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: Text(_docName ?? 'Upload RC / Insurance'),
              onTap: _pickDoc,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  _loading ? 'Saving...' : 'Save EV',
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
