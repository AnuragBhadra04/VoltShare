import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  String vehicleType = "2_wheeler";

  File? chargerImage;

  bool loading = false;

  final picker = ImagePicker();

  /// ============================
  /// PICK IMAGE
  /// ============================
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        chargerImage = File(picked.path);
      });
    }
  }

  /// ============================
  /// UPLOAD FILE
  /// ============================
  Future<String> uploadFile(File file, String path) async {
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}";

    await ApiService.supabase.storage
        .from("vehicle_images")
        .upload("$path/$fileName", file);

    return ApiService.supabase.storage
        .from("vehicle_images")
        .getPublicUrl("$path/$fileName");
  }

  /// ============================
  /// ADD CHARGER
  /// ============================
  Future<void> _addCharger() async {
    try {
      if (chargerImage == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Upload charger image")));
        return;
      }

      setState(() => loading = true);

      final userId = ApiService.supabase.auth.currentUser!.id;

      /// 📍 LOCATION
      final position = await LocationService.getCurrentLocation();

      /// 📸 UPLOAD IMAGE
      final imageUrl = await uploadFile(chargerImage!, "charger/$userId");

      /// SAVE TO DB
      await ApiService.addCharger({
        "provider_id": userId,
        "brand": brandController.text.trim(),
        "model": modelController.text.trim(),
        "vehicle_type": vehicleType,
        "price_per_unit": double.parse(priceController.text),
        "image_url": imageUrl,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "is_available": true,
      });

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Charger added successfully ⚡")),
      );
    } catch (e) {
      debugPrint("Add Charger error $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add charger")));
    }

    setState(() => loading = false);
  }

  /// ============================
  /// UI
  /// ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Add Charger"),
        backgroundColor: AppColors.primaryPurple,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            /// VEHICLE TYPE
            DropdownButtonFormField(
              value: vehicleType,
              items: const [
                DropdownMenuItem(value: "2_wheeler", child: Text("2 Wheeler")),
                DropdownMenuItem(value: "4_wheeler", child: Text("4 Wheeler")),
              ],
              onChanged: (v) => setState(() => vehicleType = v.toString()),
              decoration: const InputDecoration(labelText: "Vehicle Type"),
            ),

            const SizedBox(height: 16),

            /// BRAND
            TextField(
              controller: brandController,
              decoration: const InputDecoration(
                labelText: "Brand",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// MODEL
            TextField(
              controller: modelController,
              decoration: const InputDecoration(
                labelText: "Model",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// PRICE
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price Per Unit",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// IMAGE UPLOAD
            ElevatedButton(
              onPressed: pickImage,
              child: Text(
                chargerImage == null
                    ? "Upload Charger Image"
                    : "Image Selected ✅",
              ),
            ),

            const SizedBox(height: 16),

            /// PREVIEW
            if (chargerImage != null) Image.file(chargerImage!, height: 120),

            const SizedBox(height: 30),

            /// SUBMIT
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: loading ? null : _addCharger,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Add Charger"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
