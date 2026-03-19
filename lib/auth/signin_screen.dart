import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';
import '../services/role_service.dart';

import '../consumer/consumer_home_screen.dart';
import '../provider/provider_home_screen.dart';
import 'signup_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;
  bool loading = false;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    /// Listen for Google login success
    supabase.auth.onAuthStateChange.listen((data) async {
      final session = data.session;

      if (session != null && mounted) {
        await AuthService.createUserProfileIfNotExists();

        _goToHome();
      }
    });
  }

  // ===============================
  // EMAIL LOGIN
  // ===============================
  Future<void> signIn() async {
    try {
      setState(() => loading = true);

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final response = await AuthService.signInWithEmail(email, password);

      if (response.session != null) {
        await AuthService.createUserProfileIfNotExists();

        _goToHome();
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login error: $e")));
    }

    setState(() => loading = false);
  }

  // ===============================
  // GOOGLE LOGIN
  // ===============================
  Future<void> googleLogin() async {
    try {
      await AuthService.signInWithGoogle();
    } catch (e) {
      print(e);
    }
  }

  // ===============================
  // NAVIGATE HOME
  // ===============================
  Future<void> _goToHome() async {
    final role = await RoleService.getRole();

    if (!mounted) return;

    if (role == "provider") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ConsumerHomeScreen()),
      );
    }
  }

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),

            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/app_logo2.png",
                      height: 200,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  /// EMAIL
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// PASSWORD
                  TextField(
                    controller: passwordController,
                    obscureText: hidePassword,

                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock),

                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),

                      filled: true,
                      fillColor: Colors.white,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed: loading ? null : signIn,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6C63FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Center(child: Text("OR")),

                  const SizedBox(height: 20),

                  /// GOOGLE LOGIN
                  GestureDetector(
                    onTap: googleLogin,

                    child: Container(
                      width: double.infinity,
                      height: 55,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.08),
                            blurRadius: 8,
                          ),
                        ],
                      ),

                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.g_mobiledata, size: 28),

                          SizedBox(width: 10),

                          Text(
                            "Continue with Google",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// SIGNUP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          );
                        },

                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff6C63FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
