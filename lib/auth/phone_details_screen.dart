import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import 'otp_screen.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

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

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ✅ FIXED ONCE AND FOR ALL
  Future<void> _continue() async {
    if (_formKey.currentState!.validate()) {
      // 🔹 SAVE USER PROFILE (PHONE LOGIN)
      await UserService.saveUser(
        UserModel(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        ),
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OTPScreen()),
      );
    }
  }

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

                      _field(
                        controller: _nameController,
                        hint: 'Full Name',
                        icon: Icons.person,
                        validator: (v) => v!.isEmpty ? 'Enter your name' : null,
                      ),

                      const SizedBox(height: 16),

                      _field(
                        controller: _ageController,
                        hint: 'Age',
                        icon: Icons.cake,
                        keyboard: TextInputType.number,
                        validator: (v) {
                          if (v!.isEmpty) return 'Enter age';
                          final age = int.tryParse(v);
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      _field(
                        controller: _phoneController,
                        hint: 'Phone Number',
                        icon: Icons.phone,
                        keyboard: TextInputType.phone,
                        validator: (v) =>
                            v!.length != 10 ? 'Enter valid phone number' : null,
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _continue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Send OTP',
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
