import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/colors.dart';
import '../services/auth_service.dart';
import 'phone_details_screen.dart';
import '../permissions/permission_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  bool _loading = false;

  // =====================================================
  // GOOGLE SIGN IN WITH SUPABASE
  // =====================================================
  Future<void> _signInWithGoogle() async {
    try {
      setState(() => _loading = true);

      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: null, // mobile handles automatically
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PermissionScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Google login failed: $e")));
    }

    setState(() => _loading = false);
  }

  // =====================================================
  // PHONE LOGIN FLOW
  // =====================================================
  void _continueWithPhone() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PhoneDetailsScreen()),
    );
  }

  // =====================================================
  // UI
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),

          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Text(
                  'Welcome to VoltShare',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleText,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Create an account to continue',
                  style: TextStyle(color: AppColors.subtitleText),
                ),

                const SizedBox(height: 32),

                // =====================================================
                // GOOGLE SIGN IN
                // =====================================================
                SizedBox(
                  width: double.infinity,
                  height: 54,

                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.g_mobiledata, size: 28),

                    label: _loading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Continue with Google',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                    onPressed: _loading ? null : _signInWithGoogle,

                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // =====================================================
                // PHONE LOGIN
                // =====================================================
                SizedBox(
                  width: double.infinity,
                  height: 54,

                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.phone),

                    label: const Text(
                      'Continue with Phone',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    onPressed: _continueWithPhone,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
