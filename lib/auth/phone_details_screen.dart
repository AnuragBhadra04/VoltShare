import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../permissions/permission_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  bool _loading = false;
  bool rememberMe = true;
  bool hidePassword = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // =====================================================
  // GOOGLE LOGIN
  // =====================================================
  Future<void> _signInWithGoogle() async {
    try {
      setState(() => _loading = true);

      await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);

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
  // UI
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F5F7),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LOGO
                  Center(
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff5B6CF0), Color(0xff4ED0C4)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bolt,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "VoltShare",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Sign in",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  // EMAIL FIELD
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "abc@email.com",
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // PASSWORD FIELD
                  TextField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      hintText: "Your password",
                      prefixIcon: const Icon(Icons.lock_outline),
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

                  const SizedBox(height: 10),

                  // REMEMBER ME + FORGOT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Switch(
                            value: rememberMe,
                            onChanged: (v) {
                              setState(() => rememberMe = v);
                            },
                          ),
                          const Text("Remember Me"),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Forgot Password?"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // SIGN IN BUTTON
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff5B6CF0), Color(0xff6C63FF)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "SIGN IN",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Center(
                    child: Text("OR", style: TextStyle(color: Colors.grey)),
                  ),

                  const SizedBox(height: 20),

                  // GOOGLE SIGN IN BUTTON
                  SignInButton(
                    Buttons.Google,
                    text: "Sign in with Google",
                    onPressed: _loading ? null : _signInWithGoogle,
                  ),

                  const SizedBox(height: 10),

                  // FACEBOOK BUTTON
                  SignInButton(
                    Buttons.Facebook,
                    text: "Login with Facebook",
                    onPressed: () {},
                  ),

                  const SizedBox(height: 25),

                  // SIGN UP
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an account? "),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              color: Color(0xff5B6CF0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
