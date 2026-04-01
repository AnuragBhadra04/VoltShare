import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class KYCScreen extends StatefulWidget {
  const KYCScreen({super.key});

  @override
  State<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  File? dlFile;
  File? aadharFile;

  bool loading = false;

  final picker = ImagePicker();

  Future<void> pickDL() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => dlFile = File(picked.path));
    }
  }

  Future<void> pickAadhar() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => aadharFile = File(picked.path));
    }
  }

  Future<String> upload(File file, String path) async {
    final name = DateTime.now().millisecondsSinceEpoch.toString();

    await ApiService.supabase.storage
        .from("documents")
        .upload("$path/$name", file);

    return ApiService.supabase.storage
        .from("documents")
        .getPublicUrl("$path/$name");
  }

  Future<void> submitKYC() async {
    if (dlFile == null || aadharFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Upload DL & Aadhar")));
      return;
    }

    try {
      setState(() => loading = true);

      final userId = ApiService.supabase.auth.currentUser!.id;

      final dlUrl = await upload(dlFile!, "dl/$userId");
      final aadharUrl = await upload(aadharFile!, "aadhar/$userId");

      /// SAVE DOCUMENTS
      await ApiService.supabase.from("documents").insert([
        {"user_id": userId, "document_type": "dl", "file_url": dlUrl},
        {"user_id": userId, "document_type": "aadhar", "file_url": aadharUrl},
      ]);

      /// MARK VERIFIED (optional)
      await ApiService.supabase
          .from("users")
          .update({"kyc_verified": true})
          .eq("id", userId);

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("KYC uploaded ✅")));
    } catch (e) {
      debugPrint("KYC error $e");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete KYC")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickDL,
              child: Text(dlFile == null ? "Upload DL" : "DL Uploaded"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: pickAadhar,
              child: Text(
                aadharFile == null ? "Upload Aadhar" : "Aadhar Uploaded",
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: loading ? null : submitKYC,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
