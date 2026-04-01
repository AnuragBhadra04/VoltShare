import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/colors.dart';
import '../../services/api_service.dart';
import '../../services/location_service.dart';

class AddEVDetailsScreen extends StatefulWidget {
  const AddEVDetailsScreen({super.key});

  @override
  State<AddEVDetailsScreen> createState() => _AddEVDetailsScreenState();
}

class _AddEVDetailsScreenState extends State<AddEVDetailsScreen> {
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final priceController = TextEditingController();

  String vehicleType = "2_wheeler";
  String fuelType = "ev";

  File? rcFile;
  List<File> vehicleImages = [];

  bool loading = false;

  final picker = ImagePicker();

  /// ============================
  /// PICK RC
  /// ============================
  Future<void> pickRC() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        rcFile = File(picked.path);
      });
    }
  }

  /// ============================
  /// PICK VEHICLE IMAGES
  /// ============================
  Future<void> pickImages() async {
    final picked = await picker.pickMultiImage();

    if (picked.isNotEmpty) {
      setState(() {
        vehicleImages = picked.map((e) => File(e.path)).toList();
      });
    }
  }

  /// ============================
  /// UPLOAD FILE TO SUPABASE
  /// ============================
  Future<String> uploadFile(File file, String path, String bucket) async {
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}";

    await ApiService.supabase.storage
        .from(bucket)
        .upload("$path/$fileName", file);

    return ApiService.supabase.storage
        .from(bucket)
        .getPublicUrl("$path/$fileName");
  }

  /// ============================
  /// ADD EV
  /// ============================
  Future<void> _addEV() async {
    try {
      if (rcFile == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Upload RC first")));
        return;
      }

      if (vehicleImages.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Upload vehicle images")));
        return;
      }

      setState(() => loading = true);

      final userId = ApiService.supabase.auth.currentUser!.id;

      /// 📍 LOCATION
      final position = await LocationService.getCurrentLocation();

      /// 📄 UPLOAD RC
      final rcUrl = await uploadFile(rcFile!, "rc/$userId", "documents");

      /// 📸 UPLOAD IMAGES
      List<String> imageUrls = [];

      for (var img in vehicleImages) {
        final url = await uploadFile(img, "ev/$userId", "vehicle_images");
        imageUrls.add(url);
      }

      /// SAVE TO DB
      await ApiService.addEV({
        "provider_id": userId,
        "brand": brandController.text.trim(),
        "model": modelController.text.trim(),
        "fuel_type": fuelType,
        "vehicle_type": vehicleType,
        "price_per_hour": double.parse(priceController.text),
        "images": imageUrls,
        "rc_url": rcUrl,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "is_available": true,
      });

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("EV added successfully 🚀")));
    } catch (e) {
      debugPrint("EV error $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add EV")));
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
        title: const Text("Add EV"),
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

            /// FUEL TYPE
            DropdownButtonFormField(
              value: fuelType,
              items: const [
                DropdownMenuItem(value: "ev", child: Text("EV")),
                DropdownMenuItem(value: "petrol", child: Text("Petrol")),
                DropdownMenuItem(value: "diesel", child: Text("Diesel")),
              ],
              onChanged: (v) => setState(() => fuelType = v.toString()),
              decoration: const InputDecoration(labelText: "Fuel Type"),
            ),

            const SizedBox(height: 16),

            /// BRAND
            TextField(
              controller: brandController,
              decoration: const InputDecoration(labelText: "Brand"),
            ),

            const SizedBox(height: 16),

            /// MODEL
            TextField(
              controller: modelController,
              decoration: const InputDecoration(labelText: "Model"),
            ),

            const SizedBox(height: 16),

            /// PRICE
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price Per Hour"),
            ),

            const SizedBox(height: 20),

            /// RC UPLOAD
            ElevatedButton(
              onPressed: pickRC,
              child: Text(rcFile == null ? "Upload RC" : "RC Selected ✅"),
            ),

            const SizedBox(height: 12),

            /// IMAGE UPLOAD
            ElevatedButton(
              onPressed: pickImages,
              child: const Text("Upload Vehicle Images"),
            ),

            const SizedBox(height: 20),

            /// PREVIEW
            Wrap(
              children: vehicleImages
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.file(e, height: 80),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 30),

            /// SUBMIT
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: loading ? null : _addEV,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryGreen,
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Add EV"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
