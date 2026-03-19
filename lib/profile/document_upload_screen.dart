import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../core/constants/colors.dart';

class DocumentUploadScreen extends StatefulWidget {
  final String type; // "dl" or "rc"

  const DocumentUploadScreen({super.key, required this.type});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  File? file;
  bool loading = false;

  final supabase = Supabase.instance.client;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    setState(() {
      file = File(picked.path);
    });
  }

  Future<void> uploadDocument() async {
    if (file == null) return;

    setState(() => loading = true);

    try {
      final user = AuthService.currentUser;

      final fileName = "${user!.id}_${widget.type}.jpg";

      await supabase.storage.from("documents").upload(fileName, file!);

      final url = supabase.storage.from("documents").getPublicUrl(fileName);

      final column = widget.type == "dl" ? "dl_url" : "rc_url";

      await supabase.from("users").update({column: url}).eq("id", user.id);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Document uploaded")));

      Navigator.pop(context);
    } catch (e) {
      debugPrint("Upload error: $e");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.type == "dl" ? "Upload Driving License" : "Upload RC";

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primaryPurple,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            const SizedBox(height: 30),

            file == null
                ? const Icon(Icons.image, size: 120)
                : Image.file(file!, height: 200),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Select Image"),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: loading ? null : uploadDocument,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryGreen,
                ),

                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Upload Document"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
