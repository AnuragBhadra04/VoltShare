import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../permissions/permission_screen.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class PhoneDetailsScreen extends StatefulWidget {
  const PhoneDetailsScreen({super.key});

  @override
  State<PhoneDetailsScreen> createState() => _PhoneDetailsScreenState();
}

class _PhoneDetailsScreenState extends State<PhoneDetailsScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  bool _loading = false;

  // =====================================================
  // INIT ANIMATION
  // =====================================================
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  // =====================================================
  // DISPOSE
  // =====================================================
  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // =====================================================
  // DEV MODE LOGIN (BYPASS OTP)
  // =====================================================
  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final age = _ageController.text.trim();

      // Create fake user locally
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        phone: phone,
        email: null,
        photoUrl: null,
        role: null,
        createdAt: DateTime.now(),
      );

      // Save locally
      await UserService.saveUser(user);

      if (!mounted) return;

      // Go to Permission Screen directly
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PermissionScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => _loading = false);
  }

  // =====================================================
  // UI
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.titleText),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),

          child: FadeTransition(
            opacity: _fade,

            child: SlideTransition(
              position: _slide,

              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Form(
                  key: _formKey,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleText,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // NAME
                      _field(
                        controller: _nameController,
                        hint: 'Full Name',
                        icon: Icons.person,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter your name' : null,
                      ),

                      const SizedBox(height: 16),

                      // AGE
                      _field(
                        controller: _ageController,
                        hint: 'Age',
                        icon: Icons.cake,
                        keyboard: TextInputType.number,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter age' : null,
                      ),

                      const SizedBox(height: 16),

                      // PHONE
                      _field(
                        controller: _phoneController,
                        hint: 'Phone Number',
                        icon: Icons.phone,
                        keyboard: TextInputType.phone,
                        validator: (v) => v == null || v.length != 10
                            ? 'Enter valid phone number'
                            : null,
                      ),

                      const SizedBox(height: 28),

                      // BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 54,

                        child: ElevatedButton(
                          onPressed: _loading ? null : _continue,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),

                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // TEXT FIELD
  // =====================================================
  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: validator,

      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
