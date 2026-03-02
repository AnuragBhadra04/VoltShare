import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/constants/colors.dart';
import '../services/auth_service.dart';
import '../services/role_service.dart';
import '../role/role_selection_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;

  Map<String, dynamic>? userData;

  bool loading = true;
  bool saving = false;

  File? imageFile;

  late AnimationController controller;
  late Animation<double> fade;
  late Animation<Offset> slide;

  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    fade = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    loadProfile();

    controller.forward();
  }

  Future<void> loadProfile() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) return;

      final data = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      nameController.text = data['name'] ?? "";

      setState(() {
        userData = data;
        loading = false;
      });
    } catch (e) {
      debugPrint("Profile load error: $e");
      setState(() => loading = false);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );

    if (picked == null) return;

    setState(() {
      imageFile = File(picked.path);
    });
  }

  Future<String?> uploadImage() async {
    if (imageFile == null) return userData?['photo_url'];

    final user = supabase.auth.currentUser;

    final fileName = "profile_${user!.id}.jpg";

    await supabase.storage
        .from('profiles')
        .upload(
          fileName,
          imageFile!,
          fileOptions: const FileOptions(upsert: true),
        );

    final url = supabase.storage.from('profiles').getPublicUrl(fileName);

    return url;
  }

  Future<void> saveProfile() async {
    try {
      setState(() => saving = true);

      final user = supabase.auth.currentUser;

      final photoUrl = await uploadImage();

      await supabase
          .from('users')
          .update({'name': nameController.text.trim(), 'photo_url': photoUrl})
          .eq('id', user!.id);

      await loadProfile();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile updated")));
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => saving = false);
  }

  Future<void> logout() async {
    await AuthService.logout();
    await RoleService.clearRole();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      (route) => false,
    );
  }

  Widget infoTile(icon, title, value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(.05)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryPurple),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              Text(
                value ?? "-",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final name = userData?['name'] ?? "User";
    final phone = userData?['phone'];
    final email = userData?['email'];
    final role = userData?['role'] ?? "consumer";
    final photo = userData?['photo_url'];

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text("Hello, $name 👋"),
        backgroundColor: AppColors.primaryPurple,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),

      body: FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: AppColors.primaryPurple,
                    backgroundImage: imageFile != null
                        ? FileImage(imageFile!)
                        : photo != null
                        ? NetworkImage(photo)
                        : null,
                    child: photo == null && imageFile == null
                        ? Text(
                            name[0],
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              infoTile(Icons.phone, "Phone", phone),

              infoTile(Icons.email, "Email", email),

              infoTile(Icons.person, "Role", role),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: saving ? null : saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Profile",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
